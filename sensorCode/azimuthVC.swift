//
//  compassVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import CoreLocation

class azimuthVC: UIViewController, CLLocationManagerDelegate, lostLink {
  func incoming(ipaddr: String) {
    // ignore
  }
  

  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }

  var tag:Int?
  var status:running?
  var directionManager: CLLocationManager?
  
  @IBOutlet var compassSwitchOutlet: UISwitch!
  @IBOutlet weak var magneticNorthOutlet: UILabel!
  @IBOutlet weak var trueNorthOutlet: UILabel!
 
  @IBOutlet weak var backButton: UIButton!
  
  
  
  @IBAction func compassSwitch(_ sender: UISwitch) {
    if sender.isOn {
      directionManager?.startUpdatingHeading()
    } else {
      directionManager?.stopUpdatingHeading()
//      superRec?.trueNorth = nil
//      superRec?.magneticNorth = nil
      superRec2?.direction?.magneticNorth = nil
      superRec2?.direction?.trueNorth = nil
    }
  }
  
   var infoText: UILabel!
//   var locationManager: CLLocationManager?
  
//    var heading:String!ager
//    var lastLocation: CLLocation!

  private var background = false

  override func viewDidAppear(_ animated: Bool) {
    
    if !background {
      let backgroundImage = UIImageView(frame: self.view.bounds)
      backgroundImage.alpha = 0
      backgroundImage.contentMode = .scaleAspectFit
      self.view.insertSubview(backgroundImage, at: 0)
      UIView.animate(withDuration: 0.5, animations: {
        backgroundImage.image = UIImage(named: "lego.png")!
        backgroundImage.alpha = 0.2
        self.background = true
      }) { ( _ ) in
        self.compassSwitchOutlet.grow()
      }
    }
    
  }

      override func viewDidLoad() {
          super.viewDidLoad()
          
        if directionManager == nil {
          directionManager = CLLocationManager()
          directionManager!.delegate = self
          directionManager!.requestWhenInUseAuthorization()
          
          // Do any additional setup after loading the view.
          
//          primeController.said = self
          
          
          infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
          infoText.isUserInteractionEnabled = true
          //    infoText.addGestureRecognizer(swipeUp)
          infoText.numberOfLines = 0
          infoText.textAlignment = .justified
          self.view.addSubview(infoText)
          
          infoText.text = "Sends a stream of tuples of data, as the value changes. The first value is the true north, the second the magnetic north."
//          infoText.font = UIFont.preferredFont(forTextStyle: .body)
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
        
        superRec2?.direction?.magneticNorth = mNValue
        superRec2?.direction?.trueNorth = tNValue
//        let word = "\(tNValue)" + " \(mNValue)"
//          let word = globe(trueNorth: tNValue, magneticNorth: mNValue)
        
          if port2G != nil && connect2G != "" {
//            communications?.sendUDP(word)
            communications?.pulseUDP2(superRec2)
          }
//          superRec?.trueNorth = tNValue
//          superRec?.magneticNorth = mNValue
          
      }
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let currentLocation = locations.last else { return }
//        lastLocation = currentLocation // store this location somewhere
        
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if autoClose! {
          directionManager!.stopUpdatingHeading()
          directionManager = nil
          compassSwitchOutlet.setOn(false, animated: false)
        }
        lastSwitch = compassSwitchOutlet
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
  
      
  extension CGFloat {
    var toRadians: CGFloat { return self * .pi / 180 }
    var toDegrees: CGFloat { return self * 180 / .pi }
  }

  extension Double {
    var toRadians: Double { return self * .pi / 180 }
    var toDegrees: Double { return self * 180 / .pi }
  }
  


