//
//  locationVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import CoreLocation

class locationVC: UIViewController, CLLocationManagerDelegate, spoken {

  func wordUsed(word2D: String) {
    
    spokenOutput.text = word2D
  }
  
  var locationManager: CLLocationManager?
  var currentLocation: CLLocation!
  var infoText: UILabel!
  var tag:Int?
  
  @IBOutlet weak var latitudeOutput: UILabel!
  @IBOutlet weak var longitudeOutput: UILabel!
  @IBOutlet weak var altitudeOutput: UILabel!
  @IBOutlet weak var spokenOutput: UILabel!
  @IBOutlet weak var backButton: UIButton!
  
  
  
  
  @IBOutlet weak var locationButtonOutlet: UISwitch!
  @IBAction func locationSwitch(_ sender: UISwitch) {
    if sender.isOn {
      self.latitudeOutput.text = "-122.03073097"
      self.longitudeOutput.text = "37.33121136"
      self.altitudeOutput.text = "0"
      let word = "-122.03073097 37.33121136 0.0"
      communications?.sendUDP(word)
//      locationManager!.startUpdatingLocation()
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//      if self.currentLocation != nil {
//        self.latitudeOutput.text = "\(self.currentLocation.coordinate.longitude.description)"
//        self.longitudeOutput.text = "\(self.currentLocation.coordinate.latitude.description)"
//        self.altitudeOutput.text = "\(self.currentLocation.altitude.description)"
//      }
//      if self.currentLocation != nil {
//        let word = "\(self.currentLocation.coordinate.latitude) \(self.currentLocation.coordinate.longitude) \(self.currentLocation.altitude)"
//        if port2G != nil && connect2G != "" {
//          communications?.sendUDP(word)
//        }
//      }
//      })
    } else {
      locationManager!.stopUpdatingLocation()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    spokenOutput.text = ""
    locationButtonOutlet.grow()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    primeController.said = self
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
        infoText.font = UIFont.preferredFont(forTextStyle: .body)
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
      latitudeOutput.text = "\(currentLocation.coordinate.longitude.description)"
      longitudeOutput.text = "\(currentLocation.coordinate.latitude.description)"
      altitudeOutput.text = "\(currentLocation.altitude.description)"
      let word = "\(currentLocation.coordinate.longitude) \(currentLocation.coordinate.latitude) \(currentLocation.altitude)"
      
      if port2G != nil && connect2G != "" {
          communications?.sendUDP(word)
      }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("Location Fail")
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if autoClose! {
      locationManager!.stopUpdatingLocation()
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
    print("grow",self)
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

   
  


