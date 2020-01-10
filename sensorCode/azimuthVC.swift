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
  
  var bPass:Bool? = false
  var tag:Int?
  var status:running?
  var directionManager: CLLocationManager?
  
  @IBOutlet var compassSwitchOutlet: UISwitch!
  @IBOutlet weak var magneticNorthOutlet: UILabel!
  @IBOutlet weak var trueNorthOutlet: UILabel!
  @IBOutlet weak var azimuthBPass: UISwitch!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var bPassLabel: UILabel!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var bPassText: UILabel!
  @IBOutlet weak var moreText: UILabel!
  
  @IBAction func backButtonAction(_ sender: UIButton) {
    if compassSwitchOutlet.isOn {
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
          self.compassSwitchOutlet.setOn(true, animated: true)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
          })
        }))
        self.present(alert, animated: true)
      }
      
    }
  }
  
  func turnOn() {
    directionManager?.startUpdatingHeading()
    azimuthBPass.isEnabled = true
  }
  
  @IBAction func compassSwitch(_ sender: UISwitch) {
    if sender.isOn {
      turnOn()
    } else {
      directionManager?.stopUpdatingHeading()
      if variable! {
        superRec2?.direction?.magneticNorth = nil
        superRec2?.direction?.trueNorth = nil
      } else {
        superRec2?.direction?.magneticNorth = ""
        superRec2?.direction?.trueNorth = ""
      }
    }
  }
  
  var infoText: UILabel!

  
  //    var heading:String!ager
  //    var lastLocation: CLLocation!
  
  private var background = false
  
  override func viewWillAppear(_ animated: Bool) {
    if pulse == false {
      azimuthBPass.isHidden = true
      bPassLabel.isHidden = true
      bPassText.isHidden = true
    }
    if compassSwitchOutlet.isOn == false {
      azimuthBPass.isEnabled = false
    }
}
  
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
  
  @objc func debug(sender: Any) {
      print("debug")
//    let tag = sender as? customTap
//    let label = tag!.label as? UILabel
//    let textFeed = tag!.sender as? String
//    showText(label: label!, text: textFeed!)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let passTap = customTap(target: self, action: #selector(azimuthVC.showTap(sender:)))
//    let passTap = customTap(target: self, action: #selector(azimuthVC.debug(sender:)))
    passTap.sender = "TURN ON in PULSE mode to send data outside of the polling window."
    passTap.label = bPassText
    bPassLabel.addGestureRecognizer(passTap)
    bPassLabel.isUserInteractionEnabled = true
    bPassLabel.numberOfLines = 0
    
    let mainTap = customTap(target: self, action: #selector(azimuthVC.showTap(sender:)))
    //    let passTap = customTap(target: self, action: #selector(azimuthVC.debug(sender:)))
        mainTap.sender = "TURN ON the Main Switch to start the sensor reporting."
        mainTap.label = moreText
        mainLabel.addGestureRecognizer(mainTap)
        mainLabel.isUserInteractionEnabled = true
        mainLabel.numberOfLines = 0
    
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
    
    if port2G != nil && connect2G != "" {
      if pulse != nil {
        // send only is pulse if off or azimuthPass is on
        if pulse! == false {
          communications?.pulseUDP2(superRec2)
        }
        if pulse! == true && azimuthBPass.isOn {
          communications?.pulseUDP2(superRec2)
        }
      }
    }
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



