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

protocol running {
  func turnOn(views2G: Int)
  func turnOff(views2G: Int)
}

protocol lostLink {
  func sendAlert(error: String)
}

enum views2G: Int {
  case azimuth = 0
  case motion = 1
  case voice = 2
  case gear = 3
  case location = 4
  case proximity = 5
  case speaker = 6
}

class ViewController: UIViewController, speaker, transaction, spoken, setty, running, lostLink {
  func sendAlert(error: String) {
    redo(error)
  }
  

  func turnOff(views2G label: Int) {
    switch label {
      case views2G.azimuth.rawValue:
        azimuthTag.noblinkText(tag: views2G(rawValue: label)!)
      case views2G.motion.rawValue:
        motionTag.noblinkText(tag: views2G(rawValue: label)!)
      case views2G.voice.rawValue:
        voiceTag.noblinkText(tag: views2G(rawValue: label)!)
      case views2G.location.rawValue:
        locationTag.noblinkText(tag: views2G(rawValue: label)!)
      case views2G.proximity.rawValue:
        proximityTag.noblinkText(tag: views2G(rawValue: label)!)
      case views2G.speaker.rawValue:
        talkTag.noblinkText(tag: views2G(rawValue: label)!)
      case views2G.gear.rawValue:
        connectTag.noblinkText(tag: views2G(rawValue: label)!)
      default:
        break
    }
  }
  

  func turnOn(views2G label: Int) {
    switch label {
      case views2G.azimuth.rawValue:
        azimuthTag.blinkText(tag: views2G(rawValue: label)!)
      case views2G.motion.rawValue:
        motionTag.blinkText(tag: views2G(rawValue: label)!)
      case views2G.voice.rawValue:
        voiceTag.blinkText(tag: views2G(rawValue: label)!)
      case views2G.location.rawValue:
        locationTag.blinkText(tag: views2G(rawValue: label)!)
      case views2G.proximity.rawValue:
        proximityTag.blinkText(tag: views2G(rawValue: label)!)
      case views2G.speaker.rawValue:
        talkTag.blinkText(tag: views2G(rawValue: label)!)
      case views2G.gear.rawValue:
        connectTag.blinkText(tag: views2G(rawValue: label)!)
      default:
        break
    }
  }
  

 
  

