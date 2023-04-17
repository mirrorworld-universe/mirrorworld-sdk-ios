//
//  MirrorWalletMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
//

import UIKit

@objc public class EVMWallet: MirrorBaseMoudle {
  
    var config:MirrorWorldSDKConfig?
    
    @objc public func getWalletTransactions(limit:Int, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "transactions?limit=\(limit)")
            MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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

    @objc public func getWalletTransactionByWallet(wallet_address:String, limit:Int, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "\(wallet_address)/transactions?limit=\(limit)")
            MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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
    
    @objc public func getWalletTransactionBySignature(signature:String, onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "transactions/\(signature)")
            MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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
    
    @objc public func getWalletTokens(onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "tokens")
            MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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
    
    @objc public func getWalletTokensByWallet(wallet_address:String,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "tokens/\(wallet_address)")
            MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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
    @objc public func transferETH(nonce:String,gasPrice:String,gasLimit:String,to:String,amount:String,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken {[weak self] succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "transfer-eth")
            let params = [
                "nonce":nonce,
                "gasPrice":gasPrice,
                "gasLimit":gasLimit,
                "to":to,
                "amount":amount,
            ]as [String : Any]
            self?.authorization.requestActionAuthorization(config: self?.config,params, actionType:MWActionType.transferSOL,{ success,authToken,errorDesc in
                if success{
                    MirrorWorldNetWork().request(url: url,method:"Post",params:params,authToken) {[weak self] response in
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
    @objc public func transferToken(nonce:String,gasPrice:String,gasLimit:String,to:String,amount:String,contract:String,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken {[weak self] succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "transfer-token")
            let params = [
                "nonce":nonce,
                "gasPrice":gasPrice,
                "to":to,
                "amount":amount,
                "contract":contract
            ]as [String : Any]
            self?.authorization.requestActionAuthorization(config: self?.config, params,actionType: MWActionType.transferSPLToken, { success, authToken,errorDesc in
                if success{
                    MirrorWorldNetWork().request(url: url,method: "Post",params: params,authToken) {[weak self] response in
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
    
    @objc public func transferBNB(nonce:String,gasPrice:String,gasLimit:String,to:String,amount:String,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken {[weak self] succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "transfer-bnb")
            let params = [
                "nonce":nonce,
                "gasPrice":gasPrice,
                "gasLimit":gasLimit,
                "to":to,
                "amount":amount,
            ]as [String : Any]
            self?.authorization.requestActionAuthorization(config: self?.config,params, actionType:MWActionType.transferSOL,{ success,authToken,errorDesc in
                if success{
                    MirrorWorldNetWork().request(url: url,method:"Post",params:params,authToken) {[weak self] response in
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
    
    @objc public func transferMatic(nonce:String,gasPrice:String,gasLimit:String,to:String,amount:String,onSuccess:((_ data:String?)->())?,onFailed:(()->())?){
        self.checkAccessToken {[weak self] succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Wallet, APIPath: "transfer-matic")
            let params = [
                "nonce":nonce,
                "gasPrice":gasPrice,
                "gasLimit":gasLimit,
                "to":to,
                "amount":amount,
            ]as [String : Any]
            self?.authorization.requestActionAuthorization(config: self?.config,params, actionType:MWActionType.transferSOL,{ success,authToken,errorDesc in
                if success{
                    MirrorWorldNetWork().request(url: url,method:"Post",params:params,authToken) {[weak self] response in
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
}
