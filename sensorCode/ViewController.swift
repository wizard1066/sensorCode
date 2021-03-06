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
  func incoming(ipaddr: String)
  func outgoing(ipaddr: String)
}

enum views2G: Int {
  case azimuth = 0
  case motion = 1
  case voice = 2
  case gear = 3
  case location = 4
  case proximity = 5
  case speaker = 6
  case light = 7
  case connect = 8
}

class ViewController: UIViewController, speaker, transaction, spoken, setty, running, lostLink, UIScrollViewDelegate {

  private var neverSet = true
  
  func outgoing(ipaddr: String) {
    if neverSet {
      let tmp = sendingOutlet.text
      sendingOutlet.text = ipaddr + ":" + tmp!
      neverSet = false
    }
  }
  
  func incoming(ipaddr: String) {
    DispatchQueue.main.async {
      self.recievingOutlet.text = ipaddr
      self.recievingOutlet.isHidden = false
//      self.recieve.isHidden = false
    }
  }
  
  func sendAlert(error: String) {
    redo(error)
  }
  
  func turnOff(views2G label: Int) {
    switch label {
      case views2G.azimuth.rawValue:
        azimuthTag.noblinkText(tag: views2G(rawValue: label)!)
        azimuthID.backgroundColor = .systemRed
      case views2G.motion.rawValue:
        motionTag.noblinkText(tag: views2G(rawValue: label)!)
        motionID.backgroundColor = .systemRed
      case views2G.voice.rawValue:
        voiceTag.noblinkText(tag: views2G(rawValue: label)!)
        voiceID.backgroundColor = .systemRed
      case views2G.location.rawValue:
        locationTag.noblinkText(tag: views2G(rawValue: label)!)
        locationID.backgroundColor = .systemRed
      case views2G.proximity.rawValue:
        proximityTag.noblinkText(tag: views2G(rawValue: label)!)
        proximityID.backgroundColor = .systemRed
      case views2G.speaker.rawValue:
        talkTag.noblinkText(tag: views2G(rawValue: label)!)
        talkID.backgroundColor = .systemRed
      case views2G.gear.rawValue:
        connectTag.noblinkText(tag: views2G(rawValue: label)!)
        connectID.backgroundColor = .systemRed
      case views2G.light.rawValue:
        lightTag.noblinkText(tag: views2G(rawValue: label)!)
        lightID.backgroundColor = .systemRed
      default:
        break
    }
  }
  
  func turnOn(views2G label: Int) {
    switch label {
      case views2G.azimuth.rawValue:
        azimuthTag.blinkText(tag: views2G(rawValue: label)!)
        azimuthID.backgroundColor = .systemGreen
      case views2G.motion.rawValue:
        motionTag.blinkText(tag: views2G(rawValue: label)!)
        motionID.backgroundColor = .systemGreen
      case views2G.voice.rawValue:
        voiceTag.blinkText(tag: views2G(rawValue: label)!)
        voiceID.backgroundColor = .systemGreen
      case views2G.location.rawValue:
        locationTag.blinkText(tag: views2G(rawValue: label)!)
        locationID.backgroundColor = .systemGreen
      case views2G.proximity.rawValue:
        proximityTag.blinkText(tag: views2G(rawValue: label)!)
        proximityID.backgroundColor = .systemGreen
      case views2G.speaker.rawValue:
        talkTag.blinkText(tag: views2G(rawValue: label)!)
        talkID.backgroundColor = .systemGreen
      case views2G.gear.rawValue:
        connectTag.blinkText(tag: views2G(rawValue: label)!)
        connectID.backgroundColor = .systemGreen
      case views2G.light.rawValue:
        lightTag.blinkText(tag: views2G(rawValue: label)!)
        lightID.backgroundColor = .systemGreen
      default:
        break
    }
  }

