//
//  IAPproduct.swift
//  sensorCode
//
//  Created by localadmin on 13.12.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import Foundation

enum IAPProduct: String {
  case azimuth  = "ch.cqd.sensorCode.sensorCode.azimuth"
  case motion   = "ch.cqd.sensorCode.sensorCode.motion"
  case voice    = "ch.cqd.sensorCode.sensorCode.voice"
  case light    = "ch.cqd.sensorCode.sensorCode.light"
//  case azimuth  = "ch.cqd.sensorCode.sensorCode.azimuthT"
//  case motion   = "ch.cqd.sensorCode.sensorCode.motionT"
//  case voice    = "ch.cqd.sensorCode.sensorCode.voiceT"
//  case light    = "ch.cqd.sensorCode.sensorCode.lightT"
}

enum IAPStatus: String {
  case deferred = "deferred"
  case failed = "failed"
  case purchased = "purchased"
  case purchasing = "purchasing"
  case restored = "restored"
  case unknown = "unknown"
}


