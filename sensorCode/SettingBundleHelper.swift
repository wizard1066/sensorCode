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
}

  class func checkAndExecuteSettings() {

    let defaults = UserDefaults.standard
    let settingsUrl = Bundle.main.path(forResource: "Settings", ofType: "bundle")
    var rate: String?
    
    let rootList = settingsUrl! + "/Root.plist"
    if let rootDictionary = NSDictionary(contentsOfFile: rootList) {
        let preferences = rootDictionary["PreferenceSpecifiers"] as! [NSDictionary]

        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                NSLog("Key not fount")
                continue
            }

           
            defaults.set(preference["DefaultValue"], forKey: key)
            switch key {
              case SettingsBundleKeys.auto:
                autoClose = preference["DefaultValue"] as? Bool
              case SettingsBundleKeys.pulse:
                pulse = preference["DefaultValue"] as? Bool
              case SettingsBundleKeys.fast:
                fastStart = preference["DefaultValue"] as? Bool
              case SettingsBundleKeys.precision:
                precision = preference["DefaultValue"] as? String
              case SettingsBundleKeys.rate:
                rate = preference["DefaultValue"] as? String
              case SettingsBundleKeys.variable:
                variable = preference["DefaultValue"] as? Bool
              default:
                break
              
            }
            
//            print("defaultsToRegister",defaultsToRegister)
        }
    }
    
    
    let ps = Double(precision!.doubleValue)
    let rr = Double(rate!.doubleValue)
    
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