  func returnPostNHost(port: String, host: String) {
    DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
   
      self.sendingOutlet.isHidden = false
      self.connectTag.text = "connect"
      self.sendingOutlet.text = host + ":" + port
    })
    displayButtons = true
  }

  func wordUsed(word2D: String) {
    spokenText.isHidden = false
    spokenText.text = word2D
  }
  
  
  @IBAction func restoreAction(_ sender: UIButton) {
    DispatchQueue.main.async { [unowned self] in
      let connected = NetStatus.shared.isConnected
      if !connected {
        self.alertNoNetwork()
      } else {
        IAPService.shared.getProducts()
        IAPService.shared.ordered = self
        IAPService.shared.restorePurchases()
        UIView.animate(withDuration: 8, animations: {
          self.restoreButton.alpha = 0
        }) { (success) in
          self.restoreButton.isHidden = true
        }
      }
    }
  }
  
  @IBOutlet weak var restoreButton: UIButton!
  
  @IBOutlet weak var inapp: UILabel!
  @IBOutlet weak var moreText: UILabel!
  @IBOutlet weak var controls: UIStackView!
  
  var purchases:[String:Bool] = [:]
  var displayButtons = false

  func feedback(service: String, message: String) {
//    print("feedback ",service,"message ",message)
    inapp.text = message
    if message != IAPStatus.restored.rawValue {
      UIView.animate(withDuration: 4, animations: {
        self.inapp.alpha = 1
      }) { (finished) in
        self.inapp.alpha = 0
      }
    }
    if service == IAPProduct.light.rawValue && message == IAPStatus.purchased.rawValue {
      if strongLight != nil {
        present(strongLight!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "light", sender: self)
      }
      lightBOutlet.setBackgroundImage(nil, for: .normal)
    }
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.purchased.rawValue {
      if strongCompass != nil {
        present(strongCompass!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "azimuth", sender: self)
      }
      azimuthBOutlet.setBackgroundImage(nil, for: .normal)
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMic != nil {
        present(strongMic!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "voice", sender: self)
      }
      voiceBOutlet.setBackgroundImage(nil, for: .normal)
    }
    if service == IAPProduct.motion.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMotion != nil {
        present(strongMotion!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "motion", sender: self)
      }
      motionBOutlet.setBackgroundImage(nil, for: .normal)
    }
    
    if service == IAPProduct.light.rawValue && message == IAPStatus.restored.rawValue {
      lightBOutlet.setBackgroundImage(nil, for: .normal)

    }
    
    if service == IAPProduct.motion.rawValue && message == IAPStatus.restored.rawValue {
      motionBOutlet.setBackgroundImage(nil, for: .normal)
      
    }
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.restored.rawValue {
      azimuthBOutlet.setBackgroundImage(nil, for: .normal)
      
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.restored.rawValue {
      voiceBOutlet.setBackgroundImage(nil, for: .normal)
      
    }
    if message == IAPStatus.restored.rawValue {
      purchases[service] = true
    }
  }
 
  var blinkStatus:Bool?
  var once: Bool = false
  
//  @IBOutlet weak var highImage: UIImageView!
//  @IBOutlet weak var lowImage: UIImageView!

  @IBOutlet weak var voiceTag: UILabel!
  @IBOutlet weak var motionTag: UILabel!
  @IBOutlet weak var azimuthTag: UILabel!
  @IBOutlet weak var locationTag: UILabel!
  @IBOutlet weak var proximityTag: UILabel!
  @IBOutlet weak var talkTag: UILabel!
  @IBOutlet weak var connectTag: UILabel!
//  @IBOutlet weak var toolsTag: UILabel!
  @IBOutlet weak var lightTag: UILabel!
  

  @IBOutlet weak var sendingOutlet: UILabel!
  @IBOutlet weak var recievingOutlet: UILabel!

