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

  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var pulseLabel: UILabel!

  @IBOutlet weak var variableLabel: UILabel!
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
//    tag.font = UIFont.preferredFont(forTextStyle: .title2)
    tag.font = UIFont(name: "Futura-CondensedMedium", size: 17)
    if text == "TRUE" {
      tag.backgroundColor = .green
      tag.textColor = .darkGray
    } else {
      tag.backgroundColor = .red
    }
  }
  
  private var paused = DispatchTimeInterval.seconds(12)
  private var delay = DispatchTimeInterval.seconds(6)
  
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
//    refreshValue.font = UIFont.preferredFont(forTextStyle: .title2)
    refreshValue.font = UIFont(name: "Futura-CondensedMedium", size: 17)
    refreshValue.text = "\(refreshRate!)"
    
//    precisionValue.font = UIFont.preferredFont(forTextStyle: .title2)
    precisionValue.font = UIFont(name: "Futura-CondensedMedium", size: 17)
    precisionValue.text = precision
    
    let remTab = customLongPress(target: self, action: #selector(toolsVC.showPress(sender:)))
    remTab.sender = "Remember you need to switch to the app settings on your iphone to make changes"
    remTab.label = moreText
    
    let pulseTap = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    pulseTap.sender = "True [default] sends regular updates of all the sensor readings even if they haven't changed. False sends sensor reading only when they have changed."
    pulseTap.label = infoText
    pulseLabel.addGestureRecognizer(pulseTap)
    pulseLabel.addGestureRecognizer(remTab)
    pulseLabel.isUserInteractionEnabled = true
    
    
    let variableTap = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    variableTap.sender = "True [default] sends JSON fields only for fields with values. False sends JSON for all fields."
    variableTap.label = infoText
    variableLabel.addGestureRecognizer(variableTap)
    variableLabel.addGestureRecognizer(remTab)
    variableLabel.isUserInteractionEnabled = true
    
    let refreshTab = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    refreshTab.sender = "The rate at which pulse and/or motion reports get sent. "
    refreshTab.label = infoText
    refreshLabel.addGestureRecognizer(refreshTab)
    refreshLabel.addGestureRecognizer(remTab)
    refreshLabel.isUserInteractionEnabled = true
    
    let precisionTab = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    precisionTab.sender = "The number of significant digits reported in azimuth and motion sensor readings."
    precisionTab.label = infoText
    precisionLabel.addGestureRecognizer(precisionTab)
    precisionLabel.addGestureRecognizer(remTab)
    precisionLabel.isUserInteractionEnabled = true
    
    let autoTab = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    autoTab.sender = "True [default] stops sensors sending data when you return to the principle sensors page. False continues reporting."
    autoTab.label = infoText
    autoLabel.addGestureRecognizer(autoTab)
    autoLabel.addGestureRecognizer(remTab)
    autoLabel.isUserInteractionEnabled = true
    
    let fastTab = customTap(target: self, action: #selector(toolsVC.showTap(sender:)))
    fastTab.sender = "True skips explainations given on startup. False [default] runs them everytime."
    fastTab.label = infoText
    fastLabel.addGestureRecognizer(fastTab)
    fastLabel.addGestureRecognizer(remTab)
    fastLabel.isUserInteractionEnabled = true
    
    let textFeed = "Use the app settings to change the variables shown here. You may need to restart the app for the changes to take effect."
    showText(label: moreText, text: textFeed)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
      self.autoLabel.textColor = UIColor.systemBlue
      self.autoLabel.blinkText8()
      DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
        self.pulseLabel.textColor = UIColor.systemBlue
        self.pulseLabel.blinkText8()
        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
          self.variableLabel.textColor = UIColor.systemBlue
          self.variableLabel.blinkText8()
          DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
            self.refreshLabel.textColor = UIColor.systemBlue
            self.refreshLabel.blinkText8()
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
              self.precisionLabel.textColor = UIColor.systemBlue
              self.precisionLabel.blinkText8()
              DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                self.fastLabel.textColor = UIColor.systemBlue
                self.fastLabel.blinkText8()
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: {
                  self.backButton.blinkText()
                })
              })
            })
          })
        })
      })
    })
//    self.moreText.text = ""
//    self.moreText.alpha = 1
//    self.moreText.preferredMaxLayoutWidth = self.view.bounds.width - 40
//    self.moreText.font = UIFont.preferredFont(forTextStyle: .body)
//    self.moreText.adjustsFontForContentSizeCategory = true
//    self.moreText.isHidden = false
//    self.moreText.textAlignment = .left
//    self.moreText.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 90)
//    self.moreText.center = CGPoint(x:self.view.bounds.midX + 20,y:self.view.bounds.midY + 112)
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//      let words = Array(textFeed)
//      var i = 0
//      let pause = 0.1
//
//      let delay = pause * Double(textFeed.count)
//
//      self.paused = DispatchTimeInterval.seconds(Int(delay + 4))
//      Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
//
//        self.moreText.text = self.moreText.text! + String(words[i])
//        if i == words.count - 1 {
//          timer.invalidate()
//          UIView.animate(withDuration: 12) {
//            self.moreText.alpha = 0
//          }
//
//        } else {
//          i = i + 1
//
//        }
//      }
//    })
  }
  
  @objc func showTap(sender: Any) {
    let tag = sender as? customTap
    let label = tag!.label as? UILabel
    let textFeed = tag!.sender as? String
    showText(label: label!, text: textFeed!)
  }
  
  @objc func showPress(sender: Any) {
    print("SP")
    let tag = sender as? customLongPress
    let label = tag!.label as? UILabel
    let textFeed = tag!.sender as? String
    if tag?.state == .ended {
      showText(label: label!, text: textFeed!)
    }
  }
  
  var running = false
  
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
  
  
}



