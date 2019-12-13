//
//  ViewController.swift
//  talkCode
//
//  Created by localadmin on 15.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI

import AVFoundation
import Foundation
import Photos
import Network

protocol spoken {
    func wordUsed(word2D: String)
}

class ViewController: UIViewController, speaker, transaction {

  @IBOutlet weak var inapp: UILabel!

  func feedback(service: String, message: String) {
    inapp.text = message
    print("rawValues",IAPProduct.azimuth.rawValue,IAPStatus.purchased.rawValue)
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.purchased.rawValue {
      if strongCompass != nil {
        present(strongCompass!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "compass", sender: self)
      }
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMic != nil {
        present(strongMic!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "listen", sender: self)
      }
    }
    if service == IAPProduct.motion.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMotion != nil {
        present(strongMotion!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "gyro", sender: self)
      }
    }
  }
  


  @IBOutlet weak var topImage: UIImageView!
  var blinkStatus:Bool?
  var once: Bool = false
//  @IBOutlet weak var gearBOutlet: UIButton!
//  @IBOutlet weak var locationBOutlet: UIButton!
//  @IBOutlet weak var speakerBOutlet: UIButton!
//  @IBOutlet weak var micBOutlet: UIButton!
//  @IBOutlet weak var compassBOutlet: UIButton!
//  @IBOutlet weak var motionBOutlet: UIButton!
//  @IBOutlet weak var proximityBOutlet: UIButton!
  
  
  @IBOutlet weak var gearBOutlet: UIButton!
  @IBOutlet weak var speakerBOutlet: UIButton!
  @IBOutlet weak var proximityBOutlet: UIButton!
  @IBOutlet weak var locationBOutlet: UIButton!
  @IBOutlet weak var micBOutlet: UIButton!
  @IBOutlet weak var motionBOutlet: UIButton!
  @IBOutlet weak var compassBOutlet: UIButton!
  
  
  var strongCompass:compassVC?
  var strongMotion:gyroVC?
  var strongMic:listenVC?
  var strongSpeaker: speakerVC?
  var strongProximity: proximityVC?
  var strongLocation: locationVC?
  var strongGear: gearVC?
  
  //  @IBOutlet weak var beaconBOutlet: UIButton!
  
//  @IBAction func beaconButton(_ sender: UIButton) {
//    self.performSegue(withIdentifier: "beacon", sender: self)
//  }


  @IBAction func motionBAction(_ sender: UIButton) {
  //  @IBAction func gyroButton(_ sender: UIButton) {
    lastButton = motionBOutlet
    IAPService.shared.getProducts()
    IAPService.shared.ordered = self
    IAPService.shared.purchase(product: .motion)
  }
  
  @IBAction func locationBAction(_ sender: UIButton) {
  
//  @IBAction func locationButton(_ sender: UIButton) {
    lastButton = locationBOutlet
    if strongLocation != nil {
      present(strongLocation!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "location", sender: self)
    }
    
  }
  
  @IBAction func configBAction(_ sender: UIButton) {
  
  
//  @IBAction func configButton(_ sender: UIButton) {
    lastButton = nil
    if strongGear != nil {
      present(strongGear!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "config", sender: self)
    }
    
  }
  
  @IBAction func speakerBAction(_ sender: UIButton) {
  
  //  @IBAction func speakerButton(_ sender: UIButton) {
    lastButton = speakerBOutlet
    if strongSpeaker != nil {
      present(strongSpeaker!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "speaker", sender: self)
    }
    
  }
//  @IBAction func compassButton(_ sender: UIButton) {
  
  @IBAction func azimuthBAction(_ sender: Any) {
    lastButton = compassBOutlet
    
    IAPService.shared.ordered = self
    IAPService.shared.purchase(product: .azimuth)
  }
  
//  @IBAction func microphoneButton(_ sender: UIButton) {

  @IBAction func voiceBAction(_ sender: Any) {
    lastButton = micBOutlet
    
    IAPService.shared.ordered = self
    IAPService.shared.purchase(product: .voice)
  }