//  @IBOutlet weak var recieve: UILabel!
  
  
  @IBOutlet weak var stackviewDots: UIStackView!
  @IBOutlet weak var gearBOutlet: UIButton!
  @IBOutlet weak var speakerBOutlet: UIButton!
  @IBOutlet weak var proximityBOutlet: UIButton!
  @IBOutlet weak var locationBOutlet: UIButton!
  @IBOutlet weak var voiceBOutlet: UIButton!
  @IBOutlet weak var motionBOutlet: UIButton!
  @IBOutlet weak var azimuthBOutlet: UIButton!
  @IBOutlet weak var toolBOutlet: UIButton!
  @IBOutlet weak var lightBOutlet: UIButton!
  
  @IBOutlet weak var proximityID: UIButton!
  @IBOutlet weak var azimuthID: UIButton!
  @IBOutlet weak var locationID: UIButton!
  @IBOutlet weak var motionID: UIButton!
  @IBOutlet weak var voiceID: UIButton!
  @IBOutlet weak var lightID: UIButton!
  @IBOutlet weak var talkID: UIButton!
  @IBOutlet weak var connectID: UIButton!
  
  @IBAction func motionIDAction(_ sender: Any) {
    highMoreBO.sendActions(for: .touchUpInside)
  }
  @IBAction func azimuthIDAction(_ sender: Any) {
    highMoreBO.sendActions(for: .touchUpInside)
  }
  @IBAction func lightIDAction(_ sender: Any) {
    lowMoreBO.sendActions(for: .touchUpInside)
  }
  @IBAction func voiceIDAction(_ sender: Any) {
    lowMoreBO.sendActions(for: .touchUpInside)
  }
  

  
  @objc func swipe(sender: UISwipeGestureRecognizer) {
    if sender.direction == .down {
      if sender.state == .ended {
//        let now = cwindow.contentOffset
//        if now.y + 128 < (cwindow.contentSize.height - 128) {
//          cwindow.setContentOffset(CGPoint(x: 0, y: now.y + 128), animated: true)
//        }
        cwindow.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
      }
    }
    if sender.direction == .up {
      if sender.state == .ended {
//        let now = cwindow.contentOffset
//        if now.y - 128 > -128 {
//          cwindow.setContentOffset(CGPoint(x: 0, y: now.y - 128), animated: true)
//        }
        cwindow.setContentOffset(CGPoint(x: 0, y: cwindow.contentSize.height - 256), animated: true)
      }
    }
  }
  
  
  @IBOutlet weak var highMoreBO: UIButton!
  @IBAction func highMoreB(_ sender: Any) {
//    self.lightBOutlet.isHidden = true
//    self.voiceBOutlet.isHidden = true
    self.voiceID.layer.borderColor = UIColor.white.cgColor
    self.lightID.layer.borderColor = UIColor.white.cgColor
    self.lightTag.textColor = UIColor.darkGray
    self.voiceTag.textColor = UIColor.darkGray
    self.highMoreBO.isHidden = true
//    self.lowMoreBO.isHidden = false
    
    self.azimuthBOutlet.isHidden = false
    self.azimuthTag.textColor = UIColor.black

    self.motionBOutlet.isHidden = false
    self.motionTag.textColor = UIColor.black

    self.azimuthID.layer.borderColor = UIColor.clear.cgColor
    self.motionID.layer.borderColor = UIColor.clear.cgColor
  }

  
  @IBOutlet weak var lowMoreBO: UIButton!
  @IBAction func lowMoreBA(_ sender: Any) {
//    self.motionBOutlet.isHidden = true
//    self.azimuthBOutlet.isHidden = true
    self.motionID.layer.borderColor = UIColor.white.cgColor
    self.azimuthID.layer.borderColor = UIColor.white.cgColor
    self.motionTag.textColor = UIColor.darkGray
    self.azimuthTag.textColor = UIColor.darkGray
    self.lowMoreBO.isHidden = true
//    self.highMoreBO.isHidden = false
    
    self.lightBOutlet.isHidden = false
    self.lightTag.textColor = UIColor.black

    self.voiceBOutlet.isHidden = false
    self.voiceTag.textColor = UIColor.black
    
    self.lightID.layer.borderColor = UIColor.clear.cgColor
    self.voiceID.layer.borderColor = UIColor.clear.cgColor
  }
  
  var strongCompass:azimuthVC?
  var strongMotion:motionVC?
  var strongMic:voiceVC?
  var strongSpeaker: speakerVC?
  var strongLocation: locationVC?
  var strongGear: gearVC?
  var strongProximity: proximityVC?
  var strongTool: toolsVC?
  var strongLight: LightVC?

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
  
  @IBAction func lightBAction(_ sender: UIButton) {
    lastButton = lightBOutlet
    if purchases[IAPProduct.light.rawValue] == nil {
      IAPService.shared.ordered = self
      IAPService.shared.purchase(product: .light)
    } else {
      feedback(service: IAPProduct.light.rawValue, message: IAPStatus.purchased.rawValue)
    }
  }
  
  @IBAction func azimuthBAction(_ sender: Any) {
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
      self.gearBOutlet.alpha = 1
      self.speakerBOutlet.alpha = 1
      nextOutlet.isHidden = true
    }
  }
  
  func showButtonBar() {
    self.voiceBOutlet.alpha = 1
    self.speakerBOutlet.alpha = 1
    self.proximityBOutlet.alpha = 1
    self.locationBOutlet.alpha = 1
    self.azimuthBOutlet.alpha = 1
    self.motionBOutlet.alpha = 1
    self.gearBOutlet.alpha = 1
    self.lightBOutlet.alpha = 1
//    self.highMoreBO.isHidden = false
//    self.lowMoreBO.isHidden = false
    self.proximityBOutlet.isHidden = false
    self.locationBOutlet.isHidden = false
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
    swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeLeftFunction(sender:)))
    swipeLeft.direction = .left
    swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeRightFunction(sender:)))
    swipeRight.direction = .right
    introText.addGestureRecognizer(swipeLeft)
    introText.numberOfLines = 0
    introText.textAlignment = .justified
    introText.font = UIFont(name: "Futura-CondensedMedium", size: 17)

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
  
  var cwindow: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cwindow = UIScrollView(frame: CGRect(x: self.view.bounds.midX - 64, y: self.view.bounds.midY - 128, width: controls.bounds.width + 64, height: 256))
    cwindow.contentSize = CGSize(width: controls.bounds.width, height: 580)
   
    cwindow.isScrollEnabled = true
    cwindow.isUserInteractionEnabled = true
    cwindow.showsVerticalScrollIndicator = false
    cwindow.showsHorizontalScrollIndicator = false
    cwindow.delegate = self
    cwindow.backgroundColor = .clear
    cwindow.addSubview(controls)
    cwindow.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
    self.view.addSubview(cwindow)
    
    self.restoreButton.blinkText()
 
    
