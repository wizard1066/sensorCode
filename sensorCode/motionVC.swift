//
//  gyroVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import CoreMotion

class motionVC: UIViewController, lostLink {

var motionManager: CMMotionManager?

  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  var tag:Int?
  var status:running?

 
  

  @IBAction func switchGyro(_ sender: UISwitch) {
    if sender.isOn {
      if motionManager!.isAccelerometerAvailable {
          motionManager!.accelerometerUpdateInterval = refreshRate!.doubleValue
          motionManager!.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
            
                self.senddata(data: data!)
          }
      }
    } else {
      if motionManager != nil {
        if motionManager!.isAccelerometerAvailable {
          motionManager?.stopAccelerometerUpdates()
          
        }
      }
//      superRec?.roll = nil
//      superRec?.pitch = nil
//      superRec?.yaw = nil
      superRec2?.movement?.roll = nil
      superRec2?.movement?.pitch = nil
      superRec2?.movement?.yaw = nil
    }
  }
  
  var lastRoll:String?
  var lastPitch:String?
  var lastYaw:String?
  
  func senddata(data: CMAccelerometerData) {
    let rN = String(format:"%.\(precision!)f",data.acceleration.x)
    let pN = String(format:"%.\(precision!)f",data.acceleration.y)
    let yN = String(format:"%.\(precision!)f",data.acceleration.z)
    
//    superRec?.roll = rN
//    superRec?.pitch = pN
//    superRec?.yaw = yN
    
    superRec2?.movement?.roll = rN
    superRec2?.movement?.pitch = pN
    superRec2?.movement?.yaw = yN
    
    if lastRoll == rN && lastPitch == pN && lastYaw == yN {
      return
    }
    
    self.rollOutput.text = rN
    self.pitchOutput.text = pN
    self.yawOutput.text = yN
    
//    let word = "\(rN) \(pN) \(yN)"
    let word = fly(roll: rN, pitch: pN, yaw: yN)
    if port2G != nil && connect2G != "" {
//      communications?.sendUDP(word)
      communications?.pulseUDP2(superRec2)
    }
    
    lastRoll = rN
    lastPitch = pN
    lastYaw = yN
    

  }
  
  
  var infoText: UILabel!

  @IBOutlet var switchGyroOutlet: UISwitch!
  @IBOutlet weak var pitchOutput: UILabel!
  @IBOutlet weak var rollOutput: UILabel!
  @IBOutlet weak var yawOutput: UILabel!
  

  @IBOutlet weak var backButton: UIButton!
  
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
        self.switchGyroOutlet.grow()
      }
    }
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
        
    if motionManager == nil {
      motionManager = CMMotionManager()
//      primeController.said = self
      
      
      infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
      infoText.isUserInteractionEnabled = true
      //    infoText.addGestureRecognizer(swipeUp)
      infoText.numberOfLines = 0
      infoText.textAlignment = .justified
      self.view.addSubview(infoText)
      
      infoText.text = "Sends a stream of tuples. The first the roll, the second the pitch and the third the yaw."
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
    } else {
      self.switchGyroOutlet.isOn = false
      if motionManager!.isAccelerometerAvailable {
        motionManager!.stopAccelerometerUpdates()
      }
      self.switchGyroOutlet.isOn = true
      if motionManager!.isAccelerometerAvailable {
        motionManager!.accelerometerUpdateInterval = Double(refreshRate!.doubleValue)
                motionManager!.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                      self.senddata(data: data!)
                }
            }
    }
    }
    
  
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if autoClose! {
      motionManager!.stopAccelerometerUpdates()
      motionManager = nil
      switchGyroOutlet.setOn(false, animated: false)
    }
    lastSwitch = switchGyroOutlet
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
