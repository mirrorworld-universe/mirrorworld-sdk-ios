//
//  MirrorWalletMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
//

import UIKit

@objc public class MirrorWalletMoudle: NSObject {
  
    var config:MirrorWorldSDKConfig?
    
    @objc public func openWallet(controller:UIViewController?){
        let walletUrl = config?.environment.mainRoot ?? ""
        guard walletUrl.count > 0 else { return }
        let url = URL(string: walletUrl)!
        let auth = MirrorWorldLoginAuthController.init(url: url)
        controller?.present(auth, animated: true)
    }
    
    @objc public func GetWalletTokens(onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        let api = MirrorWorldNetApi.getWalletTokens
        MirrorWorldNetWork().request(api: api) { response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let dataString = data?.toString()
            DispatchQueue.main.async {
                onSuccess?(dataString)
            }
        } _: { code,error in
            DispatchQueue.main.async {
                onFailed?()
            }
        }

    }
 
    
    @objc public func GetWalletTransactions(limit:Int,next_before:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        let api = MirrorWorldNetApi.getWalletTransactions(limit: limit, next_before: next_before)
        MirrorWorldNetWork().request(api: api) { response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let dataString = data?.toString()
            DispatchQueue.main.async {
                onSuccess?(dataString)
            }
        } _: { code,err in
            DispatchQueue.main.async {
                onFailed?()
            }
        }

    }
    
    
    
    @objc public func GetWalletTransactionBySignature(signature:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        let api = MirrorWorldNetApi.getWalletTransactionBySignature(signature: signature)
        MirrorWorldNetWork().request(api: api) { response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let dataString = data?.toString()
            DispatchQueue.main.async {
                onSuccess?(dataString)
            }
        } _: { code, err in
            DispatchQueue.main.async {
                onFailed?()
            }
        }

    }

    
    @objc func TransferSOLtoAnotherAddress(to_publickey:String,amount:Int,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        let api = MirrorWorldNetApi.TransferSOLtoAnotherAddress(to_publickey: to_publickey, amount: amount)
        MirrorWorldNetWork().request(api: api) { response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let dataString = data?.toString()
            DispatchQueue.main.async {
                onSuccess?(dataString)
            }
        } _: { code,error in
            DispatchQueue.main.async {
                onFailed?()
            }
        }

    }
    
    
    /**
     *
     *
     */
    @objc func TransferTokenToAnotherAddress(to_publickey:String,amount:Int,token_mint:String,decimals:Int,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        let api = MirrorWorldNetApi.TransferTokenToAnotherAddress(to_publickey: to_publickey, amount: amount, token_mint: token_mint, decimals: decimals)
        MirrorWorldNetWork().request(api: api) { response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let dataString = data?.toString()
            DispatchQueue.main.async {
                onSuccess?(dataString)
            }
        } _: { code,error in
            DispatchQueue.main.async {
                onFailed?()
            }
        }

    }
    
}
