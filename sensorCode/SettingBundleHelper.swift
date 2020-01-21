//
//  SettingBundleHelper.swift
//  talkCode
//
//  Created by localadmin on 30.11.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import Foundation

enum ap: String {
    case auto = "AUTO_CLOSE"
    case fast = "FAST_START"
    case precision = "PRECISION"
    case rate = "RATE"
    case variable = "VARIABLE"
    case pulse = "PULSE"
    case raw = "RAW"
}


class SettingsBundleHelper {
//struct SettingsBundleKeys {
//    static let auto = "AUTO_CLOSE"
//    static let fast = "FAST_START"
//    static let precision = "PRECISION"
//    static let rate = "RATE"
//    static let variable = "VARIABLE"
//    static let pulse = "PULSE"
//    static let raw = "RAW"
//}

  

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
    
    fastStart = UserDefaults.standard.bool(forKey: ap.fast.rawValue)
    autoClose = UserDefaults.standard.bool(forKey: ap.auto.rawValue)
    precision = UserDefaults.standard.string(forKey: ap.precision.rawValue)
    variable = UserDefaults.standard.bool(forKey: ap.variable.rawValue)
    refreshRate = UserDefaults.standard.string(forKey: ap.rate.rawValue)
    variable = UserDefaults.standard.bool(forKey: ap.variable.rawValue)
    pulse = UserDefaults.standard.bool(forKey: ap.pulse.rawValue)
    raw = UserDefaults.standard.bool(forKey: ap.raw.rawValue)
    
    if isFirstTimeOpening() {
      defaults.set(false, forKey: ap.fast.rawValue)
      defaults.set(false, forKey: ap.auto.rawValue)
      defaults.set(false, forKey: ap.variable.rawValue)
      defaults.set(false, forKey: ap.auto.rawValue)
      defaults.set(false, forKey: ap.pulse.rawValue)
      defaults.set("0.1", forKey: ap.rate.rawValue)
      defaults.set("2", forKey: ap.precision.rawValue)
      defaults.set(false, forKey: ap.raw.rawValue)
      precision = "2"
      refreshRate = "0.1"
    } else {
      defaults.set(true, forKey: ap.fast.rawValue)
      fastStart = true
    }
    
    let (localEnd,remoteEnd) = communications?.returnEndPoints() ?? (nil,nil)
    
    mode = settings(on: localEnd, rw: raw?.description, pe: pulse?.description, ve: variable?.description, re: refreshRate?.description, pn: precision?.description, ao: autoClose?.description, ft: fastStart?.description)
    
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


