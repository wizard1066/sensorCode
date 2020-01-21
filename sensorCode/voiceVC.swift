//
//  listenVC.swift
//  talkCode
//
//  Created by localadmin on 29.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import Speech
import AVFoundation



class voiceVC: UIViewController, lostLink {
  func outgoing(ipaddr: String) {
    // ignore
  }
  
  func incoming(ipaddr: String) {
    // ignore
  }
  
  
  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  
  
  
  
  @IBOutlet var spokenOutlet: UILabel!
  //  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var voiceBPass: UISwitch!
  @IBOutlet weak var auxLabel: UILabel!
  @IBOutlet weak var auxText: UILabel!
  @IBOutlet weak var mainLabel: UILabel!
  @IBOutlet weak var mainText: UILabel!
  
  
  let audioEngine = AVAudioEngine()
  let speechReconizer = SFSpeechRecognizer()
  var request:SFSpeechAudioBufferRecognitionRequest?
  var recognitionTask: SFSpeechRecognitionTask?
  var began = false
  var previousMessage: String!
  var said:spoken?
  var infoText: UILabel!
  var tag: Int?
  var status:running?
  var primeController: voiceVC?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if autoClose! {
      switchListeningOutput.setOn(false, animated: false)
      stopRecording()
    }
    lastSwitch = switchListeningOutput
    if lastSwitch!.isOn {
      status?.turnOn(views2G: self.tag!)
    } else {
      status?.turnOff(views2G: self.tag!)
    }
  }
  
  @IBAction func backButtonAction(_ sender: UIButton) {
    if switchListeningOutput.isOn {
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
          self.switchListeningOutput.setOn(true, animated: true)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
          })
        }))
        self.present(alert, animated: true)
      }
      
    }
  }
  
  func turnOn() {
    askPermission()
  }
  
  
  @IBOutlet var switchListeningOutput: UISwitch!
  
  @IBAction func switchListening(_ sender: UISwitch) {
    if sender.isOn {
      turnOn()
    } else {
//      superRec = superRec2
      stopRecording()
    }
  }
  
  
  
  private var background = false
  
  override func viewDidAppear(_ animated: Bool) {
    spokenOutlet.text = ""
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
        self.switchListeningOutput.grow()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
      if pulse == false {
        voiceBPass.isHidden = true
        auxLabel.isHidden = true
        auxText.isHidden = true
      }
      if switchListeningOutput.isOn == false {
        voiceBPass.isEnabled = false
      }
  }
  
  func setupTaps() {
        let passTap = customTap(target: self, action: #selector(voiceVC.showTap(sender:)))
    //    let passTap = customTap(target: self, action: #selector(azimuthVC.debug(sender:)))
        passTap.sender = "TURN ON in PULSE mode to send data outside of the polling window."
        passTap.label = auxText
        auxLabel.addGestureRecognizer(passTap)
        auxLabel.isUserInteractionEnabled = true
        auxLabel.numberOfLines = 0
        
        let mainTap = customTap(target: self, action: #selector(voiceVC.showTap(sender:)))
        mainTap.sender = "TURN ON the Main Switch to start the sensor reporting."
        mainTap.label = mainText
        mainLabel.addGestureRecognizer(mainTap)
        mainLabel.isUserInteractionEnabled = true
        mainLabel.numberOfLines = 0
  }
  
  @objc func pulseChanged(sender:Notification) {
     
     if let state = sender.userInfo?["pulseBool"] as? Bool {
       
       voiceBPass.isHidden = state
       voiceBPass.isEnabled = !state
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
    voiceBPass.addGestureRecognizer(passTap)
    voiceBPass.isUserInteractionEnabled = true
    
    primeController = self
    
    infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
    infoText.isUserInteractionEnabled = true
    //    infoText.addGestureRecognizer(swipeUp)
    infoText.numberOfLines = 0
    infoText.textAlignment = .justified
    self.view.addSubview(infoText)
    //         infoText.font = UIFont.preferredFont(forTextStyle: .body)
    infoText.font = UIFont(name: "Futura-CondensedMedium", size: 17)
    infoText.adjustsFontForContentSizeCategory = true
    infoText.text = "Listens with the iPhone mic. And sends to the port configured the words it picks up."
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
      UIView.animate(withDuration: 1) {
        self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY - 256)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
        self.infoText.isHidden = true
        self.backButton.blinkText()
      })
    })
    
    // Do any additional setup after loading the view.
  }
  
  public func askPermission() {
    SFSpeechRecognizer.requestAuthorization { (authStatus) in
      switch authStatus {
      case .authorized:
        // good
        do {
          try self.startRecording()
        } catch let error {
          print("error",error)
        }
        break
      case .denied:
        // wont work
        break
      case .restricted:
        // not good
        break
      case .notDetermined:
        // lost in space
        break
      @unknown default:
        fatalError()
      }
    }
  }
  
  func beginRecording() {
    if began {
      return
    }
    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)
    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, error) in
      self.request?.append(buffer)
    }
    began = true
  }
  
  var toggle = true
  
  func startRecording() throws {
    // Setup Audio
    request = SFSpeechAudioBufferRecognitionRequest()
    beginRecording()
    
    audioEngine.prepare()
    
    try audioEngine.start()
    recognitionTask = speechReconizer?.recognitionTask(with: request!, resultHandler: { result,error in
      if let transcription = result?.bestTranscription {
        let soundByte = transcription.segments.last
        if soundByte != nil {
          let word = String(soundByte!.substring)
          if self.previousMessage != word {
            self.spokenOutlet.text = word
            self.previousMessage = word
            globalWord = word
            self.said?.wordUsed(word2D: word)
            if port2G != nil && connect2G != "" {
              superRec2?.word = word
              if word == lightOn {
                self.toggleTorch(on: true)
              }
              if word == lightOff {
                self.toggleTorch(on: false)
              }
              if pulse != nil {
                // send only is pulse if off or azimuthPass is on
                if pulse! == false {
                  communications?.pulseUDP2(superRec2!)
                }
                if pulse! == true && self.voiceBPass.isOn {
                  communications?.pulseUDP2(superRec2!)
                }
              }
            }
          } else {
            if variable! {
              superRec2?.word = nil
            } else {
              superRec2?.word = ""
            }
          }
          
        }
        
        if result!.isFinal {
          if self.switchListeningOutput.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
              self.start()
            })
          }
        }
        
      }})
    //    request.endAudio()
  }
  
  func stopRecording() {
    audioEngine.stop()
    request?.endAudio()
    recognitionTask?.finish()
  }
  
  func cancelRecording() {
    audioEngine.stop()
    recognitionTask?.cancel()
  }
  
  func start() {
    do {
      try self.startRecording()
    } catch let error {
      print("error",error)
    }
  }
  
  func stop() {
    self.stopRecording()
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
  
  func toggleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
    guard device.hasTorch else { print("Torch isn't available"); return }
    
    do {
      try device.lockForConfiguration()
      device.torchMode = on ? .on : .off
      // Optional thing you may want when the torch it's on, is to manipulate the level of the torch
      //          if on { try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel) }
      if on { try device.setTorchModeOn(level: 0.1) }
      //          do {
      //            try device.setTorchModeOn(level: 0.5)
      //          } catch {
      //              print(error)
      //          }
      device.unlockForConfiguration()
    } catch {
      print("Torch can't be used")
    }
  }
  
  
}
