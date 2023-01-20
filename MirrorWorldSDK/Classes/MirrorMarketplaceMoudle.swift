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
    @objc public func openMarketPlacePage(url:String?,controller:UIViewController?){
        self.checkAccessToken { succ in
//            let urlString = self.config?.environment.marketRoot ?? ""
//            let marketPlaceAddress = urlString + "?auth=" + MirrorWorldSDKAuthData.share.access_token
            guard let urlString = url,urlString.count > 0 else {
                MWLog.console("please check marketplace address.")
                return
            }
            var marketPlaceAddress = ""
            if !urlString.contains("?auth="){
                marketPlaceAddress = urlString + "?auth=" + MirrorWorldSDKAuthData.share.access_token
            }else{
                marketPlaceAddress = urlString
            }
            guard let url = URL(string: marketPlaceAddress) else {
                MWLog.console(marketPlaceAddress)
                MWLog.console("please check your access_token.")
                return }
            let auth = MirrorWorldLoginAuthController.init(url: url)
            controller?.present(auth, animated: true)
        }
    }
    
    @objc public func MintNewCollection(name:String,symbol:String,url:String,confirmation:String,seller_fee_basis_points:Int,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["name":name,
                     "symbol":symbol,
                     "url":url,
                     "confirmation":confirmation,
                     "seller_fee_basis_points":seller_fee_basis_points] as [String : Any]
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.MintNewCollection(param)
            self.authorization.requestActionAuthorization(config: self.config, api) { success, authToken,errorDesc  in
                if succ{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
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
    
    @objc public func  CreateVerifiedSubCollection(name:String,collection_mint:String,symbol:String,url:String,_ confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
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
        

    }
    
    
    @objc public func FetchSingleNFT(mint_Address:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
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
    }
    
    
    @objc public func TransferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.TransferNFTToAnotherSolanaWallet(mint_address: mint_address, to_wallet_address: to_wallet_address, confirmation: confirmation)
            self.authorization.requestActionAuthorization(config: self.config, api) { success, authToken, errorDesc in
                if success{
                    print("TransferNFTToAnotherSolanaWallet authToken:\(authToken)")
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
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
    
    @objc public func MintNewNFT(collection_mint:String,name:String,symbol:String,url:String,seller_fee_basis_points:Int,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        let param = ["collection_mint":collection_mint,
                     "name":name,
                     "symbol":symbol,
                     "url":url,
                     "seller_fee_basis_points":seller_fee_basis_points,
                     "confirmation":confirmation] as [String : Any]
        self.checkAccessToken {[weak self] succ in
            /// authToken
            let api = MirrorWorldNetApi.MintNewNFT(param)
            self?.authorization.requestActionAuthorization(config: self?.config, api, { success, authToken,errorDesc  in
                MWLog.console("action authorization API:\(String(describing: authToken))")
                if succ {
                    MWLog.console("action authorization continue.")
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
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
           
            
//            let api = MirrorWorldNetApi.MintNewNFT(param)
//            MirrorWorldNetWork().request(api: api) {[weak self] response in
//                self?.handleResponse(response: response, success: { response in
//                    onSuccess?(response)
//                }, failed: { code, message in
//                      onFailed?(code,message)
//                })
//            } _: { code, errorDesc in
//                DispatchQueue.main.async {
//                    onFailed?(code,errorDesc)
//                }
//            }
        }
    }
    
    @objc public func CheckStatusOfMinting(mintAddress:[String],_ onReceive:((_ isSucc:Bool,_ data:String?)->Void)?){
        self.checkAccessToken { succ in
            if(succ){
                let api = MirrorWorldNetApi.CheckStatusOfMinting(mintAddress:mintAddress)
                MirrorWorldNetWork().request(api: api) {[weak self] response in
                    self?.handleResponse(response: response, success: { response in
                        onReceive?(true,response)
                    }, failed: { code, message in
                        onReceive?(false,nil)
                    })
                } _: { code, errorDesc in
                    DispatchQueue.main.async {
                        onReceive?(false,"code is :\(code); message is :\(errorDesc)")
                    }
                }
            }else{
                onReceive?(false,"")
            }
        }
    }
    
    @objc public func UpdateNFTProperties(mintAddresses:String,name:String,symbol:String,updateAuthority:String,NFTJsonUrl:String,seller_fee_basis_points:String,confirmation:String,_ onReceive:((_ isSucc:Bool,_ data:String?)->Void)?){
        self.checkAccessToken { succ in
            if(succ){
                let api = MirrorWorldNetApi.UpdateNFTProperties(mintAddress: mintAddresses, name: name, symbol: symbol, updateAuthority: updateAuthority, NFTJsonUrl: NFTJsonUrl, seller_fee_basis_points: seller_fee_basis_points, confirmation: confirmation)
                self.authorization.requestActionAuthorization(config: self.config, api, { success, authToken, errorDesc in
                    if(success){
                        MirrorWorldNetWork().request(api: api,authToken) { response in
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
    
    
    @objc public func ListNFT(mint_address:String,price:Double,confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.ListNFT(mint_address, price, confirmation)
            self.authorization.requestActionAuthorization(config: self.config, api) { success, authToken,errorDes  in
                if success{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
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
    
    
    @objc public func UpdateNFTListing(mint_address:String,price:Double, confirmation:String,onSuccess:onSuccess,onFailed:onFailed){
        
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.UpdateNFTListing(mint_address: mint_address, price: price, confirmation: confirmation)
            self.authorization.requestActionAuthorization(config: self.config, api) { success, authToken, errorDesc in
                if success{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
                        self?.handleResponse(response: response, success: { data in
                            onSuccess?(data)
                        }, failed: { code, message in
                            onFailed?(code,message)
                        })
                    } _: { code, errorDesc in
                        onFailed?(code,errorDesc)
                    }
                }else{
                    onFailed?(30001,errorDesc)
                }
            }
            
        }
       

    }
    
    
    @objc public func CancelNFTListing(mint_address:String,price:Double,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.cancelNFTListing(mint_address: mint_address, price: price)
            self.authorization.requestActionAuthorization(config: self.config, api) { success, authToken, errorDesc in
                if success{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
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

    
    @objc public func FetchNFTsByMintAddresses(mint_addresses:[String],onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.FetchNFTsByMintAddresses(mint_addresses: mint_addresses)
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
    
    
    
    @objc public func FetchNFTsByCreatorAddresses(creators:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
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
        

    }
        
    
    @objc public func FetchNFTsByUpdateAuthorities(update_authorities:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
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
        

    }

    @objc public func FetchNFTsByOwnerAddress(owners:[String],limit:Double,offset:Double,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
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
        

    }
    
    @objc public func BuyNFT(mint_address:String,price:Double,onSuccess:onSuccess,onFailed:onFailed){
        self.checkAccessToken { succ in
            let api = MirrorWorldNetApi.BuyNFT(mint_address: mint_address, price: price, confirmation: "finalized")
            self.authorization.requestActionAuthorization(config: self.config, api) { success, authToken, errorDesc in
                if success{
                    MirrorWorldNetWork().request(api: api,authToken) {[weak self] response in
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

    
    
    
}
