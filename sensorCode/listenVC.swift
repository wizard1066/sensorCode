//
//  listenVC.swift
//  talkCode
//
//  Created by localadmin on 29.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import Speech

class listenVC: UIViewController {

  
  @IBOutlet var spokenOutlet: UILabel!
  
 
  let audioEngine = AVAudioEngine()
  let speechReconizer = SFSpeechRecognizer()
  var request:SFSpeechAudioBufferRecognitionRequest?
  var recognitionTask: SFSpeechRecognitionTask?
  var began = false
  var previousMessage: String!
  var said:spoken?
  var infoText: UILabel!
  
  @IBOutlet var switchListeningOutput: UISwitch!
  @IBAction func switchListening(_ sender: UISwitch) {
    if sender.isOn {
      askPermission()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if autoClose! {
      switchListeningOutput.isOn = false
      stop()
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
         infoText.font = UIFont.preferredFont(forTextStyle: .body)
         infoText.adjustsFontForContentSizeCategory = true
         infoText.text = "Listens with the iPhone mic. And sends to the port configured the words it picks up."
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
           UIView.animate(withDuration: 1) {
             self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY - 256)
           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
             self.infoText.isHidden = true
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
              communications?.sendUDP(word)
            }
          }
        }
        
        if result!.isFinal {
          //              print("stop recording!")
          
//          self.start()
          
          self.switchListeningOutput.isOn = false
          DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//          self.stopRecording()
            self.start()
            self.switchListeningOutput.isOn = true
            
//
          })
        }
        
      }})
    //    request.endAudio()
  }
  
  func stopRecording() {
    audioEngine.stop()
    request!.endAudio()
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


}
