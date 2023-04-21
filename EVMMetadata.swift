//
//  MirrorMetadataFilterMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/12/14.
//

import UIKit

@objc public class EVMMetadata: MirrorBaseMoudle {
    var config:MirrorWorldSDKConfig?

    @objc public func getCollectionsInfo(collections:[String],onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Metadata, APIPath: "collections")
        let params = [
            "collections":collections
        ]as [String : Any]
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
    
    @objc public func getCollectionFilterInfo(collection:String,onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataCollection, APIPath: "filter_info?collection=\(collection)")
        MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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

    @objc public func getCollectionsSummary(collections:[String],onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataCollection, APIPath: "summary")
        let params = [
            "collections":collections
        ]as [String : Any]
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

    @objc public func getNFTInfo(contract:String,token_id:Int,onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataNFT, APIPath: "\(contract)/\(token_id)")
        MirrorWorldNetWork().request(url: url,method: "Get",params: nil) {[weak self] response in
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
    
    @objc public func getNFTs(contract: String,  sale: Int, page: Int, page_size: Int, order: [String : Any],marketplace_address:String,filter: [[String : Any]], onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.Metadata, APIPath: "nfts")
        let params = [
            "contract":contract,
            "sale":sale,
            "page":page,
            "page_size":page_size,
            "order":order,
            "marketplace_address":marketplace_address,
            "filter":filter
        ] as [String:Any]
        MirrorWorldNetWork().request(url:url,method: "Post", params: params) {[weak self] response in
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


    @objc public func getNFTEvents(contract: String, token_id: Int, page:Int, page_size: Int,marketplace_address:String,onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataNFT, APIPath: "events")
        let params = [
            "contract":contract,
            "token_id":token_id,
            "page":page,
            "page_size":page_size,
            "marketplace_address":marketplace_address
        ] as [String:Any]
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

    @objc public func searchNFTs(collections: [String], search: String,onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataNFT, APIPath: "search")
        let params = [
            "collections":collections,
            "search":search
        ] as [String:Any]
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
    
    @objc public func recommentSearchNFT(collections: [String], onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataNFTSearch, APIPath: "recommend")
        let params = [
            "collections":collections
        ] as [String:Any]
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
    
    @objc public func getMarketplaceEvents(marketplace_address: String,page:Int,page_size:Int, onSuccess:onSuccess,onFailed:onFailed){
        let url = MirrorUrlUtils.shard.getMirrorUrl(serviceEnum: MirrorService.MetadataNFTMarketplace, APIPath: "events")
        let params = [
            "marketplace_address":marketplace_address,
            "page":page,
            "page_size":page_size
        ] as [String:Any]
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
