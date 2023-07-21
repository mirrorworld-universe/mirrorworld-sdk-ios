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
    
    public var chain:MWChain = .Solana
}

@objc public enum MWChain: Int{
    case Solana = 101
    case Ethereum = 201
    case Polygon = 202
    case BNB = 203
    case SUI = 301
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
    
    
    public var walletUrl:String{
//        return "https://auth.mirrorworld.fun/"
        switch self {
        case .StagingDevNet:
            return "https://auth-next-staging.mirrorworld.fun/v1/assets/tokens?useSchemeRedirect=true"
        case .StagingMainNet:
            return "https://auth-next-staging.mirrorworld.fun/v1/assets/tokens?useSchemeRedirect=true"
        case .DevNet:
            return "https://auth-next.mirrorworld.fun/v1/assets/tokens?useSchemeRedirect=true"
        case .MainNet:
            return "https://auth-next.mirrorworld.fun/v1/assets/tokens?useSchemeRedirect=true"
        }
    }
    
    public var loginPageUrl:String{
        switch self {
        case .StagingDevNet:
            return "https://auth-next-staging.mirrorworld.fun/v1/auth/login"
        case .StagingMainNet:
            return "https://auth-next-staging.mirrorworld.fun/v1/auth/login"
        case .DevNet:
            return "https://auth-next.mirrorworld.fun/v1/auth/login"
        case .MainNet:
            return "https://auth-next.mirrorworld.fun/v1/auth/login"
        }
    }
    
    public var approvePageUrl:String{
        switch self {
        case .StagingDevNet:
            return "https://auth-next-staging.mirrorworld.fun/v1/approve/"
        case .StagingMainNet:
            return "https://auth-next-staging.mirrorworld.fun/v1/approve/"
        case .DevNet:
            return "https://auth-next.mirrorworld.fun/v1/approve/"
        case .MainNet:
            return "https://auth-next.mirrorworld.fun/v1/approve/"
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
            return "https://api-staging.mirrorworld.fun/v2/"
        case .StagingMainNet:
            return "https://api-staging.mirrorworld.fun/v2/"
        case .DevNet:
            return "https://api.mirrorworld.fun/v2/"
        case .MainNet:
            return "https://api.mirrorworld.fun/v2/"
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
