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
  func incoming(ipaddr: String) {
    // ignore
  }
  
  
  func sendAlert(error: String) {
    redo(error)
  }
   
  var skip = false
  var tag:Int?
  var feeder:setty?
  var status:running?
  
  @IBOutlet weak var settingsSV: UIStackView!
  @IBOutlet weak var textSV: UIStackView!
  
  @IBOutlet weak var pulseView: UIView!
  @IBOutlet weak var refreshView: UIView!
  @IBOutlet weak var precisionView: UIView!
  @IBOutlet weak var autoView: UIView!
  @IBOutlet weak var fastView: UIView!
  @IBOutlet weak var variableView: UIView!
  
  @IBOutlet weak var pulseText: UILabel!
  @IBOutlet weak var refreshText: UILabel!
  @IBOutlet weak var precisionText: UILabel!
  @IBOutlet weak var autoText: UILabel!
  @IBOutlet weak var fastText: UILabel!
  @IBOutlet weak var variableText: UILabel!
  
  @IBOutlet weak var fastSub: UILabel!
  @IBOutlet weak var autoSub: UILabel!
  @IBOutlet weak var precisionSub: UILabel!
  @IBOutlet weak var refreshSub: UILabel!
  @IBOutlet weak var pulseSub: UILabel!
  @IBOutlet weak var variableSub: UILabel!
  
  @IBOutlet weak var pulseLabel: UILabel!
  @IBOutlet weak var refreshLabel: UILabel!
  @IBOutlet weak var precisionLabel: UILabel!
  @IBOutlet weak var autoLabel: UILabel!
  @IBOutlet weak var fastLabel: UILabel!
  @IBOutlet weak var variableLabel: UILabel!
  
  
  
  @IBOutlet weak var cameraIcon: UIButton!
  @IBOutlet weak var pictureIcon: UIButton!
  @IBOutlet weak var backButton: UIButton!
  @IBAction func backButtonAction(_ sender: UIButton) {
    if connectBSwitch.isOn {
      performSegue(withIdentifier: "sensorCodeMM", sender: nil)
    } else {
      let alert = UIAlertController(title: "TURN On the switch to make the connection live", message: "Confirm", preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
          self.performSegue(withIdentifier: "sensorCodeMM", sender: nil)
        })
        }))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
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
    if lastSwitch!.isOn {
      status?.turnOn(views2G: self.tag!)
    } else {
      status?.turnOff(views2G: self.tag!)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    spokenOutput.text = ""

//    textSV.isHidden = false
    settingsSV.isHidden = true
    
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
    backgroundImage.alpha = 0.1
    
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
    
    infoText.text = "Start by entering a port number to use between 1024 and 32760, tapping on the screen to dismiss the keyboard."
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
          self.settingsSV.spacing = 6
          
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
    
    let pulseTap = customTap(target: self, action: #selector(gearVC.actionB(sender:)))
    pulseTap.sender = Vs.pulse.rawValue
    pulseLabel.addGestureRecognizer(pulseTap)
    let pulseVTap = customTap(target: self, action: #selector(gearVC.actionV(sender:)))
    pulseVTap.sender = Vs.pulse.rawValue
    pulseText.addGestureRecognizer(pulseVTap)
    pulseSub.addGestureRecognizer(pulseVTap)
    pulseView.addGestureRecognizer(pulseVTap)
    
    let refreshTap = customTap(target: self, action: #selector(gearVC.actionB(sender:)))
    refreshTap.sender = Vs.refresh.rawValue
    refreshLabel.addGestureRecognizer(refreshTap)
    let refreshVTap = customTap(target: self, action: #selector(gearVC.actionV(sender:)))
    refreshVTap.sender = Vs.refresh.rawValue
    refreshText.addGestureRecognizer(refreshVTap)
    refreshSub.addGestureRecognizer(refreshVTap)
    
    let autoTap = customTap(target: self, action: #selector(gearVC.actionB(sender:)))
    autoTap.sender = Vs.auto.rawValue
    autoLabel.addGestureRecognizer(autoTap)
    let autoVTap = customTap(target: self, action: #selector(gearVC.actionV(sender:)))
    autoVTap.sender = Vs.auto.rawValue
    autoText.addGestureRecognizer(autoVTap)
    autoSub.addGestureRecognizer(autoVTap)
    
    let fastTap = customTap(target: self, action: #selector(gearVC.actionB(sender:)))
    fastTap.sender = Vs.fast.rawValue
    fastLabel.addGestureRecognizer(fastTap)
    let fastVTap = customTap(target: self, action: #selector(gearVC.actionV(sender:)))
    fastVTap.sender = Vs.fast.rawValue
    fastText.addGestureRecognizer(fastVTap)
    fastSub.addGestureRecognizer(fastVTap)
    
    let variableTap = customTap(target: self, action: #selector(gearVC.actionB(sender:)))
    variableTap.sender = Vs.variable.rawValue
    variableLabel.addGestureRecognizer(variableTap)
    let variableVTap = customTap(target: self, action: #selector(gearVC.actionV(sender:)))
    variableVTap.sender = Vs.variable.rawValue
    variableText.addGestureRecognizer(variableVTap)
    variableSub.addGestureRecognizer(variableVTap)
    
    
    let precisionTap = customTap(target: self, action: #selector(gearVC.actionB(sender:)))
    precisionTap.sender = Vs.precision.rawValue
    precisionLabel.addGestureRecognizer(precisionTap)
    
    let precisionVTap = customTap(target: self, action: #selector(gearVC.actionV(sender:)))
    precisionVTap.sender = Vs.precision.rawValue
    precisionText.addGestureRecognizer(precisionVTap)
    precisionSub.addGestureRecognizer(precisionVTap)
    
    
    
  }
  
  enum Vs: String {
    case pulse = "pulse"
    case precision = "precision"
    case refresh = "refresh"
    case auto = "auto"
    case fast = "fast"
    case variable = "variable"
  }
  
  @objc func actionB(sender: Any) {
    let tag = sender as? customTap
    switch tag?.sender {
      case Vs.refresh.rawValue:
        hideLabels(fast: refreshLabel)
        refreshView.isHidden = false
      case Vs.pulse.rawValue:
        hideLabels(fast: pulseLabel)
        pulseView.isHidden = false
      case Vs.auto.rawValue:
        hideLabels(fast: autoLabel)
        autoView.isHidden = false
      case Vs.fast.rawValue:
        hideLabels(fast: fastLabel)
        fastView.isHidden = false
      case Vs.precision.rawValue:
        hideLabels(fast: precisionLabel)
        precisionView.isHidden = false
      case Vs.variable.rawValue:
        hideLabels(fast: variableLabel)
        variableView.isHidden = false
      default:
        break
      }
  }
  
  func hideLabels(fast:UILabel) {
    fast.isHidden = true
    fast.alpha = 0
//    UIView.animate(
//        withDuration: 2.0,
//        delay: 0.0,
//        options: [.curveEaseOut],
//        animations: {
            self.refreshLabel.isHidden = true
            self.precisionLabel.isHidden = true
            self.autoLabel.isHidden = true
            self.fastLabel.isHidden = true
            self.pulseLabel.isHidden = true
            self.variableLabel.isHidden = true
            self.refreshLabel.alpha = 0
            self.precisionLabel.alpha = 0
            self.autoLabel.alpha = 0
            self.fastLabel.alpha = 0
            self.pulseLabel.alpha = 0
            self.variableLabel.alpha = 0
//    })
    
  }
  
  @objc func actionV(sender: Any) {
    let tag = sender as? customTap
    switch tag?.sender {
    case Vs.refresh.rawValue:
      refreshView.isHidden = true
      showLabels()
    case Vs.pulse.rawValue:
      pulseView.isHidden = true
      showLabels()
    case Vs.auto.rawValue:
      autoView.isHidden = true
      showLabels()
    case Vs.fast.rawValue:
      fastView.isHidden = true
      showLabels()
    case Vs.precision.rawValue:
      precisionView.isHidden = true
      showLabels()
    case Vs.variable.rawValue:
      variableView.isHidden = true
      showLabels()
    default:
      break
    }
  }
  
  func showLabels() {
    UIView.animate(
        withDuration: 1.0,
        delay: 0.0,
        options: [.curveEaseOut],
        animations: {
            self.refreshLabel.isHidden = false
            self.precisionLabel.isHidden = false
            self.autoLabel.isHidden = false
            self.fastLabel.isHidden = false
            self.pulseLabel.isHidden = false
            self.variableLabel.isHidden = false
            self.refreshLabel.alpha = 1
            self.precisionLabel.alpha = 1
            self.autoLabel.alpha = 1
            self.fastLabel.alpha = 1
            self.pulseLabel.alpha = 1
            self.variableLabel.alpha = 1
    })
  
    
  }
  
  func enableLabels() {
    self.pulseLabel.isUserInteractionEnabled = true
    self.precisionLabel.isUserInteractionEnabled = true
    self.autoLabel.isUserInteractionEnabled = true
    self.refreshLabel.isUserInteractionEnabled = true
    self.fastLabel.isUserInteractionEnabled = true
    self.variableLabel.isUserInteractionEnabled = true
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
          showLabels()
//          textSV.isHidden = true
        }
      UIView.animate(withDuration: 4) {
        self.settingsSV.spacing = 10
      }
      enableLabels()
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
        self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 80)
        
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
      self.settingsSV.spacing = 10
      
    }
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

class customTap: UITapGestureRecognizer {
  var sender: String?
  var label: UILabel?
}

class customLongPress: UILongPressGestureRecognizer {
  var sender: String?
  var label: UILabel?
}