//  @IBAction func proximityButton(_ sender: UIButton) {

  @IBAction func proximityBAction(_ sender: UIButton) {
  lastButton = proximityBOutlet
    if strongProximity != nil {
      present(strongProximity!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "proximity", sender: self)
    }
    
  }
  
  @IBOutlet var nextOutlet: UIButton!
  @IBAction func nextButton(_ sender: UIButton) {
    if introCurrent == introValue.second {
      firstJump()
    }
    if introCurrent == introValue.third {
      secondJump()
      nextOutlet.isHidden = true
      UIView.animate(withDuration: 1) {
        self.micBOutlet.alpha = 1
        self.speakerBOutlet.alpha = 1
        self.proximityBOutlet.alpha = 1
        self.locationBOutlet.alpha = 1
        self.compassBOutlet.alpha = 1
        self.motionBOutlet.alpha = 1
        self.gearBOutlet.alpha = 1
      }
    }
    
  }
  
  
  
  @IBOutlet weak var page1: UIImageView!
  @IBOutlet weak var page2: UIImageView!
  @IBOutlet weak var page3: UIImageView!
  
  @IBOutlet weak var spokenText: UILabel!
  
  enum introValue: Int8 {
    case first
    case second
    case third
    case all
  }
  
  var introCurrent: introValue = introValue.first
  

  @IBOutlet weak var tapMeOutlet: UIButton!
  func tapMe() {
    introText = UILabel(frame: CGRect(x: leftMargin, y: topMargin, width: self.view.bounds.width - 40, height: 180))
    introText.isUserInteractionEnabled = true
    introText.addGestureRecognizer(swipeLeft)
    introText.numberOfLines = 0
    introText.textAlignment = .justified
//    introText.backgroundColor = .yellow
    self.view.addSubview(introText)
    tapFunction(sender: self)
  }
  
  var touched: UIGestureRecognizer!
  var swipeLeft: UISwipeGestureRecognizer!
  var swipeRight: UISwipeGestureRecognizer!
  var tapper: UITapGestureRecognizer!
  
  var topMargin: CGFloat!
  var leftMargin: CGFloat!
  var rightMargin: CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    IAPService.shared.getProducts()
    
    topMargin = view.safeAreaInsets.top
    leftMargin = view.safeAreaInsets.left + 20
    rightMargin = view.safeAreaInsets.right - 20
    
    swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeLeftFunction(sender:)))
    swipeLeft.direction = .left
    swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeRightFunction(sender:)))
    swipeRight.direction = .right
    tapper = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapper(sender:)))
    introCurrent = introValue.first
   
    communications = connect()
    communications?.spoken = self

    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidEnterBackground(notification:)),
                                           name: UIApplication.didEnterBackgroundNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
    
    if !fastStart! {
      tapMe()
    } else {
      gearBOutlet.isEnabled = true
      
      delay = DispatchTimeInterval.nanoseconds(500)
    }
  }
  
  @objc func defaultsChanged(){
      if UserDefaults.standard.bool(forKey: "AUTO_CLOSE") {
        autoClose = true
      }
      else {
        autoClose = false
      }
      if UserDefaults.standard.bool(forKey: "FAST_START") {
        fastStart = true
      } else {
        fastStart = false
      }
    if (UserDefaults.standard.string(forKey: "PRECISION") != nil) {
        precision = UserDefaults.standard.string(forKey: "PRECISION")
      } else {
        precision = "2"
      }
  }
  
  @objc func applicationDidBecomeActive(notification: NSNotification) {
      print("Device is unlocked")
  }

  @objc func applicationDidEnterBackground(notification: NSNotification) {
          print("Device is locked")
  }
  
  var introText: UILabel!
  var introCord: CGFloat!
  var introCordX: CGFloat!
  
  @objc func tapFunction(sender:Any) {
  
      micBOutlet.alpha = 0
      speakerBOutlet.alpha = 0
      proximityBOutlet.alpha = 0
      locationBOutlet.alpha = 0
      compassBOutlet.alpha = 0
      motionBOutlet.alpha = 0
      gearBOutlet.alpha = 0

      if introCurrent == introValue.first {
//        introText.text = "Welcome to sensorCode. This app will make your robot smarter by sharing all of your phones's sensor data with it. Think gyro, motion, location, compass, voice, sound and more ..."
        introText.text = "Your iphone has more than half a dozen sensors within it. This app will make your robot smarter by sharing the sensor data on your phone with it. Think gyro, motion, compass, voice, speaker and more ..."
        introCord = introText.frame.origin.y
        introCord = introText.center.y
        introCordX = introText.center.x
        
        introCurrent = introValue.second
        if #available(iOS 13.0, *) {
          page1.image = UIImage(systemName: "circle.fill")
        } else {
          page1.image = UIImage(named: "blackDot")
        }
        if #available(iOS 13.0, *) {
          page2.image = UIImage(systemName:"circle")
        } else {
          page2.image = UIImage(named: "whiteDot")
        }
        if #available(iOS 13.0, *) {
          page3.image = UIImage(systemName: "circle")
        } else {
          page3.image = UIImage(named: "whiteDot")
        }
      }
