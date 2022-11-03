//
//  MirrorWorldSDKConfig.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/21.
//

import UIKit



@objc public class MirrorWorldSDKConfig: NSObject {
    override init() {
        super.init()
    }
    var environment:MWEnvironment = .MainNet
    var apiKey:String = ""
    
    var clientSecret:String = ""
    var clientId:String = ""
}



@objc public enum MWEnvironment: Int{
    case StagingDevNet
    case StagingMainNet
    case DevNet
    case MainNet
    
    var mainRoot:String{
        switch self {
        case .StagingDevNet:
            return "https://auth-staging.mirrorworld.fun/"
        case .StagingMainNet:
            return "https://auth-staging.mirrorworld.fun/"
        case .DevNet:
            return "https://auth.mirrorworld.fun/"
        case .MainNet:
            return "https://auth.mirrorworld.fun/"
        }
    }
    
    var marketRoot:String{
        switch self {
        case .StagingDevNet:
            return "https://jump-devnet.mirrorworld.fun"
        case .StagingMainNet:
            return "https://jump-devnet.mirrorworld.fun"
        case .DevNet:
            return "https://jump-devnet.mirrorworld.fun"
        case .MainNet:
            return "https://jump-devnet.mirrorworld.fun"
        }
    }
    
    
    var ssoRoot:String{
        switch self {
        case .StagingDevNet:
            return "https://api-staging.mirrorworld.fun/v1/"
        case .StagingMainNet:
            return "https://api-staging.mirrorworld.fun/v1/"
        case .DevNet:
            return "https://api.mirrorworld.fun/v1/"
        case .MainNet:
            return "https://api.mirrorworld.fun/v1/"
        }
    }
    
    var apiRoot:String{
        switch self {
        case .StagingDevNet:
            return "https://api-staging.mirrorworld.fun/v1/devnet/"
        case .StagingMainNet:
            return "https://api-staging.mirrorworld.fun/v1/mainnet/"
        case .DevNet:
            return "https://api.mirrorworld.fun/v1/devnet/"
        case .MainNet:
            return "https://api.mirrorworld.fun/v1/mainnet/"
        }
    }
    
}
