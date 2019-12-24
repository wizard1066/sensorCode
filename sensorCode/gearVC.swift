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

protocol setty {
  func returnPostNHost(port: String, host: String)
}

class gearVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, lostLink {
  func sendAlert(error: String) {
    redo(error)
  }
   
  var skip = false
  var tag:Int?
  var feeder:setty?

  @IBOutlet weak var cameraIcon: UIButton!
  @IBOutlet weak var pictureIcon: UIButton!
  @IBOutlet weak var backButton: UIButton!
  @IBAction func backButtonAction(_ sender: UIButton) {
    if connectBSwitch.isOn {
      performSegue(withIdentifier: "sensorCodeMM", sender: nil)
    } else {
      let alert = UIAlertController(title: "TURN On the switch to make the connection live", message: "Confirm", preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//        if let url = URL(string:UIApplication.openSettingsURLString) {
//           if UIApplication.shared.canOpenURL(url) {
//             UIApplication.shared.open(url, options: [:], completionHandler: nil)
//           }
//        }
        self.turnOn()
        self.connectBSwitch.setOn(true, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
        })
      }))
      self.present(alert, animated: true)
    }
  }
  
  @IBAction func cameraButton(_ sender: UIButton) {
    getImage(fromSourceType: .camera)
  }
  @IBAction func uploadButton(_ sender: UIButton) {
    getImage(fromSourceType: .photoLibrary)
  }
  
  @IBOutlet weak var connectBSwitch: UISwitch!
  @IBAction func connectSwitch(_ sender: UISwitch) {
    if sender.isOn {
      turnOn()
    } else {
      turnOff()
    }
  }
  
  func turnOn() {
    if !ipAddress.text!.isEmpty && !portNumber.text!.isEmpty {
       let ipa = ipAddress!.text!
       let ipp = portNumber!.text!
       let hostUDPx = NWEndpoint.Host.init(ipa)
       let portUDPx = NWEndpoint.Port.init(ipp)
       communications?.connectToUDP(hostUDP: hostUDPx, portUDP: portUDPx!)
    }
  }
  
  func turnOff() {
    communications?.disconnectUDP()
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    lastSwitch = connectBSwitch
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    spokenOutput.text = ""
    
    if communications!.connectedStatus {
      connectBSwitch.setOn(true, animated: true)
    }
    connectBSwitch.grow()
    communications?.missing = self
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
    let port = UserDefaults.standard.string(forKey: "IPP") ?? ""
    if port != "" {
      portNumber.text = port
    }
    if port2G != nil {
      portNumber.text = port2G?.description
    }
    if connect2G != nil {
      ipAddress.text = connect2G
    }
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    
    self.view.addGestureRecognizer(tap)
    let backgroundImage = UIImageView(frame: self.view.bounds)
    backgroundImage.contentMode = .scaleAspectFit
    backgroundImage.image = UIImage(named: "lego.png")!
    backgroundImage.alpha = 0.2
    
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
//
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
        self.backButton.blinkText()
      }
    }
    // Do any additional setup after loading the view.
  }
  
  var blinkCount = 0
  
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
          UserDefaults.standard.set(port2G, forKey: "IPP")
          portNumber.placeholder = portNumber.text!
          ipAddress.placeholder = ipAddress.text!
          feeder?.returnPostNHost(port: portNumber.text!, host: ipAddress.text!)
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

              self.backButton.blinkText()
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

extension UIButton {
  func blinkBackground() {
    var blinkCount = 0
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
      if blinkCount < 8 {
        blinkCount = blinkCount + 1
        if self.isSelected {
          self.isSelected = false
        } else {
          self.isSelected = true
        }
      } else {
        self.isSelected = false
        timer.invalidate()
      }
    }
  }
  
  func blinkText() {
    var blinkCount = 0
    let colorRightNow = self.titleColor(for: .normal)
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
      if blinkCount < 8 {
        blinkCount = blinkCount + 1
        
        if self.titleColor(for: .normal) == colorRightNow {
          self.setTitleColor(UIColor.white, for: .normal)
        } else {
          self.setTitleColor(colorRightNow, for: .normal)
        }
      } else {
        self.setTitleColor(colorRightNow, for: .normal)
        timer.invalidate()
      }
    }
  }
  
  func rainbowText() {
    var colors:[UIColor] = []
    let increment:CGFloat = 0.02
    for hue:CGFloat in stride(from: 0.0, to: 4.0, by: increment) {
      let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
      colors.append(color)
    }
    var colorIndex = 0
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
      if colorIndex < colors.count {
          self.setTitleColor(colors[colorIndex], for: .normal)
          colorIndex = colorIndex + 1
      } else {
        self.setTitleColor(colors[0], for: .normal)
        timer.invalidate()
      }
    }
  }
  
  func showWord() {
    let sizer = self.frame.size
    let hider = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: sizer))
    hider.backgroundColor = UIColor.white
    
    let sub = self.titleLabel
    sub?.insertSubview(hider, at: 1)
    self.insertSubview(hider, at: 1)
    
    UIView.animate(withDuration: 4, animations: {
      hider.center = CGPoint(x: 128, y: 0)
    }) { (_) in
      hider.removeFromSuperview()
    }
  }
  
  func splitWord() {
    
  
    let sizer = self.frame.size
    let hider0 = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:sizer))
    
    let sub = self.titleLabel
    let subs = sub?.frame.size
    let halfwidth = subs!.width / 2
    let halfheight = subs!.height / 2
    
    let hider1 = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: halfwidth, height: subs!.height)))
    let hider2 = UIView(frame: CGRect(origin: CGPoint(x: halfwidth, y: 0), size: CGSize(width: halfwidth, height: subs!.height)))
    hider1.backgroundColor = UIColor.white
    hider2.backgroundColor = UIColor.white
    hider0.backgroundColor = UIColor.clear
    
//    let layer = CAShapeLayer()
//    layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 32, height: subs!.height), cornerRadius: 0).cgPath
//    layer.fillColor = UIColor.black.cgColor
//    layer.fillMode = .forwards
//    layer.opacity = 0.2
    
//   self.layer.addSublayer(layer)
    
    
    sub?.insertSubview(hider1, at: 1)
    sub?.insertSubview(hider2, at: 2)
    self.insertSubview(hider0, at: 1)
    
    UIView.animate(withDuration: 4, animations: {
      hider1.center = CGPoint(x: -halfwidth*2, y: halfheight)
      hider2.center = CGPoint(x: halfwidth*3 + halfwidth, y: halfheight)
    }) { (_) in
      hider0.removeFromSuperview()
    }

  }
}


