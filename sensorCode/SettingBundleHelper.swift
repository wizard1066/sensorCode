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
    static let auto = "AUTO_CLOSE"
    static let fast = "FAST_START"
    static let precision = "PRECISION"
    static let rate = "RATE"
    static let variable = "VARIABLE"
    static let pulse = "PULSE"
    static let raw = "RAW"
}

  

  class func checkAndExecuteSettings() {
  
    let defaults = UserDefaults.standard
    
    func isFirstTimeOpening() -> Bool {
      let defaults = UserDefaults.standard
//      let answer = defaults.bool(forKey:"hasRun") ? false : true
      if(defaults.integer(forKey: "hasRun") == 0) {
          defaults.set(1, forKey: "hasRun")
          return true
      }
      return false

    }
    
    fastStart = UserDefaults.standard.bool(forKey: SettingsBundleKeys.fast)
    autoClose = UserDefaults.standard.bool(forKey: SettingsBundleKeys.auto)
    precision = UserDefaults.standard.string(forKey: SettingsBundleKeys.precision)
    variable = UserDefaults.standard.bool(forKey: SettingsBundleKeys.variable)
    refreshRate = UserDefaults.standard.string(forKey: SettingsBundleKeys.rate)
    variable = UserDefaults.standard.bool(forKey: SettingsBundleKeys.variable)
    pulse = UserDefaults.standard.bool(forKey: SettingsBundleKeys.pulse)
    raw = UserDefaults.standard.bool(forKey: SettingsBundleKeys.raw)
    
    if isFirstTimeOpening() {
      defaults.set(false, forKey: SettingsBundleKeys.fast)
      defaults.set(true, forKey: SettingsBundleKeys.auto)
      defaults.set(true, forKey: SettingsBundleKeys.variable)
      defaults.set(true, forKey: SettingsBundleKeys.auto)
      defaults.set(true, forKey: SettingsBundleKeys.pulse)
      defaults.set("0.1", forKey: SettingsBundleKeys.rate)
      defaults.set("2", forKey: SettingsBundleKeys.precision)
      defaults.set(false, forKey: SettingsBundleKeys.raw)
      precision = "2"
      refreshRate = "0.1"
    }
    
    let ps = Double(precision!.doubleValue)
    let rr = Double(refreshRate!.doubleValue)

    if ps > 10.0 {
      precision = "10"
    }
    if ps < 0.01 {
      precision = "0.01"
    }
    if rr > 10.0 {
      refreshRate = "10"
    }
    if rr < 0.01 {
      refreshRate = "0.01"
    }

  }
}

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}


