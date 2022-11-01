//
//  MirrorWordNetApi.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/10/31.
//

public enum MirrorWordNetApi{
    
    //Get  Checks whether is authenticated or not and returns the user object if true
    case authMe
    
    //Request refresh token for user
    case refreshToken(refresh_token:String)
    
    //POST Logs out a user
    case loginOut
    
    var path:String{
        switch self {
        case .authMe:
            return "auth/me"
        case .loginOut:
            return "auth/logout"
        case .refreshToken:
            return "auth/refresh-token"
        }
    }
    
    var param:[String:Any]?{
        switch self {
        case .refreshToken(let refresh_token):
            return ["x-refresh-token":refresh_token]
        default:
            return nil
        }
    }
    
    var method:String{
        switch self {
        case .authMe,.refreshToken:
            return "GET"
        case .loginOut:
            return "POST"
        }
    }
    
    func serverUrl(env:MWEnvironment) -> String {
        switch self {
        case .authMe,.refreshToken:
            return env.ssoRoot + path
        case .loginOut:
            return env.ssoRoot + path
        }
    }
    
    
}
