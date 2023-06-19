//
//  SUIAsset.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/6/19.
//

import Foundation


@objc public class SUIAsset: MirrorBaseMoudle {
    
    var config:MirrorWorldSDKConfig?
    var newAuth:MirrorSecurityVerification?
    
    @objc public func getMintedCollection(onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
                let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"get-collections")
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

    
    @objc public func getMintedNFTsOnCollection(collection_address:String, onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
                let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetMint,APIPath:"get-collection-nfts/"+collection_address)
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
    
    
    @objc public func mintCollection(name:String,symbol:String,description:String,creators:[String],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetConfirmation,APIPath:"transactions-status")
            let params = [
                "name":name,
                "symbol":symbol,
                "description":description,
                "creators":creators
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
    
    
    @objc public func mintNFT(collection_address:String,name:String,image_url:String,attributes:Any,description:String,to_wallet_address:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetConfirmation,APIPath:"transactions-status")
            let params = [
                "collection_address":collection_address,
                "name":name,
                "image_url":description,
                "attributes":attributes,
                "description":description,
                "to_wallet_address":to_wallet_address
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
    
    
    @objc public func queryNFT(nft_object_id:String, onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
                let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetNFT,APIPath:nft_object_id)
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
    
    
    @objc public func searchNFTsByOwner(owner_address:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetNFT,APIPath:owner_address)
            let params = [
                "owner_address":owner_address
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
    
    
    @objc public func searchNFTs(nft_object_ids:[String],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum:MirrorService.AssetNFT,APIPath:"mints")
            let params = [
                "nft_object_ids":nft_object_ids
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