//      introText.removeGestureRecognizer(touched)
      introText.addGestureRecognizer(swipeLeft)
      topImage.image = nil
      if #available(iOS 13.0, *) {
//        topImage.image = UIImage(systemName: "arrow.left")
      } else {
//        topImage.image = UIImage(named: "arrow.left")
    }
  }
  
 
      
  @objc func swipeLeftFunction(sender:Any) {
    if introCurrent == introValue.second {
      firstJump()
    }
    if introCurrent == introValue.third {
      secondJump()
      nextOutlet.isHidden = true
      UIView.animate(withDuration: 1) {
        self.micBOutlet.alpha = 1
        self.speakerBOutlet.alpha = 1
        self.proximityBOutlet.alpha = 1
        self.locationBOutlet.alpha = 1
        self.compassBOutlet.alpha = 1
        self.motionBOutlet.alpha = 1
        self.gearBOutlet.alpha = 1
      }
    }
  }
  
  func firstJump() {
    print("intro",introText.center)
    UIView.animate(withDuration: 0.5) {
      self.introText.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
      self.topImage.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      
      if self.introCurrent == introValue.second {
//        self.introText.text = "To use sensorCode you need a script on the robot side. Using said script you can send and receive data to this phone."
        self.introText.text = "To access the data send by this app, you need to write and run a script on the robot side. It will send the data out using a protocol called UDP. You need to listen for it, and respond how you see fit."
        self.introCurrent = introValue.third
        if #available(iOS 13.0, *) {
          self.page1.image = UIImage(systemName: "circle")
        } else {
          self.page1.image = UIImage(named: "whiteDot")
        }
        if #available(iOS 13.0, *) {
          self.page2.image = UIImage(systemName:"circle.fill")
        } else {
          self.page2.image = UIImage(named: "blackDot")
        }
        if #available(iOS 13.0, *) {
          self.page3.image = UIImage(systemName: "circle")
        } else {
          self.page3.image = UIImage(named: "whiteDot")
        }
      }
//      self.introText.removeGestureRecognizer(self.swipeLeft)
//      self.introText.addGestureRecognizer(self.swipeRight)
      
      UIView.animate(withDuration: 0.5) {
        self.introText.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
//        self.topImage.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
      }
      
      if #available(iOS 13.0, *) {
//        self.topImage.image = UIImage(systemName: "arrow.right")
      } else {
//        self.topImage.image = UIImage(named: "arrow.right")
      }
    })
  }
        
  @objc func swipeRightFunction(sender: Any) {
    print("fuck off")
  }
  
func secondJump() {
    self.introText.removeGestureRecognizer(self.swipeLeft)
    self.introText.addGestureRecognizer(self.tapper)
    
    UIView.animate(withDuration: 0.5) {
      self.introText.center = CGPoint(x:self.view.bounds.maxX * 2,y:self.introCord)
      self.topImage.center = CGPoint(x:self.view.bounds.maxX * 2,y:self.introCord)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      
      if self.introCurrent == introValue.third {
//        self.introText.text = "Your script needs to listen on a UDP port. A port which this app will send the sensor data too. You can configure the port to use thru the gear icon."
        self.introText.text = "Use the gear icon to get started. You need to give the IP address of your robot together with the UDP port it on which it is listening. Different sensors send different packets at different rates/depending on different actions."
        self.introCurrent = introValue.all
        if #available(iOS 13.0, *) {
          self.page1.image = UIImage(systemName: "circle")
        } else {
          self.page1.image = UIImage(named: "whiteDot")
        }
        if #available(iOS 13.0, *) {
          self.page2.image = UIImage(systemName:"circle")
        } else {
          self.page2.image = UIImage(named: "whiteDot")
        }
        if #available(iOS 13.0, *) {
          self.page3.image = UIImage(systemName: "circle.fill")
        } else {
          self.page3.image = UIImage(named: "blackDot")
        }
      }
      
      UIView.animate(withDuration: 0.5) {
        self.introText.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
        self.topImage.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
      }
      

        self.topImage.image = UIImage(named: "cog")
        self.topImage.alpha = 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//          self.gearBOutlet.alpha = 0
          self.gearBOutlet.isHidden = false
          self.gearBOutlet.isEnabled = true
