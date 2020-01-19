//
//  Shared.swift
//  legoSocket
//
//  Created by localadmin on 14.05.19.
//  Copyright © 2019 ch.cqd.legoblue. All rights reserved.
//

import UIKit
//import CoreLocation
//import CoreMotion
import Foundation

var communications: connect?
var autoClose: Bool?
var lastButton: UIButton?
var precision: String?
var fastStart: Bool?

var refreshRate: String?
var pulse: Bool?
var variable: Bool?
var raw: Bool?

var lightOn: String?
var lightOff: String?


var lastSwitch: UISwitch?

var port2G: Int32?
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
  
  init(trueNorth: String?, magneticNorth: String?) {
    self.trueNorth = trueNorth
    self.magneticNorth = magneticNorth
  }
}
  
struct gps:Codable {
  var latitude: String?
  var longitude: String?
  var altitude: String?
  
  init(latitude: String?, longitude:String?, altitude: String?) {
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



struct simple:Codable {
  var online:String
  init(online: String) {
    self.online = online
  }
}

struct pulser2: Codable {
  var id:String?
  var word: String?
  var proximity: String?
  var position:gps?
  var movement:fly?
  var direction:globe?
  
  init(id:String?, wd:String?, px: String?, pos:gps?, mov:fly?, dir: globe?) {
    self.word = wd
    self.proximity = px
    self.position = pos
    self.movement = mov
    self.direction = dir
  }
}

var superRec2: pulser2!

struct settings: Codable {
  var online: String?
  var raw:String?
  var pulse:String?
  var variable:String?
  var refresh:String?
  var precision:String?
  var auto:String?
  var fast:String?
  
  init(on:String?, rw:String?, pe:String?, ve:String?, re:String?, pn:String?,ao:String?, ft:String?) {
    self.raw = rw
    self.pulse = pe
    self.variable = ve
    self.refresh = re
    self.precision = pn
    self.auto = ao
    self.fast = ft
    self.online = on
  }
}

var mode:settings?





