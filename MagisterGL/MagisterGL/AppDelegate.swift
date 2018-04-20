//
//  AppDelegate.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 11.06.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder,
  UIApplicationDelegate
{
  var window: UIWindow?
  
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    // Initialize Google sign-in.
    GIDSignIn.sharedInstance().clientID = "1039528957452-rcbtr2gadj378kqecvu73ef3lh68sha4.apps.googleusercontent.com"
  }
  
  func application(_ application: UIApplication,
                   open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
  }
  
  @available(iOS 9.0, *)
  func application(_ app: UIApplication, open url: URL,
                   options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
    let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
    return GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
  }
}
