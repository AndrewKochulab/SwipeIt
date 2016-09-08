//
//  AppDelegate.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import Localizable
import Fabric
import Crashlytics
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Properties
  var window: UIWindow?

  // MARK: - Lifecycle
  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Fabric.with([Crashlytics.self])
    KingfisherManager.sharedManager.cache.clearDiskCache()
    //Localizable.setup()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) { }

  func applicationDidEnterBackground(_ application: UIApplication) { }

  func applicationWillEnterForeground(_ application: UIApplication) { }

  func applicationDidBecomeActive(_ application: UIApplication) { }

  func applicationWillTerminate(_ application: UIApplication) { }

}