//    for family in UIFont.familyNames {
//        print("\(family)")
//
//        for name in UIFont.fontNames(forFamilyName: family) {
//            print("   \(name)")
//        }
//    }
    
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
//            IAPService.shared.getProducts()
//            IAPService.shared.ordered = self
//            IAPService.shared.restorePurchases()
        }
      }
    }
      
    NetStatus.shared.startMonitoring()
    NetStatus.shared.getInfo()
    
    let rad2:CGFloat = 8
    
//    highMoreBO.layer.borderColor = UIColor.systemBlue.cgColor
    
    motionID.layer.borderWidth = 1
    motionID.layer.cornerRadius = rad2
    motionID.clipsToBounds = true
    motionID.layer.borderColor = UIColor.clear.cgColor
    
    azimuthID.layer.borderWidth = 1
    azimuthID.layer.cornerRadius = rad2
    azimuthID.clipsToBounds = true
    azimuthID.layer.borderColor = UIColor.clear.cgColor
    
    connectID.layer.borderWidth = 1
    connectID.layer.cornerRadius = rad2
    connectID.clipsToBounds = true
    connectID.layer.borderColor = UIColor.clear.cgColor
    
    locationID.layer.borderWidth = 1
    locationID.layer.cornerRadius = rad2
    locationID.clipsToBounds = true
    locationID.layer.borderColor = UIColor.clear.cgColor

    
    talkID.layer.borderWidth = 1
    talkID.layer.cornerRadius = rad2
    talkID.clipsToBounds = true
    talkID.layer.borderColor = UIColor.clear.cgColor
    
    proximityID.layer.borderWidth = 1
    proximityID.layer.cornerRadius = rad2
    proximityID.clipsToBounds = true
    proximityID.layer.borderColor = UIColor.clear.cgColor
    
    lightID.layer.borderWidth = 1
    lightID.layer.cornerRadius = rad2
    lightID.clipsToBounds = true
    lightID.layer.borderColor = UIColor.clear.cgColor
    
    voiceID.layer.borderWidth = 1
    voiceID.layer.cornerRadius = rad2
    voiceID.clipsToBounds = true
    voiceID.layer.borderColor = UIColor.clear.cgColor
    

    let rad:CGFloat = 25
    let wid:CGFloat = 2
    
