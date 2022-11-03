//
//  MirrorWorldNetApi.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/31.
//

public enum MirrorWorldNetApi{
    
    //Get:  Checks whether is authenticated or not and returns the user object if true
    case authMe
    
    // Get: Request refresh token for user
    case refreshToken(refresh_token:String)
    
    //POST: Logs out a user
    case loginOut
    
    case queryUser(email:String)
    
    var path:String{
        switch self {
        case .authMe:
            return "auth/me"
        case .loginOut:
            return "auth/logout"
        case .refreshToken:
            return "auth/refresh-token"
        case .queryUser:
            return "auth/user"
        }
    }
    
    var param:[String:Any]?{
        switch self {
        case .refreshToken(let refresh_token):
            return ["x-refresh-token":refresh_token]
        case .queryUser(let email):
            return nil
        default:
            return nil
           
        }
    }
    
    var method:String{
        switch self {
        case .authMe,.refreshToken,.queryUser:
            return "GET"
        case .loginOut:
            return "POST"
        default:
            return "GET"
        }
    }
//    curl --location --request GET 'https://api-staging.mirrorworld.fun/v1/auth/user?email=email@example.com' \
//    --header 'x-api-key: <API_KEY>'
    func serverUrl(env:MWEnvironment) -> String {
        switch self {
        case .authMe,.refreshToken:
            return env.ssoRoot + path
        case .loginOut:
            return env.ssoRoot + path
        case .queryUser(let email):
            return env.ssoRoot + path + "?email=\(email)"
        default:
            return ""
        }
    }
    
    
}
