//
//  Shared.swift
//  legoSocket
//
//  Created by localadmin on 14.05.19.
//  Copyright © 2019 ch.cqd.legoblue. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import Foundation

//var chatRoom:ChatRoom?

//var primeController: voiceVC?
var communications: connect?
var autoClose: Bool?
var lastButton: UIButton?
var precision: String?
var fastStart: Bool?
var refreshRate: Double?
var pulse: Bool?

var motionManager: CMMotionManager?
var directionManager: CLLocationManager?
var lastSwitch: UISwitch?

var port2G: Int16?
var connect2G: String?
var globalWord: String?
var globalImage: UIImage?

var proximityValue: Bool = false

var volume:Float = 0.5
var rate:Float = 0.5
var language:String = "en-US"

var uniqueID: String = "R"
var tag:[String:Int] = [:]
var sensitivity: Double = 20

var speakerToggle = false

struct globe:Codable {
  var trueNorth: String?
  var magneticNorth: String?
  
  init(trueNorth: String?, magneticNorth: String) {
    self.trueNorth = trueNorth
    self.magneticNorth = magneticNorth
  }
}
  
struct gps:Codable {
  var latitude: String?
  var longitude: String?
  var altitude: String?
  
  init(latitude: String, longitude:String?, altitude: String?) {
    self.latitude = latitude
    self.longitude = longitude
    self.altitude = altitude
  }
}

struct fly:Codable {
  var roll: String?
  var pitch: String?
  var yaw: String?
  
  init(roll: String?, pitch: String?, yaw: String?) {
    self.roll = roll
    self.pitch = pitch
    self.yaw = yaw
  }
}

struct neighbours:Codable {
  var proximity:String
  
  init(proximity: String) {
    self.proximity = proximity
  }
}

struct voice:Codable {
  var word: String?
  
  init(word: String?) {
    self.word = word
  }
}

struct simple:Codable {
  var online:String
  init(online: String) {
    self.online = online
  }
}

struct pulser: Codable {
  // proximity
  var proximity: String?
  // location
  var latitude: String?
  var longitude: String?
  var altitude: String?
  // azimuth
  var trueNorth: String?
  var magneticNorth: String?
  // motion
  var roll: String?
  var pitch: String?
  var yaw: String?
  // voice
  var word: String?
  
  init(proximity: String?, latitude: String?, longitude: String?, altitude: String?, trueNorth: String?, magneticNorth:String?, roll:String?, pitch: String?, yaw:String?, word:String?) {
    self.proximity = proximity
    self.latitude = latitude
    self.longitude = longitude
    self.altitude = altitude
    self.trueNorth = trueNorth
    self.magneticNorth = magneticNorth
    self.roll = roll
    self.pitch = pitch
    self.yaw = yaw
    self.word = word
  }
}

var superRec:pulser!





