//
//  MirrorUIConfig.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/12/1.
//

import UIKit

@objc public class MirrorUIConfig: NSObject {
    //    @objc public static let share = MirrorUIConfig()
    public override init() {
        super.init()
    }

   @objc public var baseViewContoller:UIViewController?{
        get{
            return Self.getBaseViewController()
        }
    }
    @objc public var webTintColor:UIColor = UIColor(red: 166/255.0, green: 226/255.0, blue: 46/255.0, alpha: 1)
    @objc public var webControllerColor:UIColor = UIColor.white
}
public extension MirrorUIConfig{
    @objc class func getBaseViewController() -> UIViewController?{
            guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
                return nil
            }
            var topController = rootViewController
            while let newTopController = topController.presentedViewController {
                topController = newTopController
            }
            return topController
        }
}
