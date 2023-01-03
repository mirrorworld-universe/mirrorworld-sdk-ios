//
//  MirrorMetadataFilterMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/12/14.
//

import UIKit

@objc public class MirrorMetadataFilterMoudle: MirrorBaseMoudle {
    var config:MirrorWorldSDKConfig?

    
    @objc public func GetCollectionFilterInfo(collection:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.GetCollectionFilterInfo(collection: collection)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    
    @objc public func GetNFTInfo(mint_address:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.GetNFTInfo(mint_address:mint_address)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    @objc public func GetCollectionInfo(collections:[String],onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.GetCollectionInfo(collections: collections)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    @objc public func GetNFTEvents(mint_address: String, page: Int, page_size: Int,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.GetNFTEvents(mint_address: mint_address, page: page, page_size: page_size)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    @objc public func SearchNFTs(collections: [String], search: String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.SearchNFTs(collections: collections, search: search)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    @objc public func RecommentSearchNFT(collections: [String], onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.RecommendSearchNFT(collections: collections)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    
    @objc public func GetNFTsByUnabridgedParams(collection: String, page: Int, page_size: Int, order: [String : Any], sale: Int, filter: [[String : Any]], onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.GetNFTs(collection: collection, page: page, page_size: page_size, order: order, sale: sale, filter: filter)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    @objc public func GetNFTRealPrice(price: String, fee: Double, onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.GetNFTRealPrice(price: price, fee: fee)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
    
    @objc public func CreateNewCollection(collection: String, collection_name: String, collection_type: String, collection_orders: [Any], collection_filter: [[String : Any]], onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.CreateNewCollection(collection: collection, collection_name: collection_name, collection_type: collection_type, collection_orders: collection_orders, collection_filter: collection_filter)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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