//          self.blinkStatus = false
//          Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
//            if self.blinkStatus != nil {
//              if self.blinkStatus == false {
//                  self.gearBOutlet.alpha = 0.8
//                  self.blinkStatus = true
//              } else {
//                  self.gearBOutlet.alpha = 0.6
//                  self.blinkStatus = false
//              }
//            } else {
//              self.gearBOutlet.alpha = 1.0
//              timer.invalidate()
//            }
////            if self.blinkStatus == false {
////                self.gearBOutlet.alpha = 0
////                self.blinkStatus = true
////            } else {
////                self.gearBOutlet.alpha = 1
////                self.blinkStatus = false
////            }
//
//          }
          self.gearBOutlet.grow()
        })
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
        
        UIView.animate(withDuration: 4) {
          self.introText.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
          self.topImage.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
        }
        
        UIView.animate(withDuration: 0.5) {
          self.topImage.alpha = 0
//          self.gearBOutlet.alpha = 1.0
//          self.micBOutlet.shake()
          self.page3.image = UIImage(named: "whiteDot")
//          self.blinkStatus = nil
        }
        
        
        
      })
    })
  }
  
  @objc func tapper(sender: Any) {
    UIView.animate(withDuration: 0.5) {
              self.introText.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
              self.topImage.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
            }
            
            UIView.animate(withDuration: 0.5) {
              self.topImage.alpha = 0
              self.gearBOutlet.alpha = 1.0
              self.gearBOutlet.isEnabled = true
              self.page3.image = UIImage(named: "whiteDot")
    //          self.micBOutlet.shake()
              
              
            }
  }
  
  @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
//      print("Unwind to Root View Controller")
    firstShown()
  }

  func speak(_ comm: String, para: String) {
//    if !once && comm.contains("speak") {
//      once = true
      
      let audioSession = AVAudioSession.sharedInstance()
      do {
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, policy: AVAudioSession.RouteSharingPolicy.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
      } catch {
          print("Setting category to AVAudioSessionCategoryPlayback failed.")
      }
      
      let utterance = AVSpeechUtterance(string: para)
      utterance.voice = AVSpeechSynthesisVoice(language: language)
      utterance.volume = volume
      utterance.rate = rate

      let synthesizer = AVSpeechSynthesizer()
      synthesizer.speak(utterance)

  }
  

  func ok(_ value: String) {
    let alertController = UIAlertController(title: value, message: value, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func bad(_ value: String) {
    let alertController = UIAlertController(title: value, message: value, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in
//      self.connectLabel.setTitle("Connect", for: .normal)
    }
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func postAlert(title: String, message: String) {
    // code
  }
  
  func port(_ value: String) {
    // code
  }
  
  func newName(_ value: String) {
    // code
  }
  
  let words = ["forward","backward","left","right","stop"]
  var ok2Connect = false
 
  func activateProximitySensor() {
    proximityValue = !proximityValue
       let device = UIDevice.current
       device.isProximityMonitoringEnabled = true
       if device.isProximityMonitoringEnabled {
         NotificationCenter.default.addObserver(self, selector: #selector(ViewController.proximityChanged), name:  NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
       } else {
        print("pox disabled")
       }
     }
   
  @objc func proximityChanged(notification: NSNotification) {
      
       if let device = notification.object as? UIDevice {
           if port2G != nil && connect2G != "" {
              let foobar = UIDevice.current.proximityState
             communications?.sendUDP("proximity \(foobar)")
           }
       }
   }
  
  
  var toggle: Bool = true
  var delay:DispatchTimeInterval = DispatchTimeInterval.seconds(2)
  var timer:Timer?
  var infoText: UILabel?
  var firstShow = true
  
  override func viewDidAppear(_ animated: Bool) {
  
    // disable screen dim/lock
    UIApplication.shared.isIdleTimerDisabled = true
//    timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
//    RunLoop.current.add(timer!, forMode: .common)
//    activateProximitySensor()
    resignFirstResponder()

  }
  
  func firstShown() {
    print("firstShwon",firstShow,port2G)
    if firstShow {
      infoText = UILabel(frame: CGRect(x: leftMargin, y: topMargin + 20, width: self.view.bounds.width - 40, height: 40))
      infoText!.isUserInteractionEnabled = true
      
      infoText!.numberOfLines = 0
      infoText!.textAlignment = .center
    //    introText.backgroundColor = .yellow
      self.view.addSubview(infoText!)
    }
        
    if port2G != nil && firstShow {
      gearBOutlet.isEnabled = false
      infoText!.text = "The Sensors"
      UIView.animate(withDuration: 0.5) {
        self.infoText!.center = CGPoint(x:self.view.bounds.midX,y:self.view.bounds.minY + 80)
      }
      infoText!.font = UIFont.preferredFont(forTextStyle: .body)
      infoText!.adjustsFontForContentSizeCategory = true
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
        self.infoText!.text = "Listen to voice"
        self.micBOutlet.grow()
        self.micBOutlet.isEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
          self.infoText!.text = "Speak text sent"
          self.speakerBOutlet.grow()
          self.speakerBOutlet.isEnabled = true
          DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.infoText!.text = "Turn on proximity alerts"
            self.proximityBOutlet.grow()
            self.proximityBOutlet.isEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
              self.infoText!.text = "Report location"
              self.locationBOutlet.grow()
              self.locationBOutlet.isEnabled = true
              DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.infoText!.text = "Stream compass position"
                self.compassBOutlet.grow()
                self.compassBOutlet.isEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                  self.infoText!.text = "Stream phone motion"
                  self.motionBOutlet.grow()
                  self.motionBOutlet.isEnabled = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                    self.infoText!.isHidden = true
                    self.firstShow = false
                  })
                })
              })
            })
          })
        })
      })
    }
