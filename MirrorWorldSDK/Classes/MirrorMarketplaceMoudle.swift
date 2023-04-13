//
//  MirrorMarketplaceMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
//

import UIKit

@objc public class MirrorMarketplaceMoudle: MirrorBaseMoudle {
    
    var config:MirrorWorldSDKConfig?
    var newAuth:MirrorSecurityVerification?
    
    @objc public func buyNFT(mint_address:String,price:Double,auction_house:String,confirmation:String, skip_preflight:Bool,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            var params = [
                "mint_address":mint_address,
                "price":price,
                "auction_house":auction_house,
                "confirmation":confirmation,
                "skip_preflight":skip_preflight
            ]as [String : Any]
            let api = MirrorWorldNetApi.BuyNFT(mint_address: mint_address, price: price, auction_house:auction_house,confirmation: confirmation,skip_preflight:skip_preflight)
            self.authorization.requestActionAuthorization(config: self.config, params,actionType:MWActionType.buyNFT) { success, authToken, errorDesc in
                if success{
                    var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"buy")
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
    
    @objc public func cancelNFTListing(mint_address:String,price:Double,auction_house:String,confirmation:String,skip_preflight:Bool,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            var params = [
                "mint_address":mint_address,
                "price":price,
                "auction_house":auction_house,
                "confirmation":confirmation,
                "skip_preflight":skip_preflight
            ] as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config,params,actionType: MWActionType.cancelListing) { success, authToken, errorDesc in
                if success{
                    var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"cancel")
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
    
    @objc public func listNFT(mint_address:String,price:Double,auction_house:String,confirmation:String,skip_preflight:Bool,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            var params = [
                "mint_address":mint_address,
                "price":price,
                "auction_house":auction_house,
                "confirmation":confirmation,
                "skip_preflight":skip_preflight
            ] as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config, params,actionType: MWActionType.listNFT) { success, authToken,errorDes  in
                if success{
                    var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"list")
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
    
    @objc public func transferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String,skip_preflight:Bool,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            var params = [
                "mint_address":mint_address,
                "to_wallet_address":to_wallet_address,
                "confirmation":confirmation,
                "skip_preflight":skip_preflight
            ] as [String : Any]
            self.authorization.requestActionAuthorization(config: self.config, params,actionType: MWActionType.transferNFT) { success, authToken, errorDesc in
                if success{
                    var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetAuction,APIPath:"transfer")
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
    
    
    @objc public func checkTransactionsStatus(signatures:[String],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetConfirmation,APIPath:"transactions-status")
            var params = [
                "signatures":signatures
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
    
    @objc public func checkMintingStatus(mint_addresses:[String],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetConfirmation,APIPath:"mints-status")
            var params = [
                "mint_addresses":mint_addresses
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
    
    @objc public func mintCollection(url:String,name:String,symbol:String,to_wallet_address:String,seller_fee_basis_points:Int,confirmation:String,skip_preflight:Bool,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["name":name,
                     "symbol":symbol,
                     "url":url,
                     "confirmation":confirmation,
                     "seller_fee_basis_points":seller_fee_basis_points] as [String : Any]
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.MintNewCollection(param)
            self.authorization.requestActionAuthorization(config: self.config, param,actionType: MWActionType.createCollection) { success, authToken,errorDesc  in
                if succ{
                    var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"collection")
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
    
    @objc public func mintNFT(collection_mint:String,url:String,to_wallet_address:String,seller_fee_basis_points:Int,confirmation:String,skip_preflight:Bool,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["collection_mint":collection_mint,
                     "to_wallet_address":to_wallet_address,
                     "url":url,
                     "seller_fee_basis_points":seller_fee_basis_points,
                     "confirmation":confirmation,
                     "skip_preflight":skip_preflight
        ] as [String : Any]
        var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"nft")
        self.checkAccessToken {[weak self] succ in
            /// authToken
            let api = MirrorWorldNetApi.MintNewNFT(param)
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
    
    @objc public func UpdateNFTMetadata(mint_address:String,url:String,seller_fee_basis_points:String,name:String,symbol:String,updateAuthority:String,confirmation:String,skip_preflight:Bool,_ onReceive:((_ isSucc:Bool,_ data:String?)->Void)?){
        var params = [
            "mint_address":mint_address,
            "url":url,
            "name":name,
            "symbol":symbol,
            "updateAuthority":updateAuthority,
            "confirmation":confirmation,
            "skip_preflight":skip_preflight
        ] as [String : Any]
        self.checkAccessToken { succ in
            if(succ){
                self.authorization.requestActionAuthorization(config: self.config, params,actionType: MWActionType.updateNFT, { success, authToken, errorDesc in
                    if(success){
                        var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"collection")
                        MirrorWorldNetWork().request(url: url,method: "Post",params: params,authToken) { response in
                            self.handleResponse(response: response, success: { response in
                                onReceive?(true,response)
                            }, failed: { code, message in
                                onReceive?(false,"code:\(code),message:\(message)")
                            })
                        } _: { code, errorDesc in
                            onReceive?(false,"code:\(code),message:\(errorDesc)")
                        }
                    }else{
                        onReceive?(false,errorDesc)
                    }
                })
            }else{
                onReceive?(false,"No access token, please login first.")
            }
        }
    }
    
    @objc public func queryNFT(mint_Address:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
                var url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetNFT,APIPath:mint_Address)
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
    
    @objc public func SearchNFTs(mint_addresses:[String],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.AssetNFT, APIPath: "mints")
            var params = [
                "mint_address":mint_addresses
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

    @objc public func searchNFTsByOwner(owners:[String],limit:Int,offset:Int,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.AssetNFT, APIPath: "owners")
            var params = [
                "owners":owners,
                "limit":limit,
                "offset":offset
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
