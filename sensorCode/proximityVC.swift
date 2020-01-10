//
//  proximityVC.swift
//  talkCode
//
//  Created by localadmin on 02.12.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit

class proximityVC: UIViewController, lostLink {
  func incoming(ipaddr: String) {
    // ignore
  }
  

  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  

  

    var infoText: UILabel!
    var tag:Int?
    var status: running?
    

  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var mainText: UILabel!
  
  @IBOutlet weak var proximitySwitchOutlet: UISwitch!
  
    override func viewDidAppear(_ animated: Bool) {
     
      proximitySwitchOutlet.grow()
  }
  @IBOutlet weak var backButton: UIButton!
  
  func setupTaps() {
//        let passTap = customTap(target: self, action: #selector(locationVC.showTap(sender:)))
//    //    let passTap = customTap(target: self, action: #selector(azimuthVC.debug(sender:)))
//        passTap.sender = "TURN ON in PULSE mode to send data outside of the polling window."
//        passTap.label = auxtext
//        auxLabel.addGestureRecognizer(passTap)
//        auxLabel.isUserInteractionEnabled = true
//        auxLabel.numberOfLines = 0
        
        let mainTap = customTap(target: self, action: #selector(locationVC.showTap(sender:)))
        mainTap.sender = "TURN ON the Main Switch to start the sensor reporting."
        mainTap.label = mainText
        mainLabel.addGestureRecognizer(mainTap)
        mainLabel.isUserInteractionEnabled = true
        mainLabel.numberOfLines = 0
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        primeController.said = self
        // Do any additional setup after loading the view.
        setupTaps()
        infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
            infoText.isUserInteractionEnabled = true
        //    infoText.addGestureRecognizer(swipeUp)
            infoText.numberOfLines = 0
            infoText.textAlignment = .justified
            self.view.addSubview(infoText)
            
            infoText.text = "Turns on the proximity monitor. It turns off the screen if you get too close and sends the word proximity true/false."
//            infoText.font = UIFont.preferredFont(forTextStyle: .body)
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
    
    
    
  @IBAction func proximitySwitch(_ sender: UISwitch){
    if sender.isOn {
      turnOn()
    } else {
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
      if variable! {
        superRec2.proximity = nil
      } else {
        superRec2.proximity = ""
      }
    }
  }
  
  func turnOn() {
    activateProximitySensor()
  }
  
  @IBAction func backButtonAction(_ sender: UIButton) {
    if proximitySwitchOutlet.isOn {
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
          self.proximitySwitchOutlet.setOn(true, animated: true)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
          })
        }))
        self.present(alert, animated: true)
      }
      
    }
  }
  
  func activateProximitySensor() {
    proximityValue = !proximityValue
       let device = UIDevice.current
       device.isProximityMonitoringEnabled = true
       if device.isProximityMonitoringEnabled {
         NotificationCenter.default.addObserver(self, selector: #selector(proximityVC.proximityChanged), name:  NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
       } else {
          // panic
       }
     }
   
  @objc func proximityChanged(notification: NSNotification) {
       if let _ = notification.object as? UIDevice {
           if port2G != nil && connect2G != "" {
              if UIDevice.current.proximityState {
                superRec2.proximity = "true"
              } else {
                superRec2.proximity = "false"
            }
            communications?.pulseUDP2(superRec2)
            
           }
       }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if autoClose! {
//       NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"))
      NotificationCenter.default.removeObserver(self)
      proximityValue = false
      proximitySwitchOutlet?.setOn(false, animated: false)
     }
     lastSwitch = proximitySwitchOutlet
     if lastSwitch!.isOn {
       status?.turnOn(views2G: self.tag!)
     } else {
       status?.turnOff(views2G: self.tag!)
       superRec2.proximity = nil
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

}
