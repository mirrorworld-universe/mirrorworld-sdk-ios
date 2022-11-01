//
//  MirrorWordSDK.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/10/21.
//

import UIKit


public let MWSDK = MirrorWordSDK.share
public class MirrorWordSDK: NSObject {
    public static let share = MirrorWordSDK()
   public typealias loginListent = ((_ s:Bool)->Void)?

    var onSuccess:((_ userInfo:[String:Any]?)->())?
    var onFail:(()->())?
    
    private var loginMoudle:MirrorAuthMoudle = MirrorAuthMoudle()
    
    
    public var sdkConfig:MirrorWordSDKConfig = MirrorWordSDKConfig()
    public var sdkLog:MirrorWordLog = MirrorWordLog()
    public var sdkProtol:MirrorWordHandleProtocol = MirrorWordHandleProtocol()
    private var apiKey:String = ""
    private var clientSecret:String = ""
    private var clientId:String = ""
    
    private var access_token:String = ""
    private var refresh_token:String = ""
    
    private var loginAuthController: MirrorWordLoginAuthController?
    
    public weak var delegate:MirrorWordSDKProtocol?

    public override init() {
        super.init()
    }
    
    /**
     * init SDK
     */
    public func initSDK(env:MWEnvironment, apiKey:String, clientId:String = "", clientSecret:String = ""){
        self.apiKey = apiKey
        self.clientSecret = clientSecret
        self.clientId = clientId
        
        sdkConfig.environment = env
        sdkConfig.apiKey = self.apiKey
        sdkConfig.clientSecret = self.clientSecret
        sdkConfig.clientId = self.clientId
        
        guard self.apiKey.count > 0 else {
            sdkLog.console("Check Your appKey !")
            return
        }
        sdkLog.console("MirrorWordSDK - init - Success!")
        
        listenUrlschemeCallBack()
        
        
        loginMoudle.RefreshToken { on in
            print("CheckAuthenticated finsh")
        }
    }
    
    /**
     * init SDK
     * config: MirrorWordSDKConfig
     */
    public func initSDK(config:MirrorWordSDKConfig){
        sdkConfig = config
        listenUrlschemeCallBack()
        loginMoudle.RefreshToken { on in
            print("CheckAuthenticated finsh")
        }
    }
    
    /**
     * Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.
     * baseController： baseController will present of SFSafariViewController
     */
    
    public func StartLogin(baseController:UIViewController?,onSuccess:@escaping (_ userInfo:[String:Any]?)->(),onFail:@escaping ()->()){
        self.onSuccess = onSuccess
        self.onFail = onFail
        loginAuth(baseController)
    }
    
    
    /**
     * Logs out a user
     */
    public func loginOut(onSuccess: (()->())?, onFail: (()->())?){
        loginMoudle.loginOut { isSucc in
            if isSucc {
                MirrorWordSDKAuthData.share.clearToken()
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
    public func handleOpen(url:URL){
        sdkProtol.urlSchemeDecode(url: url)
    }
    
    /**
     * Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.
     *
     */
    public func CheckAuthenticated(_ onBool:((_ onBool:Bool)->())?){
        loginMoudle.CheckAuthenticated { succ in
            onBool?(succ)
        }
    }
    

    
}
extension MirrorWordSDK{
    private func loginAuth(_ controller:UIViewController?){
        guard controller != nil else {
            MWLog.console("plese check the baseController!")
            return }
        let urlString = sdkConfig.environment.mainRoot
        loginAuthController = loginMoudle.openLoginView(controller: controller, UrlString: urlString)
    }
   
    
    
}


extension MirrorWordSDK{
    func listenUrlschemeCallBack(){
//        sdkProtol.userInfoBolck = {[weak self] user in
//            self?.delegate?.userInfo(user)
//            self?.loginAuthController?.dismiss(animated: true)
//            self?.onSuccess?()
//        }
        sdkProtol.loginSuccess = {[weak self] userinfo in
            self?.onSuccess?(userinfo)
            self?.loginAuthController?.dismiss(animated: true)
        }
        
    }
   
}
