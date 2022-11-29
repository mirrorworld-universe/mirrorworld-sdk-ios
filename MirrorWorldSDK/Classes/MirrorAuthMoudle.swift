//
//  MirrorLoginMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
// 

import UIKit

@objc public class MirrorAuthMoudle: MirrorBaseMoudle {
    
    var config:MirrorWorldSDKConfig?
    
    @objc public var userInfo:[String:Any]? = MirrorWorldSDKAuthData.share.userInfo
    
    
    /**
     * open login webView
     *
     **/
    @objc func openLoginView(controller:UIViewController?) -> MirrorWorldLoginAuthController?{
        guard let sdkConfig = config else { return nil}
        
        let urlString = sdkConfig.environment.mainRoot + sdkConfig.apiKey
        MWLog.console("login Url:\(urlString)")
        guard let url = URL(string: urlString) else {
            MWLog.console(urlString)
            MWLog.console("please check your environment or apiKey.")
            return nil}
        
        let auth = MirrorWorldLoginAuthController.init(url: url)
        controller?.present(auth, animated: true)
        return auth
    }
    
    /**
     * logsOut
     *
     **/
    @objc public func loginOut(_ finsh:((_ isSucc:Bool)->Void)?){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.loginOut
            MirrorWorldNetWork().request(api: api) { response in
                DispatchQueue.main.async {
                    finsh?(true)
                }
            } _: { code,errorDesc in
                DispatchQueue.main.async {
                    finsh?(false)
                }
            }
        }
    }
    
    //Checks whether is authenticated or not and returns the user object if true
    @objc public func CheckAuthenticated(_ onBool:((_ on:Bool)->())?){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.authMe
            MirrorWorldNetWork().request(api: api) { response in
                DispatchQueue.main.async {
                    onBool?(true)
                }
            } _: { code,errorDesc in
                DispatchQueue.main.async {
                    onBool?(false)
                }
            }
        }
        
    }
    
    //Request refresh token for user
    @objc public func RefreshToken(_ onBool:((_ on:Bool)->())?){
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
                DispatchQueue.main.async {
                    onBool?(true)
                }
            } _: { code,errorDesc in
                DispatchQueue.main.async {
                    onBool?(false)
                }
            }
        }else{
            DispatchQueue.main.async {
                onBool?(false)
            }
        }
    }
    
    
    
    @objc public func QueryUser(email:String,onUserFetched:((_ userRes:String?)->())?,onFetchFailed:((_ code:Int,_ err:String?)->())?){
        guard email.count > 0 else {
            MWLog.console("plese check Your email !")
            return }
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.queryUser(email: email)
            MirrorWorldNetWork().request(api: api) {[weak self] response in
                self?.handleResponse(response: response, success: { user in
                    onUserFetched?(user)
                }, failed: { code, message in
                    onFetchFailed?(code,message)
                })
            } _: { code,err in
                DispatchQueue.main.async {
                    onFetchFailed?(code,err)
                }
            }
        }
       
    }
    
    
}