//    if lastButton != nil {
  print("lastB",lastButton)
      lastButton?.grow()
//    }
  }
    
//  @objc func fire() {
//    switch introCurrent {
//      case introValue.first:
//        print("jump")
//      case introValue.second:
//
//        let duration: TimeInterval = 4.0
//        UIView.animate(withDuration: duration) {
//          self.micBOutlet.frame.origin.x = self.view.bounds.midX - 32
//          self.micBOutlet.frame.origin.y = self.view.bounds.midY + 32
//          self.locationBOutlet.frame.origin.x = self.view.bounds.midX + 32
//          self.locationBOutlet.frame.origin.y = self.view.bounds.midY - 96
//        }
//      case introValue.third:
//        let duration: TimeInterval = 4.0
//        UIView.animate(withDuration: duration) {
//          self.speakerBOutlet.frame.origin.x = self.view.bounds.midX + 32
//          self.speakerBOutlet.frame.origin.y = self.view.bounds.midY - 32
//
//          self.motionBOutlet.frame.origin.x = self.view.bounds.midX - 96
//          self.motionBOutlet.frame.origin.y = self.view.bounds.midY - 96
//
//          self.locationBOutlet.frame.origin.x = self.view.bounds.midX - 96
//          self.locationBOutlet.frame.origin.y = self.view.bounds.midY + 32
//        }
//
//      case introValue.all:
//        self.micBOutlet.isHidden = false
////        self.beaconBOutlet.isHidden = false
//        self.motionBOutlet.isHidden = false
//        self.speakerBOutlet.isHidden = false
//        self.locationBOutlet.isHidden = false
//        self.compassBOutlet.isHidden = false
//        self.proximityOutlet.isHidden = false
////        self.gearBOutlet.isHidden = false
//
////        self.gearBOutlet.bounds.size = CGSize(width: 64, height: 64)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
//
//          let duration: TimeInterval = 4.0
//          UIView.animate(withDuration: duration, animations: {
//            self.gearBOutlet.frame.origin.x = self.view.bounds.midX - 32
//            self.gearBOutlet.frame.origin.y = self.view.bounds.midY - 32
//
//            self.compassBOutlet.frame.origin.x = self.view.bounds.midX - 96
//            self.compassBOutlet.frame.origin.y = self.view.bounds.midY - 96
//
//            self.motionBOutlet.frame.origin.x = self.view.bounds.midX + 32
//            self.motionBOutlet.frame.origin.y = self.view.bounds.midY - 96
//
//            self.locationBOutlet.frame.origin.x = self.view.bounds.midX - 32
//            self.locationBOutlet.frame.origin.y = self.view.bounds.midY + 32
//
////            self.beaconBOutlet.frame.origin.x = self.view.bounds.midX - 96
////            self.beaconBOutlet.frame.origin.y = self.view.bounds.midY + 32
//
//            self.proximityOutlet.frame.origin.x = self.view.bounds.midX - 96
//            self.proximityOutlet.frame.origin.y = self.view.bounds.midY + 32
//
//            self.speakerBOutlet.frame.origin.x = self.view.bounds.midX + 32
//            self.speakerBOutlet.frame.origin.y = self.view.bounds.midY + 32
//
//            self.micBOutlet.frame.origin.x = self.view.bounds.midX - 32
//            self.micBOutlet.frame.origin.y = self.view.bounds.midY - 96
//
//          }) { (flag) in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
//              self.gearBOutlet.isEnabled = true
//          })
//          }
//        })
//    }
//
//    if (gearBOutlet.isEnabled) {
//      if (gearBOutlet.isHidden) == false {
//        return
//      }
//    }
//    if toggle {
//
//      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
//        self.motionBOutlet.isHighlighted = false
//        self.compassBOutlet.isHighlighted = false
//        self.locationBOutlet.isHighlighted = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
//          self.micBOutlet.isHighlighted = true
//          self.speakerBOutlet.isHighlighted = true
//          self.proximityOutlet.isHighlighted = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
//              self.toggle = false
//            })
//
//        })
//      })
//
//    } else {
//
//      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
//        self.motionBOutlet.isHighlighted = true
//        self.compassBOutlet.isHighlighted = true
//        self.locationBOutlet.isHighlighted = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
//          self.micBOutlet.isHighlighted = false
//          self.speakerBOutlet.isHighlighted = false
//          self.proximityOutlet.isHighlighted = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
//              self.toggle = true
//            })
//
//        })
//      })
//
//    }
//  }
  