  func returnPostNHost(port: String, host: String) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 12 , execute: {
      self.portOutlet.isHidden = false
      self.sendingOutlet.isHidden = false
      self.portLabel.isHidden = false
      self.robotLabel.isHidden = false
      self.portOutlet.text = port
      self.sendingOutlet.text = host
    })
  }

  func wordUsed(word2D: String) {
    spokenText.isHidden = false
    spokenText.text = word2D
  }
  

  @IBOutlet weak var inapp: UILabel!
  @IBOutlet weak var moreText: UILabel!
  
  var purchases:[String:Bool] = [:]

  func feedback(service: String, message: String) {
    inapp.text = message
    if message != IAPStatus.restored.rawValue {
      UIView.animate(withDuration: 4, animations: {
        self.inapp.alpha = 1
      }) { (finished) in
        self.inapp.alpha = 0
      }
  
    }
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.purchased.rawValue {
      if strongCompass != nil {
        present(strongCompass!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "azimuth", sender: self)
      }
      azimuthBOutlet.setBackgroundImage(UIImage(named:"azimuth"), for: .normal)
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMic != nil {
        present(strongMic!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "voice", sender: self)
      }
      voiceBOutlet.setBackgroundImage(UIImage(named:"voice"), for: .normal)
    }
    if service == IAPProduct.motion.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMotion != nil {
        present(strongMotion!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "motion", sender: self)
      }
      motionBOutlet.setBackgroundImage(UIImage(named:"motion"), for: .normal)
    }
    
    
    if service == IAPProduct.motion.rawValue && message == IAPStatus.restored.rawValue {
      motionBOutlet.setBackgroundImage(UIImage(named:"motion"), for: .normal)
    }
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.restored.rawValue {
      azimuthBOutlet.setBackgroundImage(UIImage(named:"azimuth"), for: .normal)
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.restored.rawValue {
      voiceBOutlet.setBackgroundImage(UIImage(named:"voice"), for: .normal)
    }
    if message == IAPStatus.restored.rawValue {
      purchases[service] = true
    }
  }
  


  @IBOutlet weak var topImage: UIImageView!
  var blinkStatus:Bool?
  var once: Bool = false

  @IBOutlet weak var voiceTag: UILabel!
  @IBOutlet weak var motionTag: UILabel!
  @IBOutlet weak var azimuthTag: UILabel!
  @IBOutlet weak var locationTag: UILabel!
  @IBOutlet weak var proximityTag: UILabel!
  @IBOutlet weak var talkTag: UILabel!
  @IBOutlet weak var connectTag: UILabel!
  @IBOutlet weak var toolsTag: UILabel!
  
  @IBOutlet weak var portOutlet: UILabel!
  @IBOutlet weak var sendingOutlet: UILabel!
  @IBOutlet weak var recievingOutlet: UILabel!
  @IBOutlet weak var spokenOutlet: NSLayoutConstraint!
  @IBOutlet weak var portLabel: UILabel!
  @IBOutlet weak var robotLabel: UILabel!
  
  
  @IBOutlet weak var stackviewDots: UIStackView!
  @IBOutlet weak var gearBOutlet: UIButton!
  @IBOutlet weak var speakerBOutlet: UIButton!
  @IBOutlet weak var proximityBOutlet: UIButton!
  @IBOutlet weak var locationBOutlet: UIButton!
  @IBOutlet weak var voiceBOutlet: UIButton!
  @IBOutlet weak var motionBOutlet: UIButton!
  @IBOutlet weak var azimuthBOutlet: UIButton!
  @IBOutlet weak var toolBOutlet: UIButton!
  
  
  var strongCompass:azimuthVC?
  var strongMotion:motionVC?
  var strongMic:voiceVC?
  var strongSpeaker: speakerVC?
  var strongLocation: locationVC?
  var strongGear: gearVC?
  var strongProximity: proximityVC?
  var strongTool: toolsVC?
  
  


  @IBAction func motionBAction(_ sender: UIButton) {

    lastButton = motionBOutlet
//    feedback(service: IAPProduct.motion.rawValue, message: IAPStatus.purchased.rawValue)
    if purchases[IAPProduct.motion.rawValue] == nil {
      IAPService.shared.ordered = self
      IAPService.shared.purchase(product: .motion)
    } else {
      feedback(service: IAPProduct.motion.rawValue, message: IAPStatus.purchased.rawValue)
    }
  }
  
  @IBAction func locationBAction(_ sender: UIButton) {
  

    lastButton = locationBOutlet
    if strongLocation != nil {
      present(strongLocation!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "location", sender: self)
    }
    
  }
  
  @IBAction func configBAction(_ sender: UIButton) {
  
    lastButton = gearBOutlet
    if strongGear != nil {
      present(strongGear!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "config", sender: self)
    }
    
  }
  
  @IBAction func toolBAction(_ sender: UIButton) {
  
    lastButton = toolBOutlet
    if strongTool != nil {
      present(strongTool!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "tools", sender: self)
    }
    
  }
  
  @IBAction func speakerBAction(_ sender: UIButton) {
  
 
    lastButton = speakerBOutlet
    if strongSpeaker != nil {
      present(strongSpeaker!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "speaker", sender: self)
    }
    
  }

  
  @IBAction func azimuthBAction(_ sender: Any) {
//    feedback(service: IAPProduct.azimuth.rawValue, message: IAPStatus.purchased.rawValue)
    lastButton = azimuthBOutlet
    if purchases[IAPProduct.azimuth.rawValue] == nil {
      IAPService.shared.ordered = self
      IAPService.shared.purchase(product: .azimuth)
    } else {
      feedback(service: IAPProduct.azimuth.rawValue, message: IAPStatus.purchased.rawValue)
    }
  }
  


  @IBAction func voiceBAction(_ sender: Any) {
    lastButton = voiceBOutlet
    
//    feedback(service: IAPProduct.voice.rawValue, message: IAPStatus.purchased.rawValue)
    if purchases[IAPProduct.voice.rawValue] == nil {
      IAPService.shared.ordered = self
      IAPService.shared.purchase(product: .voice)
    } else {
      feedback(service: IAPProduct.voice.rawValue, message: IAPStatus.purchased.rawValue)
    }
    
  }


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
        self.voiceBOutlet.alpha = 1
        self.speakerBOutlet.alpha = 1
        self.proximityBOutlet.alpha = 1
        self.locationBOutlet.alpha = 1
        self.azimuthBOutlet.alpha = 1
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
  
  func alertNoNetwork() {
    
    let alert = UIAlertController(title: "Sorry you need a WiFi connection", message: "Do you want to goto iOS settings", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
      if let url = URL(string:UIApplication.openSettingsURLString) {
         if UIApplication.shared.canOpenURL(url) {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
      }
    }))

    self.present(alert, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    NetStatus.shared.didStartMonitoringHandler = { [unowned self] in
//        print("Start Monitoring",NetStatus.shared.getInfo())
    }
    
    NetStatus.shared.didStopMonitoringHandler = { [unowned self] in
//           print("Start Monitoring")
    }
    
      
    NetStatus.shared.netStatusChangeHandler = {
      DispatchQueue.main.async { [unowned self] in
        let connected = NetStatus.shared.isConnected
        if !connected {
          self.alertNoNetwork()
        } else {
            IAPService.shared.getProducts()
            IAPService.shared.ordered = self
            IAPService.shared.restorePurchases()
        }
      }
    }
      
    NetStatus.shared.startMonitoring()
    NetStatus.shared.getInfo()
    
    
    voiceBOutlet.layer.cornerRadius = 32
    motionBOutlet.layer.cornerRadius = 32
    azimuthBOutlet.layer.cornerRadius = 32
    
    voiceBOutlet.clipsToBounds = true
    motionBOutlet.clipsToBounds = true
    azimuthBOutlet.clipsToBounds = true
    
    azimuthBOutlet.layer.borderWidth = 2
    azimuthBOutlet.layer.borderColor = UIColor.black.cgColor
    
//    nextOutlet.layer.borderWidth = 1
//    nextOutlet.layer.borderColor = UIColor.gray.cgColor
//    nextOutlet.clipsToBounds = true
//    nextOutlet.layer.cornerRadius = 8
    
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
//      nextOutlet.showWord()
      nextOutlet.splitWord()
      tapMe()
    } else {
      gearBOutlet.isEnabled = true
      gearBOutlet.isHidden = false
      nextOutlet.isHidden = true
      topImage.isHidden = true
      delay = DispatchTimeInterval.nanoseconds(500)
      toolBOutlet.isEnabled = true
      toolBOutlet.isHidden = false
      connectTag.isHidden = false
      toolsTag.isHidden = false
    }
    
    if port2G == nil {
      portOutlet.isHidden = true
      sendingOutlet.isHidden = true
      recievingOutlet.isHidden = true
      spokenText.isHidden = true
      portLabel.isHidden = true
      robotLabel.isHidden = true
    }
    
    if variable! {
//      superRec = pulser(proximity: nil, latitude: nil, longitude: nil, altitude: nil, trueNorth: nil, magneticNorth: nil, roll: nil, pitch: nil, yaw: nil, word: nil)
      let superGPS = gps(latitude: nil, longitude: nil, altitude: nil)
      let superMOV = fly(roll: nil, pitch: nil, yaw: nil)
      let superDIR = globe(trueNorth: nil, magneticNorth: nil)
      superRec2 = pulser2(wd: nil, px: nil, pos: superGPS, mov: superMOV, dir: superDIR)
     
    } else {
//      superRec = pulser(proximity:"false", latitude:"", longitude:"", altitude:"", trueNorth:"", magneticNorth:"", roll:"", pitch:"", yaw:"", word:"")
     
      let superGPS = gps(latitude: "", longitude: "", altitude: "")
      let superMOV = fly(roll: "", pitch: "", yaw: "")
      let superDIR = globe(trueNorth: "", magneticNorth: "")
      superRec2 = pulser2(wd: "", px: "", pos: superGPS, mov: superMOV, dir: superDIR)
      
    }
  }
  
  func appRestartRequest() {
    let alertController = UIAlertController(title: "Restart Required", message: "Changing the app defaults will ONLY take effect after an app restart", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  @objc func defaultsChanged(notification:NSNotification){
      print("defaultsChanged")

//      if let defaults = notification.object as? UserDefaults {
//        if defaults.bool(forKey: "PULSE") {
//          print("Pulse changed")
////          appRestartRequest()
//        }
//        if defaults.bool(forKey: "RAW") {
//          print("Raw changed")
////          appRestartRequest()
//        }
//        if defaults.bool(forKey: "VARIABLE") {
//          print("Variable changed")
////          appRestartRequest()
//        }
//        if defaults.bool(forKey: "AUTO_CLOSE") {
//          print("Variable changed")
////          appRestartRequest()
//        }
//        if defaults.bool(forKey: "FAST_START") {
//          print("Variable changed")
////          appRestartRequest()
//        }
//        if (defaults.string(forKey: "PRECISION") != nil) {
//          print("Precision changed")
////          appRestartRequest()
//        }
//        if (defaults.string(forKey: "RATE") != nil) {
//          print("Rate changed")
////          appRestartRequest()
//        }
//      }
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
  
      voiceBOutlet.alpha = 0
      speakerBOutlet.alpha = 0
      proximityBOutlet.alpha = 0
      locationBOutlet.alpha = 0
      azimuthBOutlet.alpha = 0
      motionBOutlet.alpha = 0
      gearBOutlet.alpha = 0

      if introCurrent == introValue.first {

        introText.text = "Your smartphone has more than half a dozen sensors within it. Make your robot smarter by sharing the data captured by those sensors. Think azimuth, motion, voice and more ..."
        introCord = introText.frame.origin.y
        introCord = introText.center.y
        introCordX = introText.center.x
        
        introCurrent = introValue.second
        
          page1.image = UIImage(named: "blackDot")
          page2.image = UIImage(named: "whiteDot")
          page3.image = UIImage(named: "whiteDot")
        
      }
      introText.addGestureRecognizer(swipeLeft)
      topImage.image = nil

  }
  
 
      
  @objc func swipeLeftFunction(sender:Any) {
    if introCurrent == introValue.second {
      firstJump()
    }
    if introCurrent == introValue.third {
      secondJump()
      nextOutlet.isHidden = true
      UIView.animate(withDuration: 1) {
        self.voiceBOutlet.alpha = 1
        self.speakerBOutlet.alpha = 1
        self.proximityBOutlet.alpha = 1
        self.locationBOutlet.alpha = 1
        self.azimuthBOutlet.alpha = 1
        self.motionBOutlet.alpha = 1
        self.gearBOutlet.alpha = 1
      }
    }
  }
  
  func firstJump() {
    nextOutlet.splitWord()
    UIView.animate(withDuration: 0.5) {
      self.introText.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
      self.topImage.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      
      if self.introCurrent == introValue.second {

        self.introText.text = "Access the data thru a common UDP port you define. Write code on your robot to capture and process data sent and received..."
        self.introCurrent = introValue.third
          self.page1.image = UIImage(named: "whiteDot")
          self.page2.image = UIImage(named: "blackDot")
          self.page3.image = UIImage(named: "whiteDot")
        
      }
      
      UIView.animate(withDuration: 0.5) {
        self.introText.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
      }
      
    })
  }
        
  @objc func swipeRightFunction(sender: Any) {
    print("unavailable")
  }
  
func secondJump() {
    self.introText.removeGestureRecognizer(self.swipeLeft)
    self.introText.addGestureRecognizer(self.tapper)
    
    UIView.animate(withDuration: 0.5) {
      self.introText.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
      self.topImage.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      
      if self.introCurrent == introValue.third {

        self.introText.text = "Use the gear icon to get started. Azimuth, motion and voice are inapp purchases. Location, proximity and speaker are offered for free."
        self.introCurrent = introValue.all
        
          self.page1.image = UIImage(named: "whiteDot")
          self.page2.image = UIImage(named: "whiteDot")
          self.page3.image = UIImage(named: "blackDot")
        
      }
      
      UIView.animate(withDuration: 0.5) {
        self.introText.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
        self.topImage.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
      }
      

        self.topImage.image = UIImage(named: "cog")
        self.topImage.alpha = 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          self.gearBOutlet.isHidden = false
          self.gearBOutlet.isEnabled = true
          self.connectTag.isHidden = false
          
          self.toolsTag.isHidden = false
          self.toolBOutlet.isEnabled = true
          self.toolBOutlet.isHidden = false
          self.gearBOutlet.grow()
        })
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
        
        UIView.animate(withDuration: 4) {
          self.introText.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
          self.topImage.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
        }
        
        UIView.animate(withDuration: 0.5) {
          self.topImage.alpha = 0
          self.page3.image = UIImage(named: "whiteDot")
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
    //          self.voiceBOutlet.shake()
              
              
            }
  }
  
  @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
      print("Unwind to Root View Controller")
    communications?.missing = self
    // this code made the app crash!!
