//
//  proximityVC.swift
//  talkCode
//
//  Created by localadmin on 02.12.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit

class proximityVC: UIViewController, spoken {
  func wordUsed(word2D: String) {
    spokenOutput.text = word2D
  }
  

    var infoText: UILabel!
  @IBOutlet weak var spokenOutput: UILabel!
  @IBOutlet weak var proximitySwitchOutlet: UISwitch!
  
    override func viewDidAppear(_ animated: Bool) {
      spokenOutput.text = ""
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        primeController.said = self
        // Do any additional setup after loading the view.
        
        infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
            infoText.isUserInteractionEnabled = true
        //    infoText.addGestureRecognizer(swipeUp)
            infoText.numberOfLines = 0
            infoText.textAlignment = .justified
            self.view.addSubview(infoText)
            
            infoText.text = "Turns on the proximity monitor. It turns off the screen if you get too close and sends the word proximity true/false."
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
    
    
    
  @IBAction func proximitySwitch(_ sender: UISwitch){
    if sender.isOn {
      activateProximitySensor()
    } else {
//      NotificationCenter.default.removeObserver(self)
      NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: nil)
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
        print("fire prox changed")
       if let device = notification.object as? UIDevice {
           if port2G != nil && connect2G != "" {
              let foobar = UIDevice.current.proximityState
             communications?.sendUDP("proximity \(foobar)")
           }
       }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if autoClose! {
//       NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"))
      NotificationCenter.default.removeObserver(self)
      proximityValue = false
     }
   }
  
    

}
