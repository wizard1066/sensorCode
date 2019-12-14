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
  
  @IBOutlet weak var latitudeOutput: UILabel!
  @IBOutlet weak var longitudeOutput: UILabel!
  @IBOutlet weak var altitudeOutput: UILabel!
  @IBOutlet weak var spokenOutput: UILabel!
 
  
  
  @IBAction func locationSwitch(_ sender: UISwitch) {
    if sender.isOn {
      locationManager!.startUpdatingLocation()
      if currentLocation != nil {
        let word = "\(currentLocation.coordinate.longitude) \(currentLocation.coordinate.latitude) \(currentLocation.altitude)"
        if port2G != nil && connect2G != "" {
          communications?.sendUDP(word)
        }
      }
    } else {
      locationManager!.stopUpdatingLocation()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    spokenOutput.text = ""
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
      
      if currentLocation != nil {
        latitudeOutput.text = "\(currentLocation.coordinate.longitude.description)"
        longitudeOutput.text = "\(currentLocation.coordinate.latitude.description)"
        altitudeOutput.text = "\(currentLocation.altitude.description)"
      }
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

   
  