//  @objc func dismissKeyboard() {
//      //Causes the view (or one of its embedded text fields) to resign the first responder status.
//      view.endEditing(true)
//  }
  
  func redo(_ value: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: value, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
    
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
      if motion == .motionShake {
        self.performSegue(withIdentifier: "photo", sender: self)
      }
      gearBOutlet.isEnabled = true
    }
    
 
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    timer?.invalidate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      if !fastStart! {
        self.introText.text = "Having configured your port, your free to choose any of six sensors you wish to send data to it"
      }
      if #available(iOS 13.0, *) {
        self.page1.image = UIImage(systemName: "circle")
      } else {
        self.page1.image = UIImage(named: "whiteDot")
      }
      if #available(iOS 13.0, *) {
        self.page2.image = UIImage(systemName:"circle")
      } else {
        self.page2.image = UIImage(named: "whiteDot")
      }
      if #available(iOS 13.0, *) {
        self.page3.image = UIImage(systemName: "circle")
      } else {
        self.page3.image = UIImage(named: "whiteDot")
      }
    })
    
    if segue.identifier == "gyro" {
      if let nextViewController = segue.destination as? gyroVC {
        strongMotion = nextViewController
        
      }
    }
    
    if segue.identifier == "compass" {
      if let nextViewController = segue.destination as? compassVC {
        strongCompass = nextViewController
        
      }
    }
    
    if segue.identifier == "location" {
      if let nextViewController = segue.destination as? locationVC {
        strongLocation = nextViewController
        
      }
    }
    
    if segue.identifier == "config" {
      if let nextViewController = segue.destination as? gearVC {
        strongGear = nextViewController
        
      }
    }
    
    if segue.identifier == "speaker" {
      if let nextViewController = segue.destination as? speakerVC {
        strongSpeaker = nextViewController
        
      }
    }
    
    if segue.identifier == "compass" {
      if let nextViewController = segue.destination as? compassVC {
        strongCompass = nextViewController
        
      }
    }
    
    if segue.identifier == "listen" {
      if let nextViewController = segue.destination as? listenVC {
        strongMic = nextViewController
        
      }
    }
    
    if segue.identifier == "proximity" {
      if let nextViewController = segue.destination as? proximityVC {
        strongProximity = nextViewController
        
      }
    }
  }
  
  
  
  func blink (button: UIButton) {
    
      if blinkStatus == false {
        button.tintColor = UIColor.lightGray
          blinkStatus = true
      } else {
        button.tintColor = UIColor.black
          blinkStatus = false
      }
  }

  
}

extension UIButton {

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
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

//extension UIView{
//  func blink() {
//    self.alpha = 0.2
//    UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
//  }
//}



