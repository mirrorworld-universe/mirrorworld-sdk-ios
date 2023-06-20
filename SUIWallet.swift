//
//  SUIWallet.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/6/19.
//

import Foundation


@objc public class SUIWallet: MirrorBaseMoudle {
    
    var config:MirrorWorldSDKConfig?
    var newAuth:MirrorSecurityVerification?
    
    @objc public func getTransactionByDigest(digest:String, onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
                let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.Wallet,APIPath:"transactions/"+digest)
            MirrorWorldNetWork().request(url:url, method: "Get",params:nil) {[weak self] response in
                self?.handleResponse(response: response, success: { response in
                    onSuccess?(response)
                }, failed: { code, message in
                    onFailed?(code,message)
                })
            } _: { code, errorDesc in
                DispatchQueue.main.async {
                    onFailed?(code,errorDesc)
                }
            }
        }
    }
    
    @objc public func getTokens(onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
                let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.Wallet,APIPath:"tokens")
            MirrorWorldNetWork().request(url:url, method: "Get",params:nil) {[weak self] response in
                self?.handleResponse(response: response, success: { response in
                    onSuccess?(response)
                }, failed: { code, message in
                    onFailed?(code,message)
                })
            } _: { code, errorDesc in
                DispatchQueue.main.async {
                    onFailed?(code,errorDesc)
                }
            }
        }
    }
    
    
    @objc public func transferToken(to_publickey:String,amount:Int,token:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.Wallet,APIPath:"transfer-token")
            let params = [
                "to_publickey":to_publickey,
                "amount":amount,
                "token":token
            ] as [String : Any]
            MirrorWorldNetWork().request(url: url,method: "Post",params: params) {[weak self] response in
                self?.handleResponse(response: response, success: { response in
                    onSuccess?(response)
                }, failed: { code, message in
                    onFailed?(code,message)
                })
            } _: { code, errorDesc in
                DispatchQueue.main.async {
                    onFailed?(code,errorDesc)
                }
            }
        }
    }
    
    @objc public func transferSUI(to_publickey:String,amount:Int,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.Wallet,APIPath:"transfer-sui")
            let params = [
                "to_publickey":to_publickey,
                "amount":amount
            ] as [String : Any]
            MirrorWorldNetWork().request(url: url,method: "Post",params: params) {[weak self] response in
                self?.handleResponse(response: response, success: { response in
                    onSuccess?(response)
                }, failed: { code, message in
                    onFailed?(code,message)
                })
            } _: { code, errorDesc in
                DispatchQueue.main.async {
                    onFailed?(code,errorDesc)
                }
            }
        }
    }
}
