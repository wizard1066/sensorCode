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
  print("autoClose",autoClose)
  if UserDefaults.standard.bool(forKey: "FAST_START") {
      fastStart = true
    } else {
      fastStart = false
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
  }
}

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}


