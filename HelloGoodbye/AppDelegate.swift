//
//  AppDelegate.swift
//  HelloGoodbye
//
//  Created by 開発 on 2014/08/15.
//  Copyright (c) 2014年 Apple. All rights reserved.
//
/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:

  The delegate for the application.

 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]!) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let startViewController = StartViewController()

        let navigationController = UINavigationController(rootViewController: startViewController)
        navigationController.navigationBar.tintColor = StyleUtilities.foregroundColor()
        window.rootViewController = navigationController

        window.makeKeyAndVisible()
        return true
    }

}