

import UIKit

@objc public class EVMAsset: MirrorBaseMoudle {
    
    var config:MirrorWorldSDKConfig?
    var newAuth:MirrorSecurityVerification?
    
    @objc public func buyNFT(collection_address:String,token_id:Int, price:Double,marketplace_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let params = [
                "collection_address":collection_address,
                "token_id":token_id,
                "price":price,
                "marketplace_address":marketplace_address,
                "confirmation":confirmation
            ]as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config, params,actionType:MWActionType.buyNFT) { success, authToken, errorDesc in
                if success{
                    let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"buy")
                    MirrorWorldNetWork().request(url: url,method:"Post",params:params,authToken) {[weak self] response in
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
                }else{
                    DispatchQueue.main.async {
                        onFailed?(30001,errorDesc)
                    }
                }
            }
            
        }
    }
    
    @objc public func cancelNFTListing(collection_address:String,token_id:Int,marketplace_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let params = [
                "collection_address":collection_address,
                "token_id":token_id,
                "confirmation":confirmation,
                "marketplace_address":marketplace_address
            ] as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config,params,actionType: MWActionType.cancelListing) { success, authToken, errorDesc in
                if success{
                    let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"cancel")
                    MirrorWorldNetWork().request(url: url,method:"Post",params:params,authToken) {[weak self] response in
                        self?.handleResponse(response: response, success: { data in
                            onSuccess?(data)
                        }, failed: { code, message in
                            onFailed?(code,message)
                        })
                    } _: { code, errorDesc in
                        DispatchQueue.main.async {
                            onFailed?(code,errorDesc)
                        }
                    }
                }else{
                    onFailed?(30001,errorDesc)
                }
            }
        }
    }
    
    @objc public func listNFT(collection_address:String,token_id:Int,price:Double,marketplace_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let params = [
                "collection_address":collection_address,
                "token_id":token_id,
                "price":price,
                "marketplace_address":marketplace_address,
                "confirmation":confirmation
            ] as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config, params,actionType: MWActionType.listNFT) { success, authToken,errorDes  in
                if success{
                    let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"list")
                    MirrorWorldNetWork().request(url: url,method: "Post",params: params,authToken) {[weak self] response in
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
                }else{
                    DispatchQueue.main.async {
                        onFailed?(1,errorDes)
                    }
                }
            }
            
        }
    }
    
    @objc public func transferNFT(collection_address:String,token_id:Int,to_wallet_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let params = [
                "collection_address":collection_address,
                "to_wallet_address":to_wallet_address,
                "confirmation":confirmation,
                "token_id":token_id
            ] as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config, params,actionType: MWActionType.transferNFT) { success, authToken, errorDesc in
                if success{
                    let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"transfer")
                    MirrorWorldNetWork().request(url:url,method: "Post", params:params,authToken) {[weak self] response in
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
                }else{
                    onFailed?(30001,errorDesc)
                }
            }
            
        }
    }
    
    
    @objc public func mintCollection(url:String,name:String,symbol:String,contract_type:String,mint_start_id:Int,mint_end_id:Int,mint_amount:Int,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["name":name,
                     "symbol":symbol,
                     "url":url,
                     "confirmation":confirmation,
                     "contract_type":contract_type,
                     "mint_start_id":mint_start_id,
                     "mint_end_id":mint_end_id,
                     "mint_amount":mint_amount,
        ] as [String : Any]
        self.checkAccessToken { succ in
            self.authorization.requestActionAuthorization(config: self.config, param,actionType: MWActionType.createCollection) { success, authToken,errorDesc  in
                if succ{
                    let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"collection")
                    MirrorWorldNetWork().request(url:url,method:"Post", params:param,authToken) {[weak self] response in
                        self?.handleResponse(response: response, success: { data in
                            onSuccess?(data)
                        }, failed: { code, message in
                            onFailed?(code,message)
                        })
                    } _: { code, err in
                        DispatchQueue.main.async {
                            onFailed?(code,err)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        onFailed?(1,errorDesc)
                    }
                }
            }
            
        }
    }
    
    @objc public func mintNFT(collection_address:String,token_id:Int,to_wallet_address:String,mint_amount:Int,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["collection_address":collection_address,
                     "token_id":token_id,
                     "to_wallet_address":to_wallet_address,
                     "mint_amount":mint_amount,
                     "confirmation":confirmation
        ] as [String : Any]
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"nft")
        self.checkAccessToken {[weak self] succ in
            /// authToken
            self?.authorization.requestActionAuthorization(config: self?.config, param,actionType: MWActionType.mintNFT, { success, authToken,errorDesc  in
                MWLog.console("action authorization API:\(String(describing: authToken))")
                if succ {
                    MWLog.console("action authorization continue.")
                    MirrorWorldNetWork().request(url: url,method: "Post",params: param,authToken) {[weak self] response in
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
                }else{
                    DispatchQueue.main.async {
                        onFailed?(-1,errorDesc)
                    }
                }

            })
        }
    }
    
    @objc public func queryNFT(token_address:String,token_id:Int,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetNFT,APIPath: "\(token_address)/\(token_id)")
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
    
    /**
     tokens | object The list of tokens to be searched. List must be an array of json objects containing token_address and token_id
     token_address | string The address of the NFT collection
     token_id | string The token_id of the NFT
     */
    @objc public func searchNFTs(tokens:[[String:String]],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.AssetNFT, APIPath: "mints")
            let params = [
                "tokens":tokens
            ] as [String : Any]
            MirrorWorldNetWork().request(url: url,method: "Post",params:params) {[weak self] response in
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

    @objc public func searchNFTsByOwner(owner_address:[String],limit:Int,cursor:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.AssetNFT, APIPath: "owner")
            let params = [
                "owner_address":owner_address,
                "limit":limit,
                "cursor":cursor
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
