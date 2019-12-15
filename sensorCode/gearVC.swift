//
//  gearVC.swift
//  talkCode
//
//  Created by localadmin on 19.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit
import Foundation
import Network

class gearVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

var skip = false

  @IBOutlet weak var cameraIcon: UIButton!
  @IBOutlet weak var pictureIcon: UIButton!
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var legoImage: UIImageView!
  @IBAction func cameraButton(_ sender: UIButton) {
    getImage(fromSourceType: .camera)
  }
  @IBAction func uploadButton(_ sender: UIButton) {
    getImage(fromSourceType: .photoLibrary)
  }
  
  func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        globalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
  //      let imageData = UIImagtrueeJPEGRepresentation(image, 0.05)
        self.dismiss(animated: true) {
          self.performSegue(withIdentifier: "photo", sender: self)
        }
  }

  func wordUsed(word2D: String) {
    
    spokenOutput.text = word2D
  }
  
  @IBOutlet weak var spokenOutput: UILabel!
  var infoText: UILabel!
  var isVisible = false

  
  @objc func didShow(notification: NSNotification)
  {
      isVisible = true
  }

  @objc func didHide(notification: NSNotification)
  {
      isVisible = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    spokenOutput.text = ""
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(didShow),
        name: UIResponder.keyboardDidShowNotification,
        object: nil)

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(didHide),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
    
    portNumber.delegate = self
    ipAddress.delegate = self
//    primeController.said = self
    
    portNumber.isHidden = false
    ipAddress.isHidden = false
    
    let name = UserDefaults.standard.string(forKey: "IPA") ?? ""
    if name != "" {
      ipAddress.text = name
    }
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    
    self.view.addGestureRecognizer(tap)
    let backgroundImage = UIImageView(frame: self.view.bounds)
    backgroundImage.contentMode = .scaleAspectFit
    backgroundImage.image = UIImage(named: "lego.png")!
    backgroundImage.alpha = 0.5
    
//    self.view.backgroundColor = UIColor(patternImage: backgroundImage.image!)
    self.view.insertSubview(backgroundImage, at: 0)
    self.view.contentMode = .scaleAspectFit
    
    if port2G != nil {
      portNumber.text = String(port2G!)
    }
    if connect2G != nil {
      ipAddress.text = connect2G
    }
    
    infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 145))
    infoText.isUserInteractionEnabled = true
//    infoText.addGestureRecognizer(swipeUp)
    infoText.numberOfLines = 0
    infoText.textAlignment = .justified
    
    self.view.addSubview(infoText)
    
    portNumber.becomeFirstResponder()
    
    if !fastStart! {
    
    infoText.text = "Enter a port number to use between 1024 and 32760. Tap on the screen to dismiss the keyboard."
    infoText.backgroundColor = .white
    infoText.isUserInteractionEnabled = true
//    backButton.blink()
    let tapper = UITapGestureRecognizer(target: self, action: #selector(tapped))
    infoText.addGestureRecognizer(tapper)
    
    
      DispatchQueue.main.asyncAfter(deadline: .now() + 16, execute: {
//      self.backButton.noblink()
      if !self.skip {
        UIView.animate(withDuration: 1) {
          self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY - 256)
        }
      }
      })
    
    } else {
      UIView.animate(withDuration: 1) {
        self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY - 256)
      }
    }
    // Do any additional setup after loading the view.
  }
  
  
  
    @objc func dismissKeyboard() {
      if !isVisible {
        return
      }
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        self.portNumber.alpha = 0
//        self.ipAddress.alpha = 0
        self.skip = true
        view.endEditing(true)
        if ipAddress.text != "" && portNumber.text != "" {
          port2G = Int16(portNumber.text!)
          connect2G = ipAddress.text!
          UserDefaults.standard.set(connect2G, forKey: "IPA")
        }
        
      var paused = DispatchTimeInterval.seconds(12)
      if !fastStart! {
        let textFeed = "Wait, before you go. Load a wallpaper thru the icons below. Double tap to dismiss it and shake your iphone to bring it back."
        
        self.infoText.text = ""
        self.infoText.alpha = 1
        self.infoText.preferredMaxLayoutWidth = self.view.bounds.width - 40
        self.infoText.font = UIFont.preferredFont(forTextStyle: .body)
        self.infoText.adjustsFontForContentSizeCategory = true
        self.infoText.isHidden = false
        self.infoText.textAlignment = .left
        self.infoText.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
        self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.minY + 60)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
          let words = Array(textFeed)
          var i = 0
          let pause = 0.1
         
          let delay = pause * Double(textFeed.count)
          
          paused = DispatchTimeInterval.seconds(Int(delay + 4))
          Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            
            self.infoText.text = self.infoText.text! + String(words[i])
            if i == words.count - 1 {
              timer.invalidate()
              UIView.animate(withDuration: 4) {
                self.infoText.alpha = 0
              }
            
              self.cameraIcon.isEnabled = true
              self.pictureIcon.isEnabled = true
              self.backButton.isSelected = true
              self.cameraIcon.grow()
              self.pictureIcon.grow()
                      
            } else {
              i = i + 1
              
            }
          }
        })
      }
      print("paused",paused)
        
    }
    
  @objc func tapped() {
    UIView.animate(withDuration: 4) {
      self.infoText.alpha = 0
//      self.portNumber.alpha = 1
//      self.ipAddress.alpha = 1
    }
//    backButton.noblink()
  }
    
    @IBOutlet weak var portNumber: UITextField!
    @IBOutlet weak var ipAddress: UITextField!
   
    func redo(_ value: String) {
        let alertController = UIAlertController(title: "Unable to Connect", message: value, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
         
    }
      
    func textFieldDidEndEditing(_ textField: UITextField) {
       if textField == portNumber {
         if textField.text!.isEmpty {
           redo("You MUST enter a port number")
//           connectLabel.isEnabled = false
           return
         } else {
           if Int(textField.text!)! < 1025 && Int(textField.text!)! < Int16.max {
             redo("Port numbers MUST be greater than 1024 and less than 32767")
//             connectLabel.isEnabled = false
             return
           }
         }
       }
       if textField == ipAddress {
         if textField.text!.isEmpty {
           redo("You MUST enter an IP address")
//           connectLabel.isEnabled = false
           return
         } else {
           if !isValidIP(s: textField.text!) {
             redo("Sorry, that ISN'T a valid IP address")
//             connectLabel.isEnabled = false
             return
           }
         }
       }
       
       if !ipAddress.text!.isEmpty && !portNumber.text!.isEmpty {
          let ipa = ipAddress!.text!
          let ipp = portNumber!.text!
          let hostUDPx = NWEndpoint.Host.init(ipa)
          let portUDPx = NWEndpoint.Port.init(ipp)
          communications?.connectToUDP(hostUDP: hostUDPx, portUDP: portUDPx!)
//          communications?.listenUDP()
          
//         connectLabel.isEnabled = true
       }
     }
     
     func isValidIP(s: String) -> Bool {
       let parts = s.components(separatedBy: ".")
       let nums = parts.compactMap { Int($0) }
       return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
     }
      

  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.performSegue(withIdentifier: "photo", sender: self)
    }
  }
     
}


