//
//  locationVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import CoreLocation

class locationVC: UIViewController, CLLocationManagerDelegate, lostLink {
  func incoming(ipaddr: String) {
    // ignore
  }
  

  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  

 
  
  var locationManager: CLLocationManager?
  var currentLocation: CLLocation!
  var infoText: UILabel!
  var tag:Int?
  var status:running?
  
 
  
  @IBOutlet weak var latitudeOutput: UILabel!
  @IBOutlet weak var longitudeOutput: UILabel!
  @IBOutlet weak var altitudeOutput: UILabel!
 
  @IBOutlet weak var locationBPass: UISwitch!
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var auxLabel: UILabel!
  @IBOutlet weak var auxtext: UILabel!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var mainText: UILabel!
  
  @IBAction func backButtonAction(_ sender: UIButton) {
    if locationButtonOutlet.isOn {
      performSegue(withIdentifier: "sensorCodeMM", sender: nil)
    } else {
      if port2G != nil && connect2G != nil {
        let alert = UIAlertController(title: "Did you forget to TURN ON reporting?", message: "Confirm", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
          DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
          })
          }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
          self.turnOn()
          self.locationButtonOutlet.setOn(true, animated: true)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
          })
        }))
        self.present(alert, animated: true)
      }
      
    }
  }
  
  func turnOn() {
    self.latitudeOutput.text = "-122.03073097"
    self.longitudeOutput.text = "37.33121136"
    self.altitudeOutput.text = "0"

    superRec2?.position?.altitude = "\(self.altitudeOutput.text!)"
    superRec2?.position?.longitude = "\(self.longitudeOutput.text!)"
    superRec2?.position?.latitude = "\(self.latitudeOutput.text!)"
    
    if port2G != nil && connect2G != "" {
      if pulse != nil {
        // send only is pulse if off or azimuthPass is on
        if pulse! == false {
          communications?.pulseUDP2(superRec2)
        }
        if pulse! == true && locationBPass.isOn {
          communications?.pulseUDP2(superRec2)
        }
      }
    }
  }
  
  
  @IBOutlet weak var locationButtonOutlet: UISwitch!
  @IBAction func locationSwitch(_ sender: UISwitch) {
    if sender.isOn {
      turnOn()
    } else {
      if variable! {
        superRec2?.position?.altitude = nil
        superRec2?.position?.longitude = nil
        superRec2?.position?.latitude = nil
      } else {
        superRec2?.position?.altitude = ""
        superRec2?.position?.longitude = ""
        superRec2?.position?.latitude = ""
      }
    }
  }
  
  func real_turnOn() {
    locationManager!.startUpdatingLocation()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
    if self.currentLocation != nil {
      self.latitudeOutput.text = "\(self.currentLocation.coordinate.longitude.description)"
      self.longitudeOutput.text = "\(self.currentLocation.coordinate.latitude.description)"
      self.altitudeOutput.text = "\(self.currentLocation.altitude.description)"
    }
    if self.currentLocation != nil {
      superRec2?.position?.altitude = "\(self.currentLocation.altitude)"
      superRec2?.position?.longitude = "\(self.currentLocation.coordinate.longitude)"
      superRec2?.position?.latitude = "\(self.currentLocation.coordinate.latitude)"
            if port2G != nil && connect2G != "" {
        if pulse != nil {
          // send only is pulse if off or azimuthPass is on
          if pulse! == false {
            communications?.pulseUDP2(superRec2)
          }
          if pulse! == true && self.locationBPass.isOn {
            communications?.pulseUDP2(superRec2)
          }
        }
      }
    }
    })
  }
  
  func realSwitch(_ sender: UISwitch) {
    if sender.isOn {
      locationBPass.isEnabled = true
      real_turnOn()
    } else {
      locationManager!.stopUpdatingLocation()
      if variable! {
        superRec2?.position?.altitude = nil
        superRec2?.position?.longitude = nil
        superRec2?.position?.latitude = nil
      } else {
        superRec2?.position?.altitude = ""
        superRec2?.position?.longitude = ""
        superRec2?.position?.latitude = ""
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      if pulse == false {
        locationBPass.isHidden = true
        auxLabel.isHidden = true
        auxtext.isHidden = true
      }
      if locationButtonOutlet.isOn == false {
        locationBPass.isEnabled = false
      }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    locationButtonOutlet.grow()
  }
  
  func setupTaps() {
        let passTap = customTap(target: self, action: #selector(locationVC.showTap(sender:)))
    //    let passTap = customTap(target: self, action: #selector(azimuthVC.debug(sender:)))
        passTap.sender = "TURN ON in PULSE mode to send data outside of the polling window."
        passTap.label = auxtext
        auxLabel.addGestureRecognizer(passTap)
        auxLabel.isUserInteractionEnabled = true
        auxLabel.numberOfLines = 0
        
        let mainTap = customTap(target: self, action: #selector(locationVC.showTap(sender:)))
        mainTap.sender = "TURN ON the Main Switch to start the sensor reporting."
        mainTap.label = mainText
        mainLabel.addGestureRecognizer(mainTap)
        mainLabel.isUserInteractionEnabled = true
        mainLabel.numberOfLines = 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTaps()
    let passTap = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    passTap.sender = "True changes the default behaviour of PULSE, will send additional data if changes seen."
    passTap.label = infoText
    locationBPass.addGestureRecognizer(passTap)
    locationBPass.isUserInteractionEnabled = true
    
//    primeController.said = self
    locationManager = CLLocationManager()
    locationManager!.requestWhenInUseAuthorization()
    
    if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
      CLLocationManager.authorizationStatus() ==  .authorizedAlways){
      
      locationManager!.delegate = self
      locationManager!.distanceFilter = kCLDistanceFilterNone
      locationManager!.desiredAccuracy = kCLLocationAccuracyBest
      locationManager!.pausesLocationUpdatesAutomatically = true
      currentLocation = locationManager!.location
      
      
    }
    
    infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
        infoText.isUserInteractionEnabled = true
    //    infoText.addGestureRecognizer(swipeUp)
        infoText.numberOfLines = 0
        infoText.textAlignment = .justified
        self.view.addSubview(infoText)
        
        infoText.text = "Looks to the gps hardware to get a location, sends it out as a tuple. The first value longitude, second value, latitude, third value altitude."
//        infoText.font = UIFont.preferredFont(forTextStyle: .body)
        infoText.font = UIFont(name: "Futura-CondensedMedium", size: 17)
        infoText.adjustsFontForContentSizeCategory = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
          UIView.animate(withDuration: 1) {
            self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY - 256)
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.infoText.isHidden = true
            self.backButton.blinkText()
          })
        })
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
      currentLocation = locationManager!.location
      latitudeOutput.text = "\(currentLocation.coordinate.latitude.description)"
      longitudeOutput.text = "\(currentLocation.coordinate.longitude.description)"
      altitudeOutput.text = "\(currentLocation.altitude.description)"
