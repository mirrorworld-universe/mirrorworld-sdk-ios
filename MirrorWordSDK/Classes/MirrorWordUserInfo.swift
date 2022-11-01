//
//  MirrorWordUserInfo.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/10/30.
//

import UIKit


public class MirrorWordSDKAuthData:NSObject{
    public static let share = MirrorWordSDKAuthData()
    override public init() {
        super.init()
    }
    var access_token:String = ""
    var refresh_token:String = ""
    var userInfo:[String:Any]?
    
    func saveRefreshToken(){
        UserDefaults.standard.set(refresh_token, forKey: "mw_refresh_token")
        UserDefaults.standard.synchronize()
    }
    func getRefreshToken(){
        let r_token = UserDefaults.standard.string(forKey: "mw_refresh_token")
        MirrorWordSDKAuthData.share.refresh_token = r_token ?? ""
    }
    
    func clearToken(){
        UserDefaults.standard.removeObject(forKey: "mw_refresh_token")
        access_token = ""
        refresh_token = ""
        MirrorWordSDKAuthData.share.refresh_token = ""
    }
    
    
}



/*
class MWTool:NSObject{
    
    /**
     * save user info
     *
     */
    func saveUserInfo(){}
    /**
     * get user info
     *
     */
    func getUserInfo(){}
    /**
     * save refresh_Token
     *
     */
    
}
public class MWUserInfo: NSObject {
    // user
    var allow_spend:Int = 0
    var createdAt:String = ""
    var email:String = ""
    var email_verified:String = ""
    var eth_address:String = ""
    var has_security:Int = 0
    var id:String = ""
    var is_subaccount:Int = 0
    var main_user_id:String = ""
    var sol_address:String = ""
    var updatedAt:String = ""
    var username:String = ""

//    //token
//    var access_token:String = ""
//    var refresh_token:String = ""
}
public class MWWallet:NSObject {
    var eth_address:String = ""
    var sol_address:String = ""
}
*/
