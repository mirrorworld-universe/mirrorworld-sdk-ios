//
//  MirrorWorldSDK.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/21.
//

import UIKit


public let MWSDK = MirrorWorldSDK.share
@objc public class MirrorWorldSDK: NSObject {
   @objc public static let share = MirrorWorldSDK()
    public typealias loginListent = ((_ s:Bool)->Void)?

    var onSuccess:((_ userInfo:[String:Any]?)->())?
    var onFail:(()->())?
    
    private var authMoudle:MirrorAuthMoudle = MirrorAuthMoudle()
    private var walletMoudle:MirrorWalletMoudle = MirrorWalletMoudle()
    
    
   @objc public var sdkConfig:MirrorWorldSDKConfig = MirrorWorldSDKConfig()
    @objc public var sdkLog:MirrorWorldLog = MirrorWorldLog()
    @objc public var sdkProtol:MirrorWorldHandleProtocol = MirrorWorldHandleProtocol()
    @objc private var apiKey:String = ""
    @objc private var clientSecret:String = ""
    @objc private var clientId:String = ""
    
    @objc private var access_token:String = ""
    @objc private var refresh_token:String = ""
    
    @objc private var loginAuthController: MirrorWorldLoginAuthController?
    
    public weak var delegate:MirrorWorldSDKProtocol?

    @objc public override init() {
        super.init()
    }
    
    /**
     * init SDK
     */
    @objc public func initSDK(env:MWEnvironment, apiKey:String){
        
        self.apiKey = apiKey
        
//        self.clientSecret = clientSecret
//        self.clientId = clientId
        
        sdkConfig.environment = env
        sdkConfig.apiKey = self.apiKey
        sdkConfig.clientSecret = self.clientSecret
        sdkConfig.clientId = self.clientId
        
        walletMoudle.config = sdkConfig
        authMoudle.config = sdkConfig
        
        guard self.apiKey.count > 0 else {
            sdkLog.console("Check Your appKey !")
            return
        }
        sdkLog.console("MirrorWorldSDK - init - Success!")
        
        listenUrlschemeCallBack()
        
        
        authMoudle.RefreshToken { on in
            print("CheckAuthenticated finsh")
        }
    }
    
    /**
     * init SDK
     * config: MirrorWorldSDKConfig
     */
    @objc public func initSDK(config:MirrorWorldSDKConfig){
        sdkConfig = config
        walletMoudle.config = sdkConfig
        authMoudle.config = sdkConfig
        listenUrlschemeCallBack()
        authMoudle.RefreshToken { on in
            print("CheckAuthenticated finsh")
        }
    }
    
    /**
     * Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.
     * baseController： baseController will present of SFSafariViewController
     */
    
    @objc public func StartLogin(onSuccess:@escaping (_ userInfo:[String:Any]?)->(),onFail:@escaping ()->()){
        self.onSuccess = onSuccess
        self.onFail = onFail
        loginAuth(Self.getBaseViewController())
    }
    
    
    /**
     * Logs out a user
     */
    @objc public func loginOut(onSuccess: (()->())?, onFail: (()->())?){
        authMoudle.loginOut { isSucc in
            if isSucc {
                MirrorWorldSDKAuthData.share.clearToken()
                onSuccess?()
            }else{
                onFail?()
            }
        }

    }
    
    /**
     * This method handles URLScheme. If you do not call this method, you will not be able to get the callback of login information
     *
     */
    @objc public func handleOpen(url:URL){
        sdkProtol.urlSchemeDecode(url: url)
    }
    
    /**
     * Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.
     *
     */
    @objc public func CheckAuthenticated(_ onBool:((_ onBool:Bool)->())?){
        authMoudle.CheckAuthenticated { succ in
            onBool?(succ)
        }
    }
    
    @objc public func OpenWallet(controller:UIViewController?){
        let topvc = Self.getBaseViewController()
        walletMoudle.openWallet(controller: topvc)
        
    }
    
    
    /**
     * Check user's info, then we can get user's base information such as wallet address and so on.
     */
    @objc public func QueryUser(email:String,onUserFetched:((_ userRes:String?)->())?,onFetchFailed:((_ code:Int,_ err:String?)->())?){
        authMoudle.QueryUser(email: email) { user in
            onUserFetched?(user)
        } onFetchFailed: { code, errDesc in
            onFetchFailed?(code,errDesc)
        }

    }
    
    /**
     * Get access token so that users can visit APIs.
     */
    @objc public func GetAccessToken(callBack:((_ result:String)->Void)?){
        let access_token = MirrorWorldSDKAuthData.share.access_token
        callBack?(access_token)
    }

    
}
extension MirrorWorldSDK{
    private func loginAuth(_ controller:UIViewController?){
        guard controller != nil else {
            MWLog.console("plese check the baseController!")
            return }
        loginAuthController = authMoudle.openLoginView(controller: controller)
    }
}


extension MirrorWorldSDK{
    func listenUrlschemeCallBack(){
        sdkProtol.loginSuccess = {[weak self] userinfo in
            self?.onSuccess?(userinfo)
            self?.loginAuthController?.dismiss(animated: true)
        }
    }
}

public extension MirrorWorldSDK{
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
