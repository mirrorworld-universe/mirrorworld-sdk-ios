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
    
    public var SDKVersion:String = "1.0.0"
    
    public typealias loginListent = ((_ s:Bool)->Void)?

    var onSuccess:((_ userInfo:[String:Any]?)->())?
    
    var onWallectSuccess:((_ userInfo:[String:Any]?)->())?
    
    var onFail:(()->())?
    
    var onWalletLogOut:(()->())?
    
    private var authMoudle:MirrorAuthMoudle = MirrorAuthMoudle()
    private var walletMoudle:MirrorWalletMoudle = MirrorWalletMoudle()
    private var marketPlaceMoudle:MirrorMarketplaceMoudle = MirrorMarketplaceMoudle()
    private var metedataFilterMoudle:MirrorMetadataFilterMoudle = MirrorMetadataFilterMoudle()


    @objc public var sdkConfig:MirrorWorldSDKConfig = MirrorWorldSDKConfig()
    @objc public var sdkProtol:MirrorWorldHandleProtocol = MirrorWorldHandleProtocol()
    @objc private var apiKey:String = ""
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
    
    /**
     * init SDK
     */
    @objc public func initSDK(env:MWEnvironment, apiKey:String) -> Bool{
        MWLog.console("iOS-SDK-Version:\(SDKVersion)")

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
        metedataFilterMoudle.config = sdkConfig
        
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
        sdkConfig = config
        walletMoudle.config = sdkConfig
        authMoudle.config = sdkConfig
        marketPlaceMoudle.config = sdkConfig
        metedataFilterMoudle.config = sdkConfig

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
    
    @objc public func StartLogin(onSuccess:@escaping (_ userInfo:[String:Any]?)->(),onFail:@escaping ()->()){
        self.onSuccess = onSuccess
        self.onFail = onFail
        loginAuth(Self.getBaseViewController())
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
     * Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.
     *
     */
    @objc public func CheckAuthenticated(_ onBool:((_ onBool:Bool)->())?){
        authMoudle.CheckAuthenticated { succ in
            onBool?(succ)
        }
    }
    
    /**
     * Open a webview which would show the wallet page.
     */
//    @objc public func StartLogin(onSuccess:@escaping (_ userInfo:[String:Any]?)->(),onFail:@escaping ()->()){

    @objc public func OpenWallet(onLogout:@escaping ()->Void,loginSuccess:@escaping (_ userInfo:[String:Any]?)->()){
    
        self.onWalletLogOut = onLogout
        self.onWallectSuccess = loginSuccess

        let topvc = Self.getBaseViewController()
        walletMoudle.openWallet(controller: topvc)
    }
    
    @objc public func mw_Unity_Wallet(url:String?,onLogout:@escaping ()->Void,loginSuccess:@escaping (_ userInfo:[String:Any]?)->()){
        self.onWalletLogOut = onLogout
        let topvc = Self.getBaseViewController()
        walletMoudle.mw_Unity_Wallet(url: url, controller: Self.getBaseViewController())
    }
    
    @objc public func openMarketPlacePage(url:String?){
        let basevc = Self.getBaseViewController()
        marketPlaceMoudle.openMarketPlacePage(url: url, controller: basevc)
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
    /**
     * Mint a new NFT.
     *
     */
    @objc public func MintNewNFT(collection_mint: String, name: String, symbol: String, url: String, seller_fee_basis_points: Int, confirmation: String = "finalized", onSuccess: onSuccess, onFailed: onFailed){
        marketPlaceMoudle.MintNewNFT(collection_mint: collection_mint, name: name, symbol: symbol, url: url, seller_fee_basis_points: seller_fee_basis_points, confirmation: confirmation, onSuccess: { data in
            onSuccess?(data)
         }, onFailed: { code,mess in
             onFailed?(code,mess)
         })
    }
    @objc public func MintNewCollection(name:String,symbol:String,url:String,confirmation:String = "finalized",seller_fee_basis_points:Int,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.MintNewCollection(name: name, symbol: symbol, url: url, confirmation: confirmation, seller_fee_basis_points: seller_fee_basis_points, onSuccess: { data in
           onSuccess?(data)
        }, onFailed: { code,mess in
            onFailed?(code,mess)
        })
    }
    
    
//
    
    @objc public func  CreateVerifiedSubCollection(name:String,collection_mint:String,symbol:String,url:String, _ confirmation:String = "finalized",onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.CreateVerifiedSubCollection(name: name, collection_mint: collection_mint, symbol: symbol, url: url, confirmation) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    
    /**
     * Fetch the details of a NFT.
     */
    @objc public func FetchSingleNFT(mint_Address:String,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.FetchSingleNFT(mint_Address: mint_Address) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    
    @objc public func TransferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String = "finalized",onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.TransferNFTToAnotherSolanaWallet(mint_address: mint_address, to_wallet_address: to_wallet_address, confirmation: confirmation) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }
    }
    
    /**
     * Get list of NFT on market place.
     */
    @objc public func ListNFT(mint_address:String,price:Double,confirmation:String = "finalized",onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.ListNFT(mint_address: mint_address, price: price, confirmation: confirmation) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    /**
     *  Update Listing of NFT on the marketplace
     */
    @objc public func UpdateNFTListing(mint_address:String,price:Double, confirmation:String = "finalized",onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.UpdateNFTListing(mint_address: mint_address, price: price, confirmation: confirmation) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    /**
     * Cancel listing of NFT.
     */
    @objc public func CancelNFTListing(mint_address:String,price:Double,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.CancelNFTListing(mint_address: mint_address, price: price) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }

    
    @objc public func FetchNFTsByMintAddresses(mint_addresses:[String],onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.FetchNFTsByMintAddresses(mint_addresses: mint_addresses) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    
    /**
     * Get a collection of NFT by creator addresses.
     */
    @objc public func FetchNFTsByCreatorAddresses(creators:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.FetchNFTsByCreatorAddresses(creators: creators, limit: limit, offset: offset) { data in
            onSuccess?(data)

        } onFailed: { code, message in
            onFailed?(code,message)

        }


    }
    
    
    /**
     * Get a collection of NFT by authority addresses.
     */
    @objc public func FetchNFTsByUpdateAuthorities(update_authorities:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.FetchNFTsByUpdateAuthorities(update_authorities: update_authorities, limit: limit, offset: offset) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }


    }

    
    /**
     *  Get a collection of NFT by mint addresses.
     *
     */
    @objc public func FetchNFTsByOwnerAddress(owners:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.FetchNFTsByOwnerAddress(owners: owners, limit: limit, offset: offset) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }
    }
    
    /**
     * Buy a NFT on market place.
     *
     */
    @objc public func BuyNFT(mint_address:String,price:Double,onSuccess:onSuccess,onFailed:onFailed){
        marketPlaceMoudle.BuyNFT(mint_address: mint_address, price: price){ data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }
    }

    
    @objc public func GetCollectionFilterInfo(collection:String,onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.GetCollectionFilterInfo(collection: collection) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    @objc public func GetNFTInfo(mint_address:String,onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.GetNFTInfo(mint_address: mint_address) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    
    
    @objc public func GetCollectionInfo(collections:[String],onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.GetCollectionInfo(collections: collections) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    @objc public func GetNFTEvents(mint_address: String, page: Int, page_size: Int,onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.GetNFTEvents(mint_address: mint_address, page: page, page_size: page_size) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }


    }
    
    @objc public func SearchNFTs(collections: [String], search: String,onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.SearchNFTs(collections: collections, search: search) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    @objc public func RecommentSearchNFT(collections: [String], onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.RecommentSearchNFT(collections: collections) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    
    @objc public func getNFTsByUnabridgedParams(collection: String, page: Int, page_size: Int, order: [String : Any], sale: Int, filter: [[String : Any]], onSuccess:onSuccess,onFailed:onFailed){
        
        metedataFilterMoudle.getNFTsByUnabridgedParams(collection: collection, page: page, page_size: page_size, order: order, sale: sale, filter: filter) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }


    }
    
    @objc public func GetNFTRealPrice(price: String, fee: Double, onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.GetNFTRealPrice(price: price, fee: fee) { data in
            onSuccess?(data)
        } onFailed: { code, message in
            onFailed?(code,message)
        }

    }
    
    @objc public func CreateNewCollection(collection: String, collection_name: String, collection_type: String, collection_orders: [Any], collection_filter: [[String : Any]], onSuccess:onSuccess,onFailed:onFailed){
        metedataFilterMoudle.CreateNewCollection(collection: collection, collection_name: collection_name, collection_type: collection_type, collection_orders: collection_orders, collection_filter: collection_filter) { data in
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
            self?.marketPlaceMoudle.authorization.callBackToken(uuid: uuid,token: token)
            self?.authMoudle.authorization.callBackToken(uuid: uuid,token: token)
            self?.walletMoudle.authorization.callBackToken(uuid: uuid,token: token)
            MirrorSecurityVerificationShared.share.authTokenCallBack(uuid: uuid, token: token)
            
            MirrorSecurityVerificationShared.share.ApproveCallBack(uuid: uuid, token: token)
        }
    }
}

public extension MirrorWorldSDK{
    @objc class func getBaseViewController() -> UIViewController?{
            return MirrorUIConfig().baseViewContoller
        }
}
