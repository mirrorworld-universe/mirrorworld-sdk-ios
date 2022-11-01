//
//  MirrorLoginMoudle.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/11/1.
// 

import UIKit

public class MirrorAuthMoudle: NSObject {
    
    public var userInfo:[String:Any]? = MirrorWordSDKAuthData.share.userInfo
    
    /**
     * open login webView
     *
     **/
    func openLoginView(controller:UIViewController?,UrlString:String) -> MirrorWordLoginAuthController{
        let url = URL(string: UrlString)!
        let auth = MirrorWordLoginAuthController.init(url: url)
        controller?.present(auth, animated: true)
        return auth
    }
    
    /**
     *
     *
     **/
    func loginOut(_ finsh:((_ isSucc:Bool)->Void)?){
        let api = MirrorWordNetApi.loginOut
        MirrorWordNetWork().request(api: api) { response in
            DispatchQueue.main.async {
                finsh?(true)
            }
        } _: { errorDesc in
            DispatchQueue.main.async {
                finsh?(false)
            }
        }
    }
    
//Checks whether is authenticated or not and returns the user object if true
    func CheckAuthenticated(_ onBool:((_ on:Bool)->())?){
        let api = MirrorWordNetApi.authMe
        MirrorWordNetWork().request(api: api) { response in
           
            DispatchQueue.main.async {
                onBool?(true)
            }
        } _: { errorDesc in
            DispatchQueue.main.async {
                onBool?(false)
            }
        }

        
    }
    
    //Request refresh token for user
    func RefreshToken(_ onBool:((_ on:Bool)->())?){
        MirrorWordSDKAuthData.share.getRefreshToken()
        if MirrorWordSDKAuthData.share.refresh_token.count > 0 {
            MWLog.console("Exist refresh token ！")
            let api = MirrorWordNetApi.refreshToken(refresh_token: MirrorWordSDKAuthData.share.refresh_token)
            MirrorWordNetWork().request(api: api) {[weak self] response in
                let responseJson = response?.toJson()
                let data = responseJson?["data"] as? [String:Any]
                let user = data?["user"] as? [String:Any]
                let refreshToken = data?["refresh_token"] as? String
                let accessToken = data?["access_token"] as? String
                MirrorWordSDKAuthData.share.refresh_token = refreshToken ?? ""
                MirrorWordSDKAuthData.share.saveRefreshToken()
                MirrorWordSDKAuthData.share.access_token = accessToken ?? ""
                MirrorWordSDKAuthData.share.userInfo = user
                print("user : \(user)")
                onBool?(true)
            } _: { errorDesc in
                onBool?(false)
            }
        }else{
            onBool?(false)
        }
    }
    
    
}
