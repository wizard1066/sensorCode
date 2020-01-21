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
  func outgoing(ipaddr: String) {
    // ignore
  }
  
  func incoming(ipaddr: String) {
    // ignore
  }
  

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
      turnOn()
    } else {
      if motionManager != nil {
        if motionManager!.isAccelerometerAvailable {
          motionManager?.stopAccelerometerUpdates()
        }
      }
      if variable! {
        superRec2?.movement?.roll = nil
        superRec2?.movement?.pitch = nil
        superRec2?.movement?.yaw = nil
      } else {
        superRec2?.movement?.roll = ""
        superRec2?.movement?.pitch = ""
        superRec2?.movement?.yaw = ""
      }
    }
  }
  
  func turnOn() {
    if motionManager!.isAccelerometerAvailable {
        motionManager!.accelerometerUpdateInterval = refreshRate!.doubleValue
        motionManager!.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
              self.senddata(data: data!)
        }
    }
  }
  
  var lastRoll:String?
  var lastPitch:String?
  var lastYaw:String?
  
  func senddata(data: CMAccelerometerData) {
    let rN = String(format:"%.\(precision!)f",data.acceleration.x)
    let pN = String(format:"%.\(precision!)f",data.acceleration.y)
    let yN = String(format:"%.\(precision!)f",data.acceleration.z)
    superRec2?.movement?.roll = rN
    superRec2?.movement?.pitch = pN
    superRec2?.movement?.yaw = yN
    if lastRoll == rN && lastPitch == pN && lastYaw == yN {
      return
    }
    self.rollOutput.text = rN
    self.pitchOutput.text = pN
    self.yawOutput.text = yN
    if port2G != nil && connect2G != "" {
      if pulse != nil {
        // send only is pulse if off or azimuthPass is on
        if pulse! == false {
          communications?.pulseUDP2(superRec2)
        }
        if pulse! == true && motionBPass.isOn {
          communications?.pulseUDP2(superRec2)
        }
      }
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
  @IBOutlet weak var motionBPass: UISwitch!
  @IBOutlet weak var auxLabel: UILabel!
  @IBOutlet weak var auxText: UILabel!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var mainText: UILabel!
  @IBOutlet weak var backButton: UIButton!
  
  private var background = false
  
  @IBAction func backButtonAction(_ sender: UIButton) {
    if switchGyroOutlet.isOn {
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
          self.switchGyroOutlet.setOn(true, animated: true)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
          })
        }))
        self.present(alert, animated: true)
      }
      
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
        self.switchGyroOutlet.grow()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      if pulse == false {
        motionBPass.isHidden = true
        auxLabel.isHidden = true
        auxText.isHidden = true
      }
      if switchGyroOutlet.isOn == false {
        motionBPass.isEnabled = false
      }
  }
  
  func setupTaps() {
        let passTap = customTap(target: self, action: #selector(motionVC.showTap(sender:)))
    //    let passTap = customTap(target: self, action: #selector(azimuthVC.debug(sender:)))
        passTap.sender = "TURN ON in PULSE mode to send data outside of the polling window."
        passTap.label = auxText
        auxLabel.addGestureRecognizer(passTap)
        auxLabel.isUserInteractionEnabled = true
        auxLabel.numberOfLines = 0
        
        let mainTap = customTap(target: self, action: #selector(motionVC.showTap(sender:)))
        mainTap.sender = "TURN ON the Main Switch to start the sensor reporting."
        mainTap.label = mainText
        mainLabel.addGestureRecognizer(mainTap)
        mainLabel.isUserInteractionEnabled = true
        mainLabel.numberOfLines = 0
  }
  
  @objc func pulseChanged(sender:Notification) {
    
    if let state = sender.userInfo?["pulseBool"] as? Bool {
      
      motionBPass.isHidden = state
      motionBPass.isEnabled = !state
      mainLabel.isHidden = state
      mainText.isHidden = state
    }
    
  }
    
    
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      let nc = NotificationCenter.default
      nc.addObserver(self, selector: #selector(pulseChanged), name: Notification.Name("pulseChanged"), object: nil)
      
      setupTaps()
      let passTap = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
      passTap.sender = "True changes the default behaviour of PULSE, will send additional data if changes seen."
      passTap.label = infoText
      motionBPass.addGestureRecognizer(passTap)
      motionBPass.isUserInteractionEnabled = true
        
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
//      infoText.font = UIFont.preferredFont(forTextStyle: .body)
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
  
  @objc func showTap(sender: Any) {
      let tag = sender as? customTap
      let label = tag!.label as? UILabel
      let textFeed = tag!.sender as? String
      showText(label: label!, text: textFeed!)
    }
    
    @objc func showPress(sender: Any) {
      
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
