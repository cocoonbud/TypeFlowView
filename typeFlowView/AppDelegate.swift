//
//  AppDelegate.swift
//  typeFlowView
//
//  Created by spell on 2024/9/9.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = ViewController.init()
        
        let nav = UINavigationController.init(rootViewController: vc)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        return true
    }
}

