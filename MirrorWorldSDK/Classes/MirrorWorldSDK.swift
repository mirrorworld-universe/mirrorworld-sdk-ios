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
    private var marketPlaceMoudle:MirrorMarketplaceMoudle = MirrorMarketplaceMoudle()

    
    
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
        marketPlaceMoudle.config = sdkConfig
        
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
        marketPlaceMoudle.config = sdkConfig
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
    
    @objc public func OpenWallet(){
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
    
    /**
     *
     */
    @objc public func GetWalletTokens(onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        walletMoudle.GetWalletTokens { res in
            onSuccess?(res)
        } onFailed: {
            onFailed?() 
        }
    }
    
    /**
     *
     *
     */
    @objc public func GetWalletTransactions(limit:Int, next_before:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        walletMoudle.GetWalletTransactions(limit: limit, next_before: next_before) { result in
            onSuccess?(result)
        } onFailed: {
            onFailed?()
        }
    }
    
    /**
     *
     *
     */
    @objc public func GetWalletTransactionsBy(signature:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        walletMoudle.GetWalletTransactionBySignature(signature: signature) { result in
            onSuccess?(result)
        } onFailed: {
            onFailed?()
        }

    }
    
    /**
     *
     *
     */
    @objc public func TransferSolToAnotherAddress(to_publickey:String,amount:Int, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        walletMoudle.TransferSOLtoAnotherAddress(to_publickey: to_publickey, amount: amount) { response in
            onSuccess?(response)
        } onFailed: {
            onFailed?()
        }


    }
    
    @objc public func TransferTokenToAnotherAddress(to_publickey:String,amount:Int,token_mint:String,decimals:Int,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        walletMoudle.TransferTokenToAnotherAddress(to_publickey: to_publickey, amount: amount, token_mint: token_mint, decimals: decimals) { response in
            onSuccess?(response)
        } onFailed: {
            onFailed?()
        }

    }
    
    //: MARK: - MarketPlace
    @objc public func MintNewNFT(collection_mint: String, name: String, symbol: String, url: String, seller_fee_basis_points: Int, confirmation: String, onSuccess: onSuccess, onFailed: onFailed){
        marketPlaceMoudle.MintNewNFT(collection_mint: collection_mint, name: name, symbol: symbol, url: url, seller_fee_basis_points: seller_fee_basis_points, confirmation: confirmation, onSuccess: { data in
            onSuccess?(data)
         }, onFailed: { code,mess in
             onFailed?(code,mess)
         })
    }
    @objc public func MintNewCollection(name:String,symbol:String,url:String,confirmation:String,seller_fee_basis_points:Int,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.MintNewCollection(name: name, symbol: symbol, url: url, confirmation: confirmation, seller_fee_basis_points: seller_fee_basis_points, onSuccess: { data in
           onSuccess?(data)
        }, onFailed: { code,mess in
            onFailed?(code,mess)
        })
    }
    
    @objc public func FetchSingleNFT(mint_Address:String,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.FetchSingleNFT(mint_Address: mint_Address) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    
    @objc public func TransferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.TransferNFTToAnotherSolanaWallet(mint_address: mint_address, to_wallet_address: to_wallet_address, confirmation: confirmation) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }
    }
    
    @objc public func ListNFT(mint_address:String,price:Double,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.ListNFT(mint_address: mint_address, price: price, confirmation: confirmation) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
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
