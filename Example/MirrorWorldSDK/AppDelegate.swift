//
//  AppDelegate.swift
//  MirrorWorldSDK
//
//  Created by 791738673@qq.com on 10/21/2022.
//  Copyright (c) 2022 791738673@qq.com. All rights reserved.
//

import UIKit
import MirrorWorldSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init()
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        window?.rootViewController = sb.instantiateInitialViewController()
//        window?.rootViewController = DemoViewController()
//        window?.makeKeyAndVisible()
        return true
    }
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        MirrorWorldSDK.share.handleOpen(url: url)
        return true
    }
    
    

}