//    if lastSwitch?.isOn == false {
//      switch lastButton?.tag {
//        case views2G.voice.rawValue:
//          self.strongMic = nil
//        case views2G.speaker.rawValue:
//          strongSpeaker = nil
//        case views2G.motion.rawValue:
//          strongMotion = nil
//        case views2G.azimuth.rawValue:
//          strongCompass = nil
//        case views2G.location.rawValue:
//          strongLocation = nil
//        case views2G.gear.rawValue:
//          strongGear = nil
//        case views2G.proximity.rawValue:
//          strongProximity = nil
//        default:
//          break
//        }
//      }
//
      if introText != nil {
        introText.text = ""
      }
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
  
  var toggle: Bool = true
  var delay:DispatchTimeInterval = DispatchTimeInterval.seconds(1)
  var timer:Timer?
  var infoText: UILabel?
  var firstShow = true
  var background = false
  
  override func viewDidAppear(_ animated: Bool) {
  
    // disable screen dim/lock
    UIApplication.shared.isIdleTimerDisabled = true

    resignFirstResponder()

    if !background {
      let backgroundImage = UIImageView(frame: self.view.bounds)
      backgroundImage.contentMode = .scaleAspectFit
  //    backgroundImage.contentMode = .scaleToFill
  //    backgroundImage.contentMode = .scaleAspectFill
      backgroundImage.image = UIImage(named: "lego.png")!
      backgroundImage.alpha = 0.2
      self.view.insertSubview(backgroundImage, at: 0)
      background = true
    }
    
//    spokenText.text = ""
    communications?.missing = self
  }
  
  var paused = DispatchTimeInterval.seconds(12)
  
  func firstShown() {
    
    if firstShow {
      infoText = UILabel(frame: CGRect(x: leftMargin, y: topMargin + 20, width: self.view.bounds.width - 40, height: 40))
      infoText!.isUserInteractionEnabled = true
      
      infoText!.numberOfLines = 0
      infoText!.textAlignment = .center
    //    introText.backgroundColor = .yellow
      self.view.addSubview(infoText!)
    }
    
    if inapp.text == IAPStatus.purchased.rawValue || inapp.text == IAPStatus.restored.rawValue {
      UIView.animate(withDuration: 0.5) {
        self.inapp.alpha = 0
      }
    } else {
      UIView.animate(withDuration: 0.5) {
        self.inapp.alpha = 1
        UIView.animate(withDuration: 2) {
          self.inapp.alpha = 0
        }
      }
    }
        
    if port2G != nil && firstShow {
//      gearBOutlet.isEnabled = false
      stackviewDots.isHidden = true
      infoText!.text = "The Sensors"
      UIView.animate(withDuration: 0.5) {
        self.infoText!.center = CGPoint(x:self.view.bounds.midX,y:self.view.bounds.minY + 128)
      }
      infoText!.font = UIFont.preferredFont(forTextStyle: .body)
      infoText!.adjustsFontForContentSizeCategory = true
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
        self.infoText!.text = "Report location"
        self.locationBOutlet.grow()
        self.locationBOutlet.isEnabled = true
        self.locationTag.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
          self.infoText!.text = "Turn on proximity alerts"
          self.proximityBOutlet.grow()
          self.proximityBOutlet.isEnabled = true
          self.proximityTag.isHidden = false
          DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.infoText!.text = "Speak text sent"
            self.speakerBOutlet.grow()
            self.speakerBOutlet.isEnabled = true
            self.talkTag.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
              self.infoText!.text = "Listen to voice"
              self.voiceBOutlet.grow()
              self.voiceBOutlet.isEnabled = true
              self.voiceTag.isHidden = false
              DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.infoText!.text = "Stream phone motion"
                self.motionBOutlet.grow()
                self.motionBOutlet.isEnabled = true
                self.motionTag.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                  self.infoText!.text = "Stream compass position"
                  self.azimuthBOutlet.grow()
                  self.azimuthBOutlet.isEnabled = true
                  self.azimuthTag.isHidden = false
                  DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                    self.infoText!.text = ""
                    self.firstShow = false
                    if pulse! {
                      Timer.scheduledTimer(withTimeInterval: refreshRate!.doubleValue, repeats: true) { (timer) in
                        
                        communications?.pulseUDP2(superRec2)
                      }
                    }
                    if !fastStart! {
                      let textFeed = "Remember Tansmitting sensors text blinks when they are sending data out."
                      
                      self.moreText.text = ""
                      self.moreText.alpha = 1
                      self.moreText.preferredMaxLayoutWidth = self.view.bounds.width - 40
                      self.moreText.font = UIFont.preferredFont(forTextStyle: .body)
                      self.moreText.adjustsFontForContentSizeCategory = true
                      self.moreText.isHidden = false
                      self.moreText.textAlignment = .left
                      self.moreText.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
                      self.moreText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 112)
                      
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let words = Array(textFeed)
                        var i = 0
                        let pause = 0.1
                       
                        let delay = pause * Double(textFeed.count)
                        
                        self.paused = DispatchTimeInterval.seconds(Int(delay + 4))
                        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
                          
                          self.moreText.text = self.moreText.text! + String(words[i])
                          if i == words.count - 1 {
                            timer.invalidate()
                            UIView.animate(withDuration: 12) {
                              self.moreText.alpha = 0
                            }
                                    
                          } else {
                            i = i + 1
                            
                          }
                        }
                      })
                    }
                    
                    
                    
                    
                    
                  })
                })
              })
            })
          })
        })
      })
    }
    lastButton?.grow()
  }
    

  
  func redo(_ value: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: value, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
    
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
      if motion == .motionShake {
        if strongGear != nil && connect2G != nil && port2G != nil {
          let alert = UIAlertController(title: "Quick Reset or Settings", message: "Do you want to try to reset the network?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Opps Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Reset Connection", style: .default, handler: { action in
                  communications?.disconnectUDP()
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                      let hostUDPx = NWEndpoint.Host.init(connect2G!)
                      let portUDPx = NWEndpoint.Port.init(String(port2G!))
                      communications?.connectToUDP(hostUDP: hostUDPx, portUDP: portUDPx!)
                  })
                }))
                alert.addAction(UIAlertAction(title: "Goto Settings", style: .default, handler: { action in
                  if let url = URL(string:UIApplication.openSettingsURLString) {
                     if UIApplication.shared.canOpenURL(url) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                     }
                  }
                }))
                self.present(alert, animated: true)
                
        } else {
        if let url = URL(string:UIApplication.openSettingsURLString) {
           if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
        }
      }
      }
      
    }
    
 
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    timer?.invalidate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      if !fastStart! {
        self.introText.text = "Having configured your port, your free to choose any of six sensors you wish to send data to it"
      }
        self.page1.image = UIImage(named: "whiteDot")
        self.page2.image = UIImage(named: "whiteDot")
        self.page3.image = UIImage(named: "whiteDot")
    })
    
    if segue.identifier == "motion" {
      if let nextViewController = segue.destination as? motionVC {
        nextViewController.tag = views2G.motion.rawValue
        nextViewController.status = self
        communications?.missing = nextViewController
        strongMotion = nextViewController
        
      }
    }
    
    if segue.identifier == "azimuth" {
      if let nextViewController = segue.destination as? azimuthVC {
        nextViewController.tag = views2G.azimuth.rawValue
        nextViewController.status = self
        communications?.missing = nextViewController
        strongCompass = nextViewController
        
      }
    }
    
    if segue.identifier == "location" {
      if let nextViewController = segue.destination as? locationVC {
        nextViewController.tag = views2G.location.rawValue
        nextViewController.status = self
        communications?.missing = nextViewController
        strongLocation = nextViewController
        
      }
    }
    
    if segue.identifier == "config" {
      if let nextViewController = segue.destination as? gearVC {
        nextViewController.tag = views2G.gear.rawValue
        nextViewController.feeder = self
        nextViewController.status = self
        communications?.missing = nextViewController
        strongGear = nextViewController
        
      }
    }
    
    if segue.identifier == "speaker" {
      if let nextViewController = segue.destination as? speakerVC {
        nextViewController.tag = views2G.speaker.rawValue
        nextViewController.status = self
        communications?.missing = nextViewController
        strongSpeaker = nextViewController
        
      }
    }
    
    if segue.identifier == "voice" {
      if let nextViewController = segue.destination as? voiceVC {
        nextViewController.tag = views2G.voice.rawValue
        nextViewController.said = self
        nextViewController.status = self
        communications?.missing = nextViewController
        strongMic = nextViewController
      }
    }
    
    if segue.identifier == "proximity" {
      if let nextViewController = segue.destination as? proximityVC {
        nextViewController.tag = views2G.proximity.rawValue
        nextViewController.status = self
        communications?.missing = nextViewController
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

var blinkers = [views2G:Timer?]()

extension UILabel {
  func blinkText(tag: views2G) {
    if blinkers[tag] != nil { return }
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
        
        if self.textColor == UIColor.black {
          self.textColor = UIColor.gray
        } else {
          self.textColor = UIColor.black
        }
        blinkers[tag] = timer
//      } else {
//        self.textColor = UIColor.black
//        timer.invalidate()
//      }
    }
  }
  
  func noblinkText(tag: views2G) {
    let timer = blinkers[tag]
    if timer != nil {
      timer!?.invalidate()
      blinkers[tag] = nil
    }
  }
  
  func blinkText8() {
    var count = 0
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            
          if self.textColor == UIColor.systemBlue {
              self.textColor = UIColor.blue
              count = count + 1
            } else {
              self.textColor = UIColor.systemBlue
            }
          if count > 8 {
            self.textColor = UIColor.systemBlue
            timer.invalidate()
          }
        }
  }
}

