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

//var chatRoom:ChatRoom?

var primeController = listenVC()
var communications: connect?
var autoClose: Bool?
var lastButton: UIButton?
var precision: String?
var fastStart: Bool?
var refreshRate: Double?

var motionManager: CMMotionManager?
var directionManager: CLLocationManager?


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
  






