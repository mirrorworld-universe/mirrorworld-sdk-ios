//
//  MirrorLoginMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
// 

import UIKit

@objc public class MirrorAuthMoudle: NSObject {
    
    var config:MirrorWorldSDKConfig?

    @objc public var userInfo:[String:Any]? = MirrorWorldSDKAuthData.share.userInfo
    
    /**
     * open login webView
     *
     **/
    @objc func openLoginView(controller:UIViewController?) -> MirrorWorldLoginAuthController?{
        guard let sdkConfig = config else { return nil}
        let urlString = sdkConfig.environment.mainRoot + sdkConfig.apiKey
        let url = URL(string: urlString)!
        let auth = MirrorWorldLoginAuthController.init(url: url)
        controller?.present(auth, animated: true)
        return auth
    }
    
    /**
     * logsOut
     *
     **/
    @objc func loginOut(_ finsh:((_ isSucc:Bool)->Void)?){
        let api = MirrorWorldNetApi.loginOut
        MirrorWorldNetWork().request(api: api) { response in
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
    @objc func CheckAuthenticated(_ onBool:((_ on:Bool)->())?){
        let api = MirrorWorldNetApi.authMe
        MirrorWorldNetWork().request(api: api) { response in
           
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
    @objc func RefreshToken(_ onBool:((_ on:Bool)->())?){
        MirrorWorldSDKAuthData.share.getRefreshToken()
        if MirrorWorldSDKAuthData.share.refresh_token.count > 0 {
            MWLog.console("Exist refresh token ！")
            let api = MirrorWorldNetApi.refreshToken(refresh_token: MirrorWorldSDKAuthData.share.refresh_token)
            MirrorWorldNetWork().request(api: api) { response in
                let responseJson = response?.toJson()
                let data = responseJson?["data"] as? [String:Any]
                let user = data?["user"] as? [String:Any]
                let refreshToken = data?["refresh_token"] as? String
                let accessToken = data?["access_token"] as? String
                MirrorWorldSDKAuthData.share.refresh_token = refreshToken ?? ""
                MirrorWorldSDKAuthData.share.saveRefreshToken()
                MirrorWorldSDKAuthData.share.access_token = accessToken ?? ""
                MirrorWorldSDKAuthData.share.userInfo = user
                onBool?(true)
            } _: { errorDesc in
                onBool?(false)
            }
        }else{
            onBool?(false)
        }
    }
    
    
    
    @objc func QueryUser(email:String,onUserFetched:((_ userRes:String?)->())?,onFetchFailed:((_ code:Int,_ err:String?)->())?){
        guard email.count > 0 else {
            MWLog.console("plese check Your email !")
            return }
        let api = MirrorWorldNetApi.queryUser(email: email)
        MirrorWorldNetWork().request(api: api) { response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let user = data?.toString()
            DispatchQueue.main.async {
                onUserFetched?(user)
            }
        } _: { err in
            DispatchQueue.main.async {
                onFetchFailed?(0,err)
            }
        }

    }
    
    
}
