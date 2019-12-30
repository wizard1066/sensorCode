//
//  toolsVC.swift
//  sensorCode
//
//  Created by localadmin on 29.12.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit

class toolsVC: UIViewController {

  enum Vs: String {
    case pulse = "pulse"
    case precision = "precision"
    case refresh = "refresh"
    case auto = "auto"
    case fast = "fast"
    case variable = "variable"
  }

  @IBOutlet weak var pulseLabel: UILabel!
  @IBOutlet weak var fixedLabel: UILabel!
  @IBOutlet weak var refreshLabel: UILabel!
  @IBOutlet weak var precisionLabel: UILabel!
  @IBOutlet weak var autoLabel: UILabel!
  @IBOutlet weak var fastLabel: UILabel!
  
  @IBOutlet weak var autoTag: UILabel!
  @IBOutlet weak var pulseTag: UILabel!
  @IBOutlet weak var fastTag: UILabel!
  @IBOutlet weak var variableTag: UILabel!
  @IBOutlet weak var moreText: UILabel!
  
  @IBOutlet weak var infoText: UILabel!
  
  @IBOutlet weak var refreshValue: UILabel!
  @IBOutlet weak var precisionValue: UILabel!
  
  func format(tag: UILabel, text:String) {
    tag.text = text
    tag.textColor = .white
    tag.font = UIFont.preferredFont(forTextStyle: .title2)
    if text == "TRUE" {
      tag.backgroundColor = .green
      tag.textColor = .darkGray
    } else {
      tag.backgroundColor = .red
    }
  }
  
  private var paused = DispatchTimeInterval.seconds(12)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if pulse! {
      format(tag: pulseTag, text: "TRUE")
    } else {
      format(tag: pulseTag, text: "FALSE")
    }
    if variable! {
      format(tag: variableTag, text: "TRUE")
    } else {
      format(tag: variableTag, text: "FALSE")
    }
    if autoClose! {
      format(tag: autoTag, text: "TRUE")
    } else {
      format(tag: autoTag, text: "FALSE")
    }
    if fastStart! {
      format(tag: fastTag, text: "TRUE")
    } else {
      format(tag: fastTag, text: "FALSE")
    }
    refreshValue.font = UIFont.preferredFont(forTextStyle: .title2)
    refreshValue.text = "\(refreshRate!)"
    precisionValue.font = UIFont.preferredFont(forTextStyle: .title2)
    precisionValue.text = precision
    
    let pulseTap = customTap(target: self, action: #selector(toolsVC.showText(sender:)))
    pulseTap.sender = "Pulse is the business"
    pulseLabel.addGestureRecognizer(pulseTap)
    pulseLabel.isUserInteractionEnabled = true
    
    let textFeed = "Use the app settings to change the variables shown here. You will in some cases need to restart the app for the changes to take effect."
    
    self.moreText.text = ""
    self.moreText.alpha = 1
    self.moreText.preferredMaxLayoutWidth = self.view.bounds.width - 40
    self.moreText.font = UIFont.preferredFont(forTextStyle: .body)
    self.moreText.adjustsFontForContentSizeCategory = true
    self.moreText.isHidden = false
    self.moreText.textAlignment = .left
    self.moreText.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
    self.moreText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 112)
    
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
          UIView.animate(withDuration: 12) {
            self.moreText.alpha = 0
          }
          
        } else {
          i = i + 1
          
        }
      }
    })
  }
  
  @objc func showText(sender: Any) {
    let tag = sender as? customTap
    let textFeed = tag!.sender as? String
    self.infoText.text = ""
    self.infoText.alpha = 1
    self.infoText.preferredMaxLayoutWidth = self.view.bounds.width - 40
    self.infoText.font = UIFont.preferredFont(forTextStyle: .body)
    self.infoText.adjustsFontForContentSizeCategory = true
    self.infoText.isHidden = false
    self.infoText.textAlignment = .left
    self.infoText.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
    self.infoText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 112)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      let words = Array(textFeed!)
      var i = 0
      let pause = 0.1
      
      let delay = pause * Double(textFeed!.count)
      
      self.paused = DispatchTimeInterval.seconds(Int(delay + 4))
      Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
        
        self.infoText.text = self.infoText.text! + String(words[i])
        if i == words.count - 1 {
          timer.invalidate()
          UIView.animate(withDuration: 12) {
            self.infoText.alpha = 0
          }
          
        } else {
          i = i + 1
          
        }
      }
    })
  }
  
  
}



