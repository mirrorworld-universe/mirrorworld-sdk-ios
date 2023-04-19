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
    
    public var SDKVersion:String = "1.2.0"
    
    public typealias loginListent = ((_ s:Bool)->Void)?

    public var onSuccess:((_ userInfo:[String:Any]?)->())?
    
    public var onWallectSuccess:((_ userInfo:[String:Any]?)->())?
    
    public var onFail:(()->())?
    
    public var onWalletLogOut:(()->())?
    
    public var Solana:MirrorSolana = MirrorSolana()
    public var EVM:MirrorEVM = MirrorEVM()
    
    private var authMoudle:MirrorAuthMoudle = MirrorAuthMoudle()

    @objc public var sdkConfig:MirrorWorldSDKConfig = MirrorWorldSDKConfig()
    @objc public var sdkProtol:MirrorWorldHandleProtocol = MirrorWorldHandleProtocol()
    @objc private var apiKey:String = ""
    @objc private var chain:MWChain = MWChain.Solana
    @objc private var clientSecret:String = ""
    @objc private var clientId:String = ""
    
    
    @objc private var loginAuthController: MirrorWorldLoginAuthController?
    
    public weak var delegate:MirrorWorldSDKProtocol?

    @objc public override init() {
        super.init()
    }
    
    @objc public func Version() -> String{
        return SDKVersion
    }
    
    @objc public func setDebug(_ debug:Bool){
        MWLog.isDebug = debug
    }
    
    ///Authentication APIs
    /**
     * init SDK
     */
    @objc public func initSDK(env:MWEnvironment,chain:MWChain,apiKey:String) -> Bool{
        MWLog.console("iOS-SDK-Version:\(SDKVersion)")

        self.apiKey = apiKey
        self.chain = chain
        
//        self.clientSecret = clientSecret
//        self.clientId = clientId
        
        sdkConfig.environment = env
        sdkConfig.apiKey = self.apiKey
        sdkConfig.clientSecret = self.clientSecret
        sdkConfig.clientId = self.clientId
        MirrorUrlUtils.shard.initSDKParams(chain: chain, env: env)
        
        authMoudle.config = sdkConfig
        if(self.chain == MWChain.Solana){
            Solana.config = sdkConfig
        }
        
        MWLog.console("apiKey:\(apiKey)")
        guard self.apiKey.count > 0 else {
            MWLog.console("Check Your appKey !")
            return false
        }
        MWLog.console("MirrorWorldSDK - init - Success!")
        
        listenUrlschemeCallBack()
        
        return true
//        authMoudle.RefreshToken { on in
//            self.sdkLog.console("CheckAuthenticated finsh")
//        }
    }
    
    /**
     * init SDK
     * config: MirrorWorldSDKConfig
     */
    @objc public func initSDK(config:MirrorWorldSDKConfig) -> Bool{
        if(config.chain == MWChain.Solana){
            Solana.config = sdkConfig
        }
        
        sdkConfig = config
        authMoudle.config = sdkConfig
        
        listenUrlschemeCallBack()
        return true
//        authMoudle.RefreshToken { on in
//            print("CheckAuthenticated finsh")
//        }
    }
    
    /**
     * Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.
     * baseController： baseController will present of SFSafariViewController
     */
    
    @objc public func startLogin(onSuccess:@escaping (_ userInfo:[String:Any]?)->(),onFail:@escaping ()->()){
        self.onSuccess = onSuccess
        self.onFail = onFail
        loginAuth(Self.getBaseViewController())
    }
    
    /**
     * User can use email on Mirror World and its password to login instad of social account
     */
    @objc public func loginWithEmail(email:String, passWord:String, onSuccess: (()->())?, onFail: (()->())?){
        authMoudle.loginWithEmail(email, passWord: passWord) { isSucc in
            if(isSucc){
                onSuccess?()
            }else{
                onFail?()
            }
        }
    }
    
    /**
     * Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.
     */
    @objc public func isLogged(_ onBool:((_ onBool:Bool)->())?){
        authMoudle.CheckAuthenticated { succ in
            onBool?(succ)
        }
    }
    
    @objc public func GuestLogin(onSuccess: (()->())?, onFail: (()->())?){
        authMoudle.GuestLogin { isSucc in
            if(isSucc){
                onSuccess?()
            }else{
                onFail?()
            }
        }
    }
    
    /**
     * Logs out a user
     */
    @objc public func Logout(onSuccess: (()->())?, onFail: (()->())?){
        authMoudle.Logout { isSucc in
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
     * Open a webview which would show the wallet page.
     */
//    @objc public func StartLogin(onSuccess:@escaping (_ userInfo:[String:Any]?)->(),onFail:@escaping ()->()){

    
    ///Client APIs
    ///
    ///
    @objc public func openWallet(onLogout:@escaping ()->Void,loginSuccess:@escaping (_ userInfo:[String:Any]?)->()){
    
        self.onWalletLogOut = onLogout
        self.onWallectSuccess = loginSuccess

        let topvc = Self.getBaseViewController()
        self.doOpenWallet(controller: topvc)
    }
    
    @objc private func doOpenWallet(controller:UIViewController?){
        authMoudle.checkAccessToken {[weak self] succ in
            var walletUrl = (self?.sdkConfig.environment.mainRoot ?? "")
            if succ{
                walletUrl = (self?.sdkConfig.environment.mainRoot ?? "") + "jwt?key=" + MirrorWorldSDKAuthData.share.access_token
            }else{
                walletUrl = (self?.sdkConfig.environment.mainRoot ?? "")
            }
            guard walletUrl.count > 0 else { return }
            let url = URL(string: walletUrl)!
            let auth = MirrorWorldLoginAuthController.init(url: url)
            controller?.present(auth, animated: true)
        }
    }
    
    @objc public func openMarket(url:String?){
        let basevc = Self.getBaseViewController()
        doOpenMarketPlacePage(url: url, controller: basevc)
    }
    
    @objc private func doOpenMarketPlacePage(url:String?,controller:UIViewController?){
        authMoudle.checkAccessToken { succ in
            guard let urlString = url,urlString.count > 0 else {
                MWLog.console("please check marketplace address.")
                return
            }
            var marketPlaceAddress = ""
            if !urlString.contains("?auth="){
                marketPlaceAddress = urlString + "?auth=" + MirrorWorldSDKAuthData.share.access_token
            }else{
                marketPlaceAddress = urlString
            }
            guard let url = URL(string: marketPlaceAddress) else {
                MWLog.console(marketPlaceAddress)
                MWLog.console("please check your access_token.")
                return }
            let auth = MirrorWorldLoginAuthController.init(url: url)
            controller?.present(auth, animated: true)
        }
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
        authMoudle.GetAccessToken { res in
            callBack?(res)
        }
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
//        marketPlaceMoudle.authorization.listenSchemeCallBack(schemeProtocol: sdkProtol)
//        authMoudle.authorization.listenSchemeCallBack(schemeProtocol: sdkProtol)
//        walletMoudle.authorization.listenSchemeCallBack(schemeProtocol: sdkProtol)

        
        sdkProtol.loginSuccess = {[weak self] userinfo in
            self?.onSuccess?(userinfo)
            self?.onWallectSuccess?(userinfo)
            self?.loginAuthController?.dismiss(animated: true)
        }
        sdkProtol.onWalletLogOut = {[weak self] in
            self?.onWalletLogOut?()
        }
        sdkProtol.authorizationTokenBlock = {[weak self] (uuid, token) in
            self?.authMoudle.authorization.callBackToken(uuid: uuid,token: token)
            MirrorSecurityVerificationShared.share.authTokenCallBack(uuid: uuid, token: token)
            
            MirrorSecurityVerificationShared.share.ApproveCallBack(uuid: uuid, token: token)
        }
    }
    
    
    @objc public func mw_Unity_Wallet(url:String?,onLogout:@escaping ()->Void,loginSuccess:@escaping (_ userInfo:[String:Any]?)->()){
        self.onWalletLogOut = onLogout
        let topvc = Self.getBaseViewController()
        
        authMoudle.checkAccessToken { succ in
            var walletUrl = url ?? ""
            guard walletUrl.count > 0 else { return }
            let url = URL(string: walletUrl)!
            let auth = MirrorWorldLoginAuthController.init(url: url)
            topvc?.present(auth, animated: true)
        }
    }
    
}

public extension MirrorWorldSDK{
    @objc class func getBaseViewController() -> UIViewController?{
            return MirrorUIConfig().baseViewContoller
        }
}
