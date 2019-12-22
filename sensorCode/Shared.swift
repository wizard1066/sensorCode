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





