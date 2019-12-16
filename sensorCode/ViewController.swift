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
  
  var purchases:[String:Bool] = [:]

  func feedback(service: String, message: String) {
    inapp.text = message
    if message != IAPStatus.restored.rawValue {
      UIView.animate(withDuration: 0.5) {
        self.inapp.alpha = 1
      }
    }
    print("feedback",service,message)
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.purchased.rawValue {
      if strongCompass != nil {
        present(strongCompass!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "compass", sender: self)
      }
      compassBOutlet.setBackgroundImage(UIImage(named:"azimuth"), for: .normal)
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMic != nil {
        present(strongMic!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "voice", sender: self)
      }
      micBOutlet.setBackgroundImage(UIImage(named:"voice"), for: .normal)
    }
    if service == IAPProduct.motion.rawValue && message == IAPStatus.purchased.rawValue {
      if strongMotion != nil {
        present(strongMotion!, animated: true, completion: nil)
      } else {
        self.performSegue(withIdentifier: "gyro", sender: self)
      }
      motionBOutlet.setBackgroundImage(UIImage(named:"motion"), for: .normal)
    }
    
    
    if service == IAPProduct.motion.rawValue && message == IAPStatus.restored.rawValue {
      motionBOutlet.setBackgroundImage(UIImage(named:"motion"), for: .normal)
    }
    if service == IAPProduct.azimuth.rawValue && message == IAPStatus.restored.rawValue {
      compassBOutlet.setBackgroundImage(UIImage(named:"azimuth"), for: .normal)
    }
    if service == IAPProduct.voice.rawValue && message == IAPStatus.restored.rawValue {
      micBOutlet.setBackgroundImage(UIImage(named:"voice"), for: .normal)
    }
    if message == IAPStatus.restored.rawValue {
      purchases[service] = true
    }
  }
  


  @IBOutlet weak var topImage: UIImageView!
  var blinkStatus:Bool?
  var once: Bool = false

  
  
  @IBOutlet weak var stackviewDots: UIStackView!
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
  var strongLocation: locationVC?
  var strongGear: gearVC?
  var strongProximity: proximityVC?
  


  @IBAction func motionBAction(_ sender: UIButton) {

    lastButton = motionBOutlet
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
  
  

    lastButton = nil
    if strongGear != nil {
      present(strongGear!, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: "config", sender: self)
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
    lastButton = compassBOutlet
    if purchases[IAPProduct.azimuth.rawValue] == nil {
      IAPService.shared.ordered = self
      IAPService.shared.purchase(product: .azimuth)
    } else {
      feedback(service: IAPProduct.azimuth.rawValue, message: IAPStatus.purchased.rawValue)
    }
  }
  


  @IBAction func voiceBAction(_ sender: Any) {
    lastButton = micBOutlet
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
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      print("running ...")
      NetStatus.shared.netStatusChangeHandler = {
        DispatchQueue.main.async { [unowned self] in
          let connected = NetStatus.shared.isConnected
          if !connected {
            self.alertNoNetwork()
          } else {
            print("ok connected ...")
          }
        }
      }
    }
    
    IAPService.shared.getProducts()
    IAPService.shared.ordered = self
    IAPService.shared.restorePurchases()
    
    micBOutlet.layer.cornerRadius = 32
    motionBOutlet.layer.cornerRadius = 32
    compassBOutlet.layer.cornerRadius = 32
    
    micBOutlet.clipsToBounds = true
    motionBOutlet.clipsToBounds = true
    compassBOutlet.clipsToBounds = true
    
    compassBOutlet.layer.borderWidth = 2
    compassBOutlet.layer.borderColor = UIColor.black.cgColor
    
    nextOutlet.layer.borderWidth = 1
    nextOutlet.layer.borderColor = UIColor.gray.cgColor
    nextOutlet.clipsToBounds = true
    nextOutlet.layer.cornerRadius = 8
    
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
    if (UserDefaults.standard.string(forKey: "RATE") != nil) {
      refreshRate = UserDefaults.standard.string(forKey: "RATE")?.doubleValue
    } else {
      refreshRate = 0.1
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
//          self.gearBOutlet.alpha = 0
          self.gearBOutlet.isHidden = false
          self.gearBOutlet.isEnabled = true
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
  }
  
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
      }
    }
        
    if port2G != nil && firstShow {
      gearBOutlet.isEnabled = false
      stackviewDots.isHidden = true
      infoText!.text = "The Sensors"
      UIView.animate(withDuration: 0.5) {
        self.infoText!.center = CGPoint(x:self.view.bounds.midX,y:self.view.bounds.minY + 80)
      }
      infoText!.font = UIFont.preferredFont(forTextStyle: .body)
      infoText!.adjustsFontForContentSizeCategory = true
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
        self.infoText!.text = "Report location"
        self.locationBOutlet.grow()
        self.locationBOutlet.isEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
          self.infoText!.text = "Turn on proximity alerts"
          self.proximityBOutlet.grow()
          self.proximityBOutlet.isEnabled = true
          DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.infoText!.text = "Speak text sent"
            self.speakerBOutlet.grow()
            self.speakerBOutlet.isEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
              self.infoText!.text = "Listen to voice"
              self.micBOutlet.grow()
              self.micBOutlet.isEnabled = true
              DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.infoText!.text = "Stream phone motion"
                self.motionBOutlet.grow()
                self.motionBOutlet.isEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                  self.infoText!.text = "Stream compass position"
                  self.compassBOutlet.grow()
                  self.compassBOutlet.isEnabled = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                    self.infoText!.text = ""
                    self.firstShow = false
                    
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
        self.page1.image = UIImage(named: "whiteDot")
        self.page2.image = UIImage(named: "whiteDot")
        self.page3.image = UIImage(named: "whiteDot")
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



