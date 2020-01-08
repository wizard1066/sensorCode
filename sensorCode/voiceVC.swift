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
  
  
  @IBOutlet var switchListeningOutput: UISwitch!
  
  @IBAction func switchListening(_ sender: UISwitch) {
    if sender.isOn {
      askPermission()
    } else {
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
//              let w2S = voice(word: word)
//              communications?.sendUDP(w2S)
              superRec2.word = word
              if word == lightOn {
                self.toggleTorch(on: true)
              }
              if word == lightOff {
                self.toggleTorch(on: false)
              }
              communications?.pulseUDP2(superRec2)
            }
          } else {
            if variable! {
              superRec2.word = nil
            } else {
              superRec2.word = ""
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