//    highMoreBO.layer.borderWidth = 2
//    highMoreBO.layer.borderColor = UIColor.systemBlue.cgColor
//    highMoreBO.clipsToBounds = true
//    highMoreBO.layer.cornerRadius = 22
//
//    lowMoreBO.layer.borderWidth = 2
//    lowMoreBO.layer.borderColor = UIColor.systemBlue.cgColor
//    lowMoreBO.clipsToBounds = true
//    lowMoreBO.layer.cornerRadius = 22
    
    
    
    azimuthBOutlet.layer.borderWidth = wid
    azimuthBOutlet.layer.borderColor = UIColor.black.cgColor
    azimuthBOutlet.clipsToBounds = true
    azimuthBOutlet.layer.cornerRadius = 30
    
    motionBOutlet.layer.borderWidth = wid
    motionBOutlet.layer.borderColor = UIColor.black.cgColor
    motionBOutlet.clipsToBounds = true
    motionBOutlet.layer.cornerRadius = 30
    
    voiceBOutlet.layer.borderWidth = wid
    voiceBOutlet.layer.borderColor = UIColor.black.cgColor
    voiceBOutlet.clipsToBounds = true
    voiceBOutlet.layer.cornerRadius = 30
    
    lightBOutlet.layer.borderWidth = wid
    lightBOutlet.layer.borderColor = UIColor.black.cgColor
    lightBOutlet.clipsToBounds = true
    lightBOutlet.layer.cornerRadius = 30
    
    speakerBOutlet.layer.borderWidth = wid
    speakerBOutlet.layer.borderColor = UIColor.black.cgColor
    speakerBOutlet.clipsToBounds = true
    speakerBOutlet.layer.cornerRadius = 33
    
    locationBOutlet.layer.borderWidth = wid
    locationBOutlet.layer.borderColor = UIColor.black.cgColor
    locationBOutlet.clipsToBounds = true
    locationBOutlet.layer.cornerRadius = 30
    
    proximityBOutlet.layer.borderWidth = wid
    proximityBOutlet.layer.borderColor = UIColor.black.cgColor
    proximityBOutlet.clipsToBounds = true
    proximityBOutlet.layer.cornerRadius = 30
    

    
    let rad3:CGFloat = 33
    
    gearBOutlet.layer.borderWidth = wid
    gearBOutlet.layer.borderColor = UIColor.black.cgColor
    gearBOutlet.clipsToBounds = true
    gearBOutlet.layer.cornerRadius = 33
    
    toolBOutlet.layer.borderWidth = wid
    toolBOutlet.layer.borderColor = UIColor.black.cgColor
    toolBOutlet.clipsToBounds = true
    toolBOutlet.layer.cornerRadius = 36
    
    topMargin = view.safeAreaInsets.top
    leftMargin = view.safeAreaInsets.left + 20
    rightMargin = view.safeAreaInsets.right - 20
    

    tapper = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapper(sender:)))
    introCurrent = introValue.first
   
    communications = connect()
    communications?.spoken = self
    

    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidEnterBackground(notification:)),
                                           name: UIApplication.didEnterBackgroundNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
    
    if !fastStart! {
      nextOutlet.grow()
      nextOutlet.blinkText()
      tapMe()
    } else {
      gearBOutlet.isEnabled = true
      gearBOutlet.isHidden = false
      nextOutlet.isHidden = true
//      topImage.isHidden = true
      delay = DispatchTimeInterval.nanoseconds(500)
      toolBOutlet.isEnabled = true
      toolBOutlet.isHidden = false
//      connectTag.isHidden = false
//      toolsTag.isHidden = false
      talkTag.isHidden = false
      talkTag.isEnabled = true
      
      self.speakerBOutlet.isEnabled = true
    }
    
    if port2G == nil {
      sendingOutlet.isHidden = true
      recievingOutlet.isHidden = true
      spokenText.isHidden = true
//      self.connectTag.isHidden = true
    }
    
    definePulse()
    
    if fastStart! {
      self.stackviewDots.isHidden = true
      self.motionBOutlet.isEnabled = true
      self.azimuthBOutlet.isEnabled = true
      self.locationBOutlet.isEnabled = true
      self.proximityBOutlet.isEnabled = true
      self.lightBOutlet.isEnabled = true
      self.voiceBOutlet.isEnabled = true
    }

