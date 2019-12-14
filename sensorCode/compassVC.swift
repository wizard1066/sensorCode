//
//  compassVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import CoreLocation

class compassVC: UIViewController, CLLocationManagerDelegate, spoken {

  func wordUsed(word2D: String) {
    
      spokenOutput.text = word2D
    
  }
  
  @IBOutlet var compassSwitchOutlet: UISwitch!
  @IBOutlet weak var magneticNorthOutlet: UILabel!
  @IBOutlet weak var trueNorthOutlet: UILabel!
  @IBOutlet weak var spokenOutput: UILabel!

  
  @IBAction func compassSwitch(_ sender: UISwitch) {
    if sender.isOn {
      directionManager!.startUpdatingHeading()
      
    } else {
      directionManager!.stopUpdatingHeading()
      
    }
  }
  
   var infoText: UILabel!
//   var locationManager: CLLocationManager?
  
//    var heading:String!ager
//    var lastLocation: CLLocation!

  override func viewDidAppear(_ animated: Bool) {
    spokenOutput.text = ""
  }

      override func viewDidLoad() {
          super.viewDidLoad()
          
        if directionManager == nil {
          directionManager = CLLocationManager()
          directionManager!.delegate = self
          directionManager!.requestWhenInUseAuthorization()
          
          // Do any additional setup after loading the view.
          
          primeController.said = self
          
          
          infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
          infoText.isUserInteractionEnabled = true
          //    infoText.addGestureRecognizer(swipeUp)
          infoText.numberOfLines = 0
          infoText.textAlignment = .justified
          self.view.addSubview(infoText)
          
          infoText.text = "Sends a stream of tuples of data, as the value changes. The first value is the true north, the second the magnetic north."
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
        } else {
          self.compassSwitchOutlet.isOn = true
          directionManager!.delegate = self
          directionManager!.stopUpdatingHeading()
          directionManager!.startUpdatingHeading()
        }
      }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
          
          directionManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//          locationManager.startUpdatingLocation()
//          locationManager.startUpdatingHeading()
        case .notDetermined:
          directionManager!.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .restricted, .denied:
          directionManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//          locationManager.startUpdatingLocation()
//          locationManager.startUpdatingHeading()
        @unknown default:
          print("crash")
        }
    }
      
      func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let tNValue = String(format:"%.\(precision!)f",newHeading.trueHeading)
        let mNValue = String(format:"%.\(precision!)f",newHeading.magneticHeading)
        
        if trueNorthOutlet != nil && magneticNorthOutlet != nil {
          trueNorthOutlet.text = tNValue
          magneticNorthOutlet.text = mNValue
        }
        let word = "\(tNValue)" + " \(mNValue)"
          if port2G != nil && connect2G != "" {
            communications?.sendUDP(word)
          }
      }
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let currentLocation = locations.last else { return }
//        lastLocation = currentLocation // store this location somewhere
        
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if autoClose! {
          directionManager!.stopUpdatingHeading()
          directionManager = nil
        }
       }
       
       override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
         if motion == .motionShake {
           self.performSegue(withIdentifier: "photo", sender: self)
         }
       }
    }
  
      
  extension CGFloat {
    var toRadians: CGFloat { return self * .pi / 180 }
    var toDegrees: CGFloat { return self * 180 / .pi }
  }

  extension Double {
    var toRadians: Double { return self * .pi / 180 }
    var toDegrees: Double { return self * 180 / .pi }
  }
  


