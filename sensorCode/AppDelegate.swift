//
//  AppDelegate.swift
//  sensorCode
//
//  Created by localadmin on 23.09.19.
//  Copyright © 2019 Mark Lucking. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

  
      SettingsBundleHelper.checkAndExecuteSettings()
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    print("applicationWillResignActive")
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    print("applicationDidEnterBackground")
    
    communications?.disconnectUDP()
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    communications?.reconnect()
    
    fastStart = UserDefaults.standard.bool(forKey: ap.fast.rawValue)
    autoClose = UserDefaults.standard.bool(forKey: ap.auto.rawValue)
    precision = UserDefaults.standard.string(forKey: ap.precision.rawValue)
    variable = UserDefaults.standard.bool(forKey: ap.variable.rawValue)
    refreshRate = UserDefaults.standard.string(forKey: ap.rate.rawValue)
    variable = UserDefaults.standard.bool(forKey: ap.variable.rawValue)
    pulse = UserDefaults.standard.bool(forKey: ap.pulse.rawValue)
    raw = UserDefaults.standard.bool(forKey: ap.raw.rawValue)
    
    let (localEnd,remoteEnd) = (communications?.returnEndPoints())!
//    print("mode ",localEnd)
    mode = settings(on: localEnd, rw: raw?.description, pe: pulse?.description, ve: variable?.description, re: refreshRate?.description, pn: precision?.description, ao: autoClose?.description, ft: fastStart?.description)
    communications?.sendUDP(mode!)
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
  }


}

