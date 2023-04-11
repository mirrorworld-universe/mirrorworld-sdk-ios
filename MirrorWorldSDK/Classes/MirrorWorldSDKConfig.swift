//
//  MirrorWorldSDKConfig.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/21.
//

import UIKit



@objc public class MirrorWorldSDKConfig: NSObject {
    override public init() {
        super.init()
    }
    public var environment:MWEnvironment = .MainNet
    public var apiKey:String = ""
    
    public var clientSecret:String = ""
    public var clientId:String = ""
    
    
}

@objc public enum MWChain: Int{
    case Solana = 1
    case Ethreum = 2
    case Polygon = 3
    case BNB = 4
}


@objc public enum MWEnvironment: Int{
//    #if DEBUG
    case StagingDevNet = 0
    case StagingMainNet = 1
    case MainNet = 2
    case DevNet = 3
//    #else
//    case MainNet = 2
//    case DevNet = 3
//    #endif
    
   
    
   public var mainRoot:String{
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
            return "https://jump.mirrorworld.fun"
        case .DevNet:
            return "https://jump-devnet.mirrorworld.fun"
        case .MainNet:
            return "https://jump.mirrorworld.fun"
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
    
    public var authRoot:String{
        switch self {
        case .StagingDevNet:
            return "https://auth-staging.mirrorworld.fun/approve/"
        case .StagingMainNet:
            return "https://auth-staging.mirrorworld.fun/approve/"
        case .DevNet:
            return "https://auth.mirrorworld.fun/approve/"
        case .MainNet:
            return "https://auth.mirrorworld.fun/approve/"
        }
    }
    
}
