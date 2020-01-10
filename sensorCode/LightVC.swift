//
//  LightVC.swift
//  sensorCode
//
//  Created by localadmin on 02.01.20.
//  Copyright © 2020 Mark Lucking. All rights reserved.
//

import UIKit

class LightVC: UIViewController, UITextFieldDelegate, lostLink {

  func sendAlert(error: String) {
    let alertController = UIAlertController(title: "Unable to Connect", message: error, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func incoming(ipaddr: String) {
    // ignore
  }
  

  var status:running?
  var tag: Int?
  var infoText: UILabel!

  @IBOutlet weak var turnOnText: UITextField!
  @IBOutlet weak var turnOffText: UITextField!
  @IBOutlet weak var triggerLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var lightSwitch: UISwitch!
  @IBAction func lightSwitchAction(_ sender: UISwitch) {
    if sender.isOn {
      if turnOnText.text!.count > 0 {
        if turnOffText.text!.count > 0 {
          lightOn = turnOnText.text
          lightOff = turnOffText.text
        }
      }
    } else {
      lightOn = nil
      lightOff = nil
    }
  }

  @IBAction func backbuttonAction(_ sender: UIButton) {
        if lightSwitch.isOn {
      performSegue(withIdentifier: "exitLight", sender: nil)
    } else {
      let alert = UIAlertController(title: "TURN On the switch to make the light link work", message: "Confirm", preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
          self.performSegue(withIdentifier: "exitLight", sender: nil)
        })
        }))
      alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
        if self.turnOnText.text!.count > 0 {
          if self.turnOffText.text!.count > 0 {
            lightOn = self.turnOnText.text
            lightOff = self.turnOffText.text
            self.lightSwitch.setOn(true, animated: true)
          }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
          self.performSegue(withIdentifier: "exitLight", sender: nil)
        })
      }))
      self.present(alert, animated: true)
    }
  }
  
  private var background = false
  
  override func viewDidAppear(_ animated: Bool) {
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
        self.lightSwitch.grow()
      }
    }
  }
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
           
         self.view.addGestureRecognizer(tap)
         let backgroundImage = UIImageView(frame: self.view.bounds)
         backgroundImage.contentMode = .scaleAspectFit
         backgroundImage.image = UIImage(named: "lego.png")!
         backgroundImage.alpha = 0.1
         
         turnOffText.delegate  = self
         turnOnText.delegate = self
         
         infoText = UILabel(frame: CGRect(x: self.view.bounds.minX + 20, y: 0, width: self.view.bounds.width - 40, height: 128))
             infoText.isUserInteractionEnabled = true
         //    infoText.addGestureRecognizer(swipeUp)
             infoText.numberOfLines = 0
             infoText.textAlignment = .justified
             self.view.addSubview(infoText)
             
             infoText.text = "Looks to either speech or listening hardware to the defined names to turn the iphone light on or off"
//             infoText.font = UIFont.preferredFont(forTextStyle: .body)
             infoText.font = UIFont(name: "Futura-CondensedMedium", size: 17)
             infoText.adjustsFontForContentSizeCategory = true
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
    
@objc func dismissKeyboard() {
    view.endEditing(true)
    if turnOnText.text == turnOffText.text {
      redo("You MUST enter two DIFFERENT words")
      lightSwitch.isEnabled = false
    }
  }


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    lastSwitch = lightSwitch
    if lastSwitch!.isOn {
      status?.turnOn(views2G: self.tag!)
    } else {
      status?.turnOff(views2G: self.tag!)
    }
  }
  
  
  
  func redo(_ value: String) {
      let alertController = UIAlertController(title: "STOP", message: value, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
       
  }
  
   func textFieldDidEndEditing(_ textField: UITextField) {
    
    if (textField.text?.isEmptyOrWhitespace())! {
            
             redo("You MUST enter a single word ONLY")
             lightSwitch.isEnabled = false
             return
         }
       lightSwitch.isEnabled = true
    }
}



extension String {
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        if (self.contains(" ")){
          return true
      }
      return false
    }
}
