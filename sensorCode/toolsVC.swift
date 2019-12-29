//
//  toolsVC.swift
//  sensorCode
//
//  Created by localadmin on 29.12.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit

class toolsVC: UIViewController {

  @IBOutlet weak var pulseLabel: UILabel!
  @IBOutlet weak var fixedLabel: UILabel!
  @IBOutlet weak var refreshLabel: UILabel!
  @IBOutlet weak var precisionLabel: UILabel!
  @IBOutlet weak var autoLabel: UILabel!
  @IBOutlet weak var fastLabel: UILabel!

  @IBOutlet weak var pulseSwitch: UISwitch!
  @IBOutlet weak var fixedSwitch: UISwitch!
  @IBOutlet weak var autoSwitch: UISwitch!
  @IBOutlet weak var fastSwitch: UISwitch!
  
  @IBOutlet weak var refreshValue: UILabel!
  @IBOutlet weak var precisionValue: UILabel!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        
        if pulse! {
          pulseSwitch.setOn(true, animated: false)
        } else {
          pulseSwitch.setOn(false, animated: false)
        }
        if variable! {
          fixedSwitch.setOn(true, animated: false)
        } else {
          fixedSwitch.setOn(false, animated: false)
        }
        if autoClose! {
          autoSwitch.setOn(true, animated: false)
        } else {
          autoSwitch.setOn(false, animated: false)
        }
        if fastStart! {
          fastSwitch.setOn(true, animated: false)
        } else {
          fastSwitch.setOn(false, animated: false)
        }
        refreshValue.text = "\(refreshRate!)"
        precisionValue.text = precision
        
    }


}