//    let hover = UIHoverGestureRecognizer(target: self, action: hover)
  }
  
  func definePulse() {
    let epoch = String(NSDate().timeIntervalSince1970)
    
    if variable! {
      let superGPS = gps(latitude: nil, longitude: nil, altitude: nil)
      let superMOV = fly(roll: nil, pitch: nil, yaw: nil)
      let superDIR = globe(trueNorth: nil, magneticNorth: nil)
      superRec2 = pulser2(id: epoch, wd: nil, px: nil, pos: superGPS, mov: superMOV, dir: superDIR)
     
    } else {
      let superGPS = gps(latitude: "", longitude: "", altitude: "")
      let superMOV = fly(roll: "", pitch: "", yaw: "")
      let superDIR = globe(trueNorth: "", magneticNorth: "")
      superRec2 = pulser2(id: epoch, wd: "", px: "", pos: superGPS, mov: superMOV, dir: superDIR)
    }
  }
  
  func appRestartRequest() {
    let alertController = UIAlertController(title: "Restart Required", message: "Changing the app defaults will ONLY take effect after an app restart", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  @objc func defaultsChanged(notification:NSNotification){
      if let defaults = notification.object as? UserDefaults {
        pulse = defaults.bool(forKey: ap.pulse.rawValue)
        autoClose = UserDefaults.standard.bool(forKey: ap.auto.rawValue)
        variable = UserDefaults.standard.bool(forKey: ap.variable.rawValue)
        pulse = UserDefaults.standard.bool(forKey: ap.pulse.rawValue)
        raw = UserDefaults.standard.bool(forKey: ap.raw.rawValue)
        precision = UserDefaults.standard.string(forKey: ap.precision.rawValue)
        refreshRate = UserDefaults.standard.string(forKey: ap.rate.rawValue)
      }
      if pulseTimer != nil && pulse == false {
        pulseTimer?.invalidate()
        pulseTimer = nil
        let nc = NotificationCenter.default
        let userInfo:[String:Bool] = ["pulseBool":true]
        nc.post(name: Notification.Name("pulseChanged"), object: nil, userInfo: userInfo)
      }
      if pulseTimer == nil && pulse == true {
        self.pulseTimer = Timer.scheduledTimer(withTimeInterval: refreshRate!.doubleValue, repeats: true) { (timer) in
          communications?.pulseUDP2(superRec2!)
        }
        let nc = NotificationCenter.default
        let userInfo:[String:Bool] = ["pulseBool":false]
        nc.post(name: Notification.Name("pulseChanged"), object: nil, userInfo: userInfo)
      }
      definePulse()
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
      lightBOutlet.alpha = 0

      if introCurrent == introValue.first {

        introText.text = "Your smartphone has more than half a dozen sensors within it. Make your robot smarter by sharing the data captured by those sensors. Think azimuth, motion, voice and more ..."
        introCord = introText.frame.origin.y
        introCord = introText.center.y
        introCordX = introText.center.x
        
        introCurrent = introValue.second
        
          page1.image = UIImage(named: "black")
          page2.image = UIImage(named: "white")
          page3.image = UIImage(named: "white")
        
      }
      introText.addGestureRecognizer(swipeLeft)
//      topImage.image = nil

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
//    nextOutlet.splitWord()
    UIView.animate(withDuration: 0.5) {
      self.introText.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
//      self.topImage.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      
      if self.introCurrent == introValue.second {
        self.nextOutlet.blinkText()
        self.introText.text = "Access the data thru a common UDP port you define. Write code on your robot to capture and process data sent and received..."
        self.introCurrent = introValue.third
          self.page1.image = UIImage(named: "white")
          self.page2.image = UIImage(named: "black")
          self.page3.image = UIImage(named: "white")
        
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
//      self.topImage.center = CGPoint(x:-self.view.bounds.maxX,y:self.introCord)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      
      if self.introCurrent == introValue.third {

        self.introText.text = "Use the gear icon to get started. Azimuth, motion and voice are inapp purchases. Location, proximity and speaker are offered for free."
        self.introCurrent = introValue.all
        
          self.page1.image = UIImage(named: "white")
          self.page2.image = UIImage(named: "white")
          self.page3.image = UIImage(named: "black")
        
      }
      
      UIView.animate(withDuration: 0.5) {
        self.introText.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
//        self.topImage.center = CGPoint(x:self.view.bounds.midX,y:self.introCord)
      }
      

//        self.topImage.image = UIImage(named: "cog")
//        self.topImage.alpha = 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          self.gearBOutlet.isHidden = false
          self.gearBOutlet.isEnabled = true
          
          
//          self.connectTag.isHidden = false
//          self.toolsTag.isHidden = false
          self.talkTag.isHidden = false
          self.talkTag.isEnabled = true
          
          self.toolBOutlet.isEnabled = true
          self.toolBOutlet.isHidden = false
          
          self.speakerBOutlet.isEnabled = true
          self.gearBOutlet.grow()
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.speakerBOutlet.grow()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
              self.toolBOutlet.grow()
            })
          })
        })
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
        
        UIView.animate(withDuration: 4) {
          self.introText.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
//          self.topImage.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
        }
        
        UIView.animate(withDuration: 0.5) {
//          self.topImage.alpha = 0
          self.page3.image = UIImage(named: "white")
        }
        
        
        
      })
    })
    
  let swipeDemo = UIImageView(frame: CGRect(x: 72, y: 280, width: 50, height: 50))
  swipeDemo.alpha = 0
  swipeDemo.image = UIImage(named: "swipeA")
  cwindow.addSubview(swipeDemo)
  UIView.animate(withDuration: 2) {
    swipeDemo.alpha = 0.8
  }
  UIView.animate(withDuration: 3, animations: {
    swipeDemo.transform = CGAffineTransform(translationX: 0, y: 64)
  }) { (Good) in
    UIView.animate(withDuration: 3, animations: {
      swipeDemo.transform = CGAffineTransform(translationX: 0, y: -64)
    }) { (Good) in
      UIView.animate(withDuration: 3, animations: {
        swipeDemo.transform = CGAffineTransform(translationX: 0, y: 64)
      }) { (Good) in
        UIView.animate(withDuration: 3, animations: {
          swipeDemo.transform = .identity
        }) { (Good) in
          UIView.animate(withDuration: 2) {
            swipeDemo.alpha = 0
          }
        }
      }
    }
  }
  }
  
  
  
  @objc func tapper(sender: Any) {
    UIView.animate(withDuration: 0.5) {
              self.introText.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
//              self.topImage.center = CGPoint(x:self.introCordX,y:-self.view.bounds.maxY)
            }
            
            UIView.animate(withDuration: 0.5) {
//              self.topImage.alpha = 0
              self.gearBOutlet.alpha = 1.0
              self.gearBOutlet.isEnabled = true
              self.page3.image = UIImage(named: "white")
    //          self.voiceBOutlet.shake()
              
              
            }
  }
  
  @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    communications?.missing = self
    nextOutlet.isHidden = true
    
    if displayButtons {
      proximityID.layer.borderColor = UIColor.white.cgColor
      locationID.layer.borderColor = UIColor.white.cgColor
      talkID.layer.borderColor = UIColor.white.cgColor
      let swipeU = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe))
      swipeU.direction = .up
      let swipeD = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe))
      swipeD.direction = .down

      self.view.addGestureRecognizer(swipeU)
      self.view.addGestureRecognizer(swipeD)
      showButtonBar()
    }
    if introText != nil {
      introText.text = ""
    }
    if strongSpeaker != nil {
      if (strongSpeaker?.speakerSwitchOutput.isOn)! && (!communications!.connectedStatus) {
        lightTag.isHidden = false
        lightBOutlet.isHidden = false
        lightBOutlet.isEnabled = true
        lightBOutlet.alpha = 1
        
        proximityBOutlet.isHidden = true
        moreText?.isHidden = false
        moreText?.alpha = 0
        moreText!.text = "You need to use the connect button to get full functionaliyt running"
        UIView.animate(withDuration: 2, animations: {
          self.moreText.alpha = 1
        }) { (action) in
          UIView.animate(withDuration: 4) {
            self.moreText.alpha = 0
          }
        }
      }
      // code
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
  var delay:DispatchTimeInterval = DispatchTimeInterval.nanoseconds(500)
  var timer:Timer?
  var pulseTimer: Timer?
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
    
    communications?.missing = self
    
  }
  
  var paused = DispatchTimeInterval.seconds(12)
  var remindme = true
  
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
    
    if fastStart! {
      self.stackviewDots.isHidden = true
      self.motionBOutlet.isEnabled = true
      self.azimuthBOutlet.isEnabled = true
      self.locationBOutlet.isEnabled = true
      self.proximityBOutlet.isEnabled = true
      self.lightBOutlet.isEnabled = true
      self.voiceBOutlet.isEnabled = true
      
      self.motionBOutlet.isHidden = false
      self.azimuthBOutlet.isHidden = false
      self.locationBOutlet.isHidden = false
      self.proximityBOutlet.isHidden = false
//      self.lightBOutlet.isHidden = false
//      self.voiceBOutlet.isHidden = false
      self.highMoreBO.isHidden = true
      
    } else {
    
    if port2G != nil && displayButtons {
      stackviewDots.isHidden = true
      self.motionBOutlet.isEnabled = true
      self.azimuthBOutlet.isEnabled = true
      self.locationBOutlet.isEnabled = true
      self.proximityBOutlet.isEnabled = true
      self.lightBOutlet.isEnabled = true
      self.voiceBOutlet.isEnabled = true
      
      
      
      infoText!.center = CGPoint(x:self.view.bounds.midX,y:self.view.bounds.maxY - 80)
      infoText!.font = UIFont(name: "Futura-CondensedMedium", size: 17)
      infoText!.adjustsFontForContentSizeCategory = true
      
      
//      highImage.alpha = 0.5
//      highImage.image = UIImage(named:"uswipeB")
//      UIView.animate(withDuration: 1, animations: {
//        self.highImage.transform = CGAffineTransform(translationX: 0, y: 128)
//      }) { (blsh) in
//        self.highImage.transform = .identity
//        UIView.animate(withDuration: 1, animations: {
//          self.highImage.transform = CGAffineTransform(translationX: 0, y: 128)
//        }) { (blsh) in
//          self.highImage.transform = .identity
//          UIView.animate(withDuration: 1, animations: {
//            self.highImage.transform = CGAffineTransform(translationX: 0, y: 128)
//          }) { (blsh) in
//            self.highImage.transform = .identity
//            self.highMoreBO.sendActions(for: .touchUpInside)
//            UIView.animate(withDuration: 2) {
//                self.highImage.alpha = 0
//            }
//          }
//        }
//      }
          
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay + 2, execute: {
        self.motionBOutlet.grow()
        self.motionTag.isHidden = false
        self.azimuthBOutlet.grow()
        self.azimuthTag.isHidden = false
        self.locationBOutlet.grow()
        self.locationTag.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay + 4, execute: {
  
//          self.lowImage.alpha = 0.5
//          self.lowImage.image = UIImage(named:"dswipeB")
//          UIView.animate(withDuration: 1, animations: {
//            self.lowImage.transform = CGAffineTransform(translationX: 0, y: -128)
//          }) { (blsh) in
//            self.lowImage.transform = .identity
//            UIView.animate(withDuration: 1, animations: {
//              self.lowImage.transform = CGAffineTransform(translationX: 0, y: -128)
//            }) { (blsh) in
//              self.lowImage.transform = .identity
//              UIView.animate(withDuration: 1, animations: {
//                self.lowImage.transform = CGAffineTransform(translationX: 0, y: -128)
//              }) { (blsh) in
//                self.lowImage.transform = .identity
//                self.lowMoreBO.sendActions(for: .touchUpInside)
//                UIView.animate(withDuration: 2) {
//                  self.lowImage.alpha = 0
//                }
//              }
//            }
//          }
          DispatchQueue.main.asyncAfter(deadline: .now() + self.delay + 2, execute: {
            self.proximityBOutlet.grow()
            self.proximityTag.isHidden = false
            self.lightBOutlet.grow()
            self.lightTag.isHidden = false
            self.voiceBOutlet.grow()
            self.voiceTag.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay + 2, execute: {
              self.infoText!.text = ""
              self.firstShow = false
              
              if !fastStart! && self.remindme {
                self.remindme = false
                let textFeed = "Note the indicator on the right side listing all the sensors turns green and the text blinks when they are turned on."
                self.moreText.text = ""
                self.moreText.alpha = 1
                self.moreText.preferredMaxLayoutWidth = self.view.bounds.width - 80
                self.moreText.font = UIFont(name: "Futura-CondensedMedium", size: 17)
                self.moreText.adjustsFontForContentSizeCategory = true
                self.moreText.isHidden = false
                self.moreText.textAlignment = .center
                self.moreText.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
                self.moreText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 140)
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
                      UIView.animate(withDuration: 12, animations: {
                        self.moreText.alpha = 0
                      }) { (fart) in
                        self.moreText.isHidden = true
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
    }
    lastButton?.grow()
    }
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
                      communications?.missing = self
                      communications?.connectToUDP(hostUDP: hostUDPx, portUDP: portUDPx!)
//                      communications?.sendUDP(mode!)
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


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    timer?.invalidate()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      if !fastStart! {
        self.introText.text = "Having configured your port, your free to choose any of six sensors you wish to send data to it"
      }
        self.page1.image = UIImage(named: "white")
        self.page2.image = UIImage(named: "white")
        self.page3.image = UIImage(named: "white")
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
        nextViewController.master = self
//        communications?.missing = nextViewController
        communications?.missing = self
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
    
    if segue.identifier == "light" {
      if let nextViewController = segue.destination as? LightVC {
        nextViewController.tag = views2G.light.rawValue
        nextViewController.status = self
        communications?.missing = nextViewController
        strongLight = nextViewController
        
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