//      let word = "\(currentLocation.coordinate.longitude) \(currentLocation.coordinate.latitude) \(currentLocation.altitude)"
//      let word = gps(latitude: "\(currentLocation.coordinate.latitude)", longitude: "\(currentLocation.coordinate.longitude)", altitude: "\(currentLocation.altitude)")
      if port2G != nil && connect2G != "" {
//          communications?.sendUDP(word)
          
//          superRec?.latitude = "\(currentLocation.coordinate.latitude.description)"
//          superRec?.longitude = "\(currentLocation.coordinate.longitude.description)"
//          superRec?.altitude = "\(currentLocation.altitude.description)"
          superRec2?.position?.altitude = "\(currentLocation.coordinate.latitude.description)"
          superRec2?.position?.longitude = "\(currentLocation.coordinate.longitude.description)"
          superRec2?.position?.latitude = "\(currentLocation.coordinate.latitude.description)"
          communications?.pulseUDP2(superRec2)
      }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location Fail")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if autoClose! {
      locationManager!.stopUpdatingLocation()
      locationButtonOutlet?.setOn(false, animated: false)
    }
    lastSwitch = locationButtonOutlet
    if lastSwitch!.isOn {
      status?.turnOn(views2G: self.tag!)
    } else {
      status?.turnOff(views2G: self.tag!)
    }
  }
  
  @objc func showTap(sender: Any) {
      let tag = sender as? customTap
      let label = tag!.label as? UILabel
      let textFeed = tag!.sender as? String
      showText(label: label!, text: textFeed!)
    }
    
    @objc func showPress(sender: Any) {
      print("SP")
      let tag = sender as? customLongPress
      let label = tag!.label as? UILabel
      let textFeed = tag!.sender as? String
      if tag?.state == .ended {
        showText(label: label!, text: textFeed!)
      }
    }
    
    var running = false
    private var paused = DispatchTimeInterval.seconds(12)
    
    func showText(label: UILabel, text: String) {
      if running { return }
      running = true
      label.text = ""
      label.alpha = 1
      label.preferredMaxLayoutWidth = self.view.bounds.width - 40
  //    label.font = UIFont.preferredFont(forTextStyle: .body)
      label.font = UIFont(name: "Futura-CondensedMedium", size: 17)
      label.adjustsFontForContentSizeCategory = true
      label.isHidden = false
      label.textAlignment = .center
      label.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
      label.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 112)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        let words = Array(text)
        var i = 0
        let pause = 0.1
        
        let tweek = label.text?.count
        let delay = pause * Double(tweek!)
        
        self.paused = DispatchTimeInterval.seconds(Int(delay + 4))
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
          
          label.text = label.text! + String(words[i])
          if i == words.count - 1 {
            timer.invalidate()
            self.running = false
            UIView.animate(withDuration: 12, animations: {
            label.alpha = 0
            }) { (action) in
              // do nothing
            }

          } else {
            i = i + 1
            
          }
        }
      })
    }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.performSegue(withIdentifier: "photo", sender: self)
    }
  }
  
}

extension UISwitch {
  func highlight() {
    var blinkCount = 0
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if blinkCount < 8 {
              blinkCount = blinkCount + 1
              if self.isSelected {
                  self.isSelected = false
              } else {
                  self.isSelected = true
              }
            } else {
              self.self.isSelected = false
              timer.invalidate()
            }
        }
  }
  
  func grow() {
    self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    UIView.animate(withDuration: 1.0,
    delay: 0,
    usingSpringWithDamping: 0.2,
    initialSpringVelocity: 2.0,
    options: .allowUserInteraction,
    animations: { [weak self] in
      self!.transform = .identity
    },
    completion: nil)
  }
}

   
  


