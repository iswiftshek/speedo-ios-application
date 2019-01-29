//
//  ViewController.swift
//  SpeedoAlert
//
//  Created by Abhishek Sansanwal on 20/01/19.
//  Copyright © 2019 Verved. All rights reserved.
//

import UIKit
import CoreLocation
//import AVFoundation
import MapKit
import AudioToolbox
import MBCircularProgressBar
import UserNotifications
import SizeSlideButton

class ViewController: UIViewController {
    
    var speedHelper = 0.0
    var speed: Double = 70.0
    let defaults = UserDefaults()
    //var speed = defaults.integer(forKey: "speed")
  
    var helperSpeed = 0.0
    var displaySpeed = 0.0
    //var player: AVAudioPlayer?
  
    private var locations: [MKPointAnnotation] = []
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        
        if switchButton.isOn == true {
            locationManager.startUpdatingLocation()
            
        }
        else {
            UIView.animate(withDuration: 1) {
                self.speedoMeter.value = CGFloat(0)
                self.speedoMeter.progressColor = UIColor.orange
            }
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var fancyControl: SizeSlideButton!
    @IBOutlet weak var sliderBar: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedoMeter: MBCircularProgressBarView!
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self as CLLocationManagerDelegate
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    @IBOutlet weak var bottomView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        fancyControl.handlePadding = 10
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.double(forKey: "speed") as? Double {
            speed = x
            sliderBar.text = "Max Speed: \(Int(speed)) Kmph"
            fancyControl.value = Float(speed-20)/100
        }
    }
    
    
    
    override func viewDidLoad() {

        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        speedHelper = speed
        switchButton.isOn = false
        super.viewDidLoad()
        
        //requesting for authorization
        
        //let condensedFrame = CGRect(x: self.view.frame.size.width - 10 - bottomView.frame.size.height, y: 10, width: bottomView.frame.size.height - 18, height: bottomView.frame.size.height - 18) //Width and Height should be equal
        
     
        fancyControl.handleColor = UIColor.orange
        fancyControl.handlePadding = 10
        fancyControl.addTarget(self, action: #selector(newSizeSelected), for: .touchDragExit)
        fancyControl.addTarget(self, action: #selector(sizeSliderTapped), for: .touchUpInside)
        fancyControl.addTarget(self, action: #selector(sizeSliderTapped2), for: .touchDown)
        fancyControl.addTarget(self, action: #selector(sizeSliderTapped3), for: .valueChanged)
        fancyControl.handlePadding = 10
        fancyControl.value = Float(speed-20/100)
        print(fancyControl.currentState)
       
        
        
     
        //
        speedoMeter.value = 0
        speedoMeter.valueFontSize = 0
        speedLabel.text = "0 Kmph"
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var stringState = "\(fancyControl.currentState)"
        if stringState != "condensed"{
            print(fancyControl.value)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var stringState = "\(fancyControl.currentState)"
        if stringState != "condensed"{
            print(fancyControl.value)
        }
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        var stringState = "\(fancyControl.currentState)"
        if stringState != "condensed"{
            print(fancyControl.value)
        }
    }
    
    @objc func newSizeSelected(_ sender: SizeSlideButton){
        //Do something once a size is selected and the control let go
        // You can now use the senders .value for a value between 0 and 1
        // Or use the handle's height (handle.height) as a multiplier for size
        print("Value: \(sender.value)")
        print("Size multiplier: \(sender.handle.height)")
        UIView.animate(withDuration: 1) {
            self.fancyControl.alpha = 1
            self.fancyControl.trackColor.withAlphaComponent(1)
        }
        
        
        // Ex: self.paintbrush.brushSize = kDefaultBrushSize * sender.handle.height
    }
    
    @objc func sizeSliderTapped(_ sender: SizeSlideButton){
        //Do something when the button is tapped
        print("Tip Tap")
        print(sender.value)
    }
    
    @objc func sizeSliderTapped2(_ sender: SizeSlideButton){
        
        //var stringState = "\(fancyControl.currentState)"
       print("Value: \(sender.value)")
      
            fancyControl.alpha = 0.3
            fancyControl.trackColor.withAlphaComponent(0.5)
        
    }
    
    
    @objc func sizeSliderTapped3(_ sender: SizeSlideButton){
        //DO SOMETHING TO GET THE VALUE OF FANCY CONTROL AT ALL TIMES
        print(sender.value)
        speed = Double((sender.value*100) + 20)
        UserDefaults.standard.set(speed,forKey: "speed")
        speedHelper = speed
        sliderBar.text = "Max Speed: \(Int(sender.value*100) + 20) Kmph"
        
    }
    
    
    
    func notifyUser(){
        
        
        
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "SLOW DOWN"
       // content.subtitle = "Speed limit crossed"
        content.body = "Speed limit crossed!"
        content.sound = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName(rawValue: "sound.mp3"))
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    
    
    func checkSpeed() {
        if displaySpeed > speed {
            notifyUser()
            print(helperSpeed)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
      //print(mostRecentLocation.coordinate)
        helperSpeed = mostRecentLocation.speed
        displaySpeed = helperSpeed*(18/5)
        print(displaySpeed)
        
        checkSpeed()
        
        let helperVariablePercentage = (self.helperSpeed/(self.speed*5/18))*100
        
        if displaySpeed > speed {
            speedLabel.text = "Slow down!"
            speedLabel.shake()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            speedLabel.textColor = UIColor.red
            UIView.animate(withDuration: 1) {
                self.speedoMeter.value = CGFloat(100)
                self.speedoMeter.progressColor = UIColor.red
            }
        }
        if displaySpeed < 0 {
            speedLabel.textColor = UIColor.black
            speedLabel.text = "0 Kmph"
            UIView.animate(withDuration: 1) {
                self.speedoMeter.value = CGFloat(0)
                self.speedoMeter.progressColor = UIColor.orange
            }
        }
        
        else if displaySpeed <= speed {
            speedLabel.textColor = UIColor.black
            let intNum = Int(displaySpeed)
            speedLabel.text = "\(intNum) Kmph"
        UIView.animate(withDuration: 1) {
            self.speedoMeter.value = CGFloat(helperVariablePercentage)
            self.speedoMeter.progressColor = UIColor.orange
        }
        }
        
        
        
        
        // Remove values if the array is too big
        while locations.count > 100 {
            self.locations.removeAll()
            
            // Also remove from the map
           
        }
        
        if UIApplication.shared.applicationState == .active {
            print(self.locations)
        } else {
            print("App is backgrounded. New location is %@", mostRecentLocation)
        }
    }
    
}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

