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
  
  
  
  
  @IBOutlet weak var locationButtonOutlet: UISwitch!
  @IBAction func locationSwitch(_ sender: UISwitch) {
    if sender.isOn {
      self.latitudeOutput.text = "-122.03073097"
      self.longitudeOutput.text = "37.33121136"
      self.altitudeOutput.text = "0"
//      let word = "-122.03073097 37.33121136 0.0"
//      let word = gps(latitude: "\(self.latitudeOutput.text!)", longitude: "\(self.longitudeOutput.text!)", altitude: "\(self.altitudeOutput.text!)")
//      communications?.sendUDP(word)
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
      
//      superRec?.latitude = "\(self.latitudeOutput.text!)"
//      superRec?.longitude = "\(self.longitudeOutput.text!)"
//      superRec?.altitude = "\(self.longitudeOutput.text!)"
    } else {
//      superRec?.latitude = nil
//      superRec?.longitude = nil
//      superRec?.altitude = nil
      superRec2?.position?.altitude = nil
      superRec2?.position?.longitude = nil
      superRec2?.position?.latitude = nil
    }
  }
  
  func realSwitch(_ sender: UISwitch) {
    if sender.isOn {
      locationManager!.startUpdatingLocation()
      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
      if self.currentLocation != nil {
        self.latitudeOutput.text = "\(self.currentLocation.coordinate.longitude.description)"
        self.longitudeOutput.text = "\(self.currentLocation.coordinate.latitude.description)"
        self.altitudeOutput.text = "\(self.currentLocation.altitude.description)"
      }
      if self.currentLocation != nil {
//        let word = "\(self.currentLocation.coordinate.latitude) \(self.currentLocation.coordinate.longitude) \(self.currentLocation.altitude)"
//        let word = gps(latitude: "\(self.currentLocation.coordinate.latitude)", longitude: "\(self.currentLocation.coordinate.longitude)", altitude: "\(self.currentLocation.altitude)")
        superRec2?.position?.altitude = "\(self.currentLocation.altitude)"
        superRec2?.position?.longitude = "\(self.currentLocation.coordinate.longitude)"
        superRec2?.position?.latitude = "\(self.currentLocation.coordinate.latitude)"
        if port2G != nil && connect2G != "" {
          communications?.pulseUDP2(superRec2)
        }
      }
      })
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
  
  override func viewDidAppear(_ animated: Bool) {
    
    locationButtonOutlet.grow()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
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

   
  


