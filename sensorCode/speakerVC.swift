//
//  speakerVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import Speech

class speakerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, lostLink {

  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  

  @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
  @IBOutlet weak var backButton: UIButton!
  
  
    var pickerData: [String] = [String]()
    var infoText: UILabel!
    var tag:Int?
    var status:running?
    
  @IBOutlet weak var speakerSwitchOutput: UISwitch!
  @IBAction func speakerSwitch(_ sender: UISwitch) {
    if sender.isOn {
      communications?.listenUDP()
      speakerToggle = true
    } else {
      communications?.stopListening()
      speakerToggle = false
    }
  }
  // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        language = pickerData[row]
    }
    
    @IBAction func rateAction(_ sender: UISlider) {
      rate = Float(sender.value)
      
    }
    
    @IBAction func volumeAction(_ sender: UISlider) {
      volume = Float(sender.value)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
      speakerSwitchOutput.grow()
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if port2G == nil{
          speakerSwitchOutput.isEnabled = false
        }
        
        let voices = AVSpeechSynthesisVoice.speechVoices()
        var langs = Set<String>()
        
        for voice in voices {
          if !langs.contains(voice.language) {
            pickerData.append(voice.language)
            
          }
          langs.insert(voice.language)
        }
        
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let findex = self.pickerData.firstIndex(of: language)
        if findex != nil {
          self.picker.selectRow(findex!, inComponent: 0, animated: true)
        }

        
        
        infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
            infoText.isUserInteractionEnabled = true
        //    infoText.addGestureRecognizer(swipeUp)
            infoText.numberOfLines = 0
            infoText.textAlignment = .justified
            self.view.addSubview(infoText)
            
            infoText.text = "Lets you ask the iPhone to read out text. You need to send it via UDP to the iPhone IP address, on the port you already defined."
            infoText.font = UIFont.preferredFont(forTextStyle: .body)
            infoText.adjustsFontForContentSizeCategory = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
              UIView.animate(withDuration: 1) {
                self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY - 256)
              }
              DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.infoText.isHidden = true
                self.backButton.blinkText()
              })
            })
    }
    

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       lastSwitch = speakerSwitchOutput
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

}


