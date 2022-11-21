//
//  MirrorMarketplaceMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
//

import UIKit

@objc public class MirrorMarketplaceMoudle: MirrorBaseMoudle {
    
    var config:MirrorWorldSDKConfig?

    @objc public func MintNewCollection(name:String,symbol:String,url:String,confirmation:String,seller_fee_basis_points:Int,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["name":name,
                     "symbol":symbol,
                     "url":url,
                     "confirmation":confirmation,
                     "seller_fee_basis_points":seller_fee_basis_points] as [String : Any]
        let api = MirrorWorldNetApi.MintNewCollection(param)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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

    }
    
    @objc public func  CreateVerifiedSubCollection(name:String,collection_mint:String,symbol:String,url:String,_ confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.CreateVerifiedSubCollection(name: name, collection_mint: collection_mint, symbol: symbol, url: url, confirmation: confirmation)
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
    
    
    @objc public func FetchSingleNFT(mint_Address:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.FetchSingleNFT(mint_Address)
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
    
    
    @objc public func TransferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.TransferNFTToAnotherSolanaWallet(mint_address: mint_address, to_wallet_address: to_wallet_address, confirmation: confirmation)
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
    
    @objc public func MintNewNFT(collection_mint:String,name:String,symbol:String,url:String,seller_fee_basis_points:Int,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["collection_mint":collection_mint,
                     "name":name,
                     "symbol":symbol,
                     "url":url,
                     "seller_fee_basis_points":seller_fee_basis_points,
                     "confirmation":confirmation] as [String : Any]
        
        let api = MirrorWorldNetApi.MintNewNFT(param)
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
    
    
    @objc public func ListNFT(mint_address:String,price:Double,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.ListNFT(mint_address, price, confirmation)
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
    
    
    @objc public func UpdateNFTListing(mint_address:String,price:Double, confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.UpdateNFTListing(mint_address: mint_address, price: price, confirmation: confirmation)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
            self?.handleResponse(response: response, success: { data in
                onSuccess?(data)
            }, failed: { code, message in
                onFailed?(code,message)
            })
        } _: { code, errorDesc in
            
        }

    }
    
    
    @objc public func CancelNFTListing(mint_address:String,price:Double,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.cancelNFTListing(mint_address: mint_address, price: price)
        MirrorWorldNetWork().request(api: api) {[weak self] response in
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

    }

    
    @objc public func FetchNFTsByMintAddresses(mint_address:String,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.FetchNFTsByMintAddresses(mint_address: mint_address)
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
    
    
    
    @objc public func FetchNFTsByCreatorAddresses(creators:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.FetchNFTsByCreatorAddresses(creators: creators, limit: limit, offset: offset)
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
        
    
    @objc public func FetchNFTsByUpdateAuthorities(update_authorities:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.FetchNFTsByUpdateAuthorities(update_authorities: update_authorities, limit: limit, offset: offset)
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

    @objc public func FetchNFTsByOwnerAddress(owners:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.FetchNFTsByOwnerAddress(owners: owners, limit: limit, offset: offset)
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
    
    @objc public func BuyNFT(mint_address:String,price:Double,onSuccess:onSuccess,onFailed:onFailed){
        let api = MirrorWorldNetApi.BuyNFT(mint_address: mint_address, price: price, confirmation: "finalized")
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