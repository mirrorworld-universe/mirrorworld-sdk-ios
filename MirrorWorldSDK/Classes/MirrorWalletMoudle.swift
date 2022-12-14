//
//  MirrorWalletMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
//

import UIKit

@objc public class MirrorWalletMoudle: MirrorBaseMoudle {
  
    var config:MirrorWorldSDKConfig?
    
    @objc public func openWallet(controller:UIViewController?){
       
        self.checkAccessToken {[weak self] succ in
            var walletUrl = (self?.config?.environment.mainRoot ?? "")
            if succ{
                walletUrl = (self?.config?.environment.mainRoot ?? "") + "jwt?key=" + MirrorWorldSDKAuthData.share.access_token
            }else{
                walletUrl = (self?.config?.environment.mainRoot ?? "")
            }
            guard walletUrl.count > 0 else { return }
            let url = URL(string: walletUrl)!
            let auth = MirrorWorldLoginAuthController.init(url: url)
            controller?.present(auth, animated: true)
        }
    }
    
    // for unitySDK
    @objc public func mw_Unity_Wallet(url: String?,controller:UIViewController?){
        self.checkAccessToken { succ in
            var walletUrl = url ?? ""
            guard walletUrl.count > 0 else { return }
            let url = URL(string: walletUrl)!
            let auth = MirrorWorldLoginAuthController.init(url: url)
            controller?.present(auth, animated: true)
        }
    }
    
    @objc public func GetWalletTokens(onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.getWalletTokens
            MirrorWorldNetWork().request(api: api) {[weak self] response in
                self?.handleResponse(response: response) { data in
                    onSuccess?(data)
                } failed: { code, message in
                    onFailed?()
                }

            } _: { code,error in
                DispatchQueue.main.async {
                    onFailed?()
                }
            }
        }
        

    }
 
    
    @objc public func GetWalletTransactions(limit:Int,next_before:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.getWalletTransactions(limit: limit, next_before: next_before)
            MirrorWorldNetWork().request(api: api) {[weak self] response in
                self?.handleResponse(response: response) { data in
                    onSuccess?(data)
                } failed: { code, message in
                    onFailed?()
                }
            } _: { code,err in
                DispatchQueue.main.async {
                    onFailed?()
                }
            }
        }
       

    }
    
    
    
    @objc public func GetWalletTransactionBySignature(signature:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.getWalletTransactionBySignature(signature: signature)
            MirrorWorldNetWork().request(api: api) {[weak self] response in
                self?.handleResponse(response: response) { data in
                    onSuccess?(data)
                } failed: { code, message in
                    onFailed?()
                }
            } _: { code, err in
                DispatchQueue.main.async {
                    onFailed?()
                }
            }
        }
        

    }

    
    @objc func TransferSOLtoAnotherAddress(to_publickey:String,amount:Int,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken {[weak self] succ in
            let api = MirrorWorldNetApi.TransferSOLtoAnotherAddress(to_publickey: to_publickey, amount: amount)
            self?.authorization.requestActionAuthorization(config: self?.config, api, { success,authToken,errorDesc in
                if success{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
                        self?.handleResponse(response: response) { res in
                            onSuccess?(res)
                        } failed: { code, message in
                            onFailed?()
                        }
                    } _: { code,error in
                        DispatchQueue.main.async {
                            onFailed?()
                        }
                    }
                }
            })
           
        }
        

    }
    
    
    /**
     *
     *
     */
    @objc func TransferTokenToAnotherAddress(to_publickey:String,amount:Int,token_mint:String,decimals:Int,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken {[weak self] succ in
            let api = MirrorWorldNetApi.TransferTokenToAnotherAddress(to_publickey: to_publickey, amount: amount, token_mint: token_mint, decimals: decimals)
            self?.authorization.requestActionAuthorization(config: self?.config, api, { success, authToken,errorDesc in
                if success{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
                        self?.handleResponse(response: response) { res in
                            onSuccess?(res)
                        } failed: { code, message in
                            onFailed?()
                        }
                    } _: { code,error in
                        DispatchQueue.main.async {
                            onFailed?()
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        onFailed?()
                    }
                }
            })
            
        }
       

    }
    
}
