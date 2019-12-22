//
//  SettingBundleHelper.swift
//  talkCode
//
//  Created by localadmin on 30.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
struct SettingsBundleKeys {
    static let AutoClose = "AUTO_CLOSE"
}
  class func checkAndExecuteSettings() {
    if UserDefaults.standard.bool(forKey: "AUTO_CLOSE") {
      autoClose = true
    } else {
      autoClose = false
    }
    if UserDefaults.standard.bool(forKey: "FAST_START") {
      fastStart = true
    } else {
      fastStart = false
    }
    if UserDefaults.standard.bool(forKey: "PULSE") {
      pulse = true
    } else {
      pulse = false
    }
    if (UserDefaults.standard.string(forKey: "PRECISION") != nil) {
      precision = UserDefaults.standard.string(forKey: "PRECISION")
    } else {
      precision = "2"
    }
    if (UserDefaults.standard.string(forKey: "RATE") != nil) {
      refreshRate = UserDefaults.standard.string(forKey: "RATE")?.doubleValue
    } else {
      refreshRate = 0.1
    }
    let ps = Double(precision!.doubleValue)
    let rr = Double(refreshRate!)
    
    if ps > 10.0 {
      precision = "10"
    }
    if ps < 0.01 {
      precision = "0.01"
    }
    if rr > 10.0 {
      refreshRate = 10
    }
    if rr < 0.01 {
      refreshRate = 0.01
    }
    
  }
}

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}


