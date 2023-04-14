//
//  SolanaAPIView.swift
//  MirrorWorldSDK_Example
//
//  Created by squall on 2023/4/12.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import Foundation
import MirrorWorldSDK
class SolanaAPIView{
    
    var inited:Bool = false;
    var textView: UITextView!
    
    func Init(textView: UITextView!){
        self.textView = textView
        inited = true
    }
    
    func Log(_ info:String?){
        if self.textView.text.count > 5000{
            self.textView.text = ""
        }
        
        
        let t = info ?? ""
        var text = self.textView.text
        text?.append(t)
        text?.append("\n")
        self.textView.text = text
        self.textView.scrollRangeToVisible(NSRange(location: 0, length: text?.utf8.count ?? 0))
    }
    
    func onAPISelected(_ view:UIView, paramtersView:inputParamsView,loadingActive: UIActivityIndicatorView!, dataSource:[(moudleTitle: String, MethodList: [String])], tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(!inited){
            return
        }
        
        let item = dataSource[indexPath.section].MethodList[indexPath.row]
        self.Log("\n--------\(item):--------\n")
        
        loadingActive.startAnimating()
        
        switch item {
            //Authentication
        case "Start Login":
            MWSDK.startLogin { userInfo in
                loadingActive.stopAnimating()
                self.Log("login success :\(MirrorTool.dicToString(userInfo) ?? "")")
            } onFail: {
                loadingActive.stopAnimating()
                self.Log("login failed!")
            }
            
        case "Guest Login":
            MWSDK.GuestLogin {
                self.Log("guest login success")
            } onFail: {
                self.Log("guest login failed")
            }

        case "Logs out a user":
            MWSDK.Logout {
                self.Log("Logs out a user : success")
            } onFail: {
                self.Log("Logs out a user : failed")
            }
        case "CheckAuthenticated":
            MWSDK.isLogged { onBool in
                loadingActive.stopAnimating()
                self.Log("This device's login state is:\(onBool)")
            }
            break
        case "OpenWallet":
            MWSDK.openWallet {
                loadingActive.stopAnimating()
                self.Log("Wallet is logout")
                
            } loginSuccess: { userinfo in
                loadingActive.stopAnimating()
                self.Log("Wallet login: \(String(describing: userinfo))")
            }
            
            loadingActive.stopAnimating()
            break
        case "openMarketPlacePage":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.url])
            paramtersView.paramtersJson = {[weak self] datas in
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                MWSDK.openMarket(url: url)
                self?.Log("openMarketPlacePage")
            }
            break
        case "QueryUser":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.email])
            paramtersView.paramtersJson = {[weak self] datas in
                let email = (datas.first(where: {$0.keyText == "email"})?.valueText)! as! String
                
                MWSDK.QueryUser(email: email) { user in
                    self?.Log(user ?? "null")
                    loadingActive.stopAnimating()
                } onFetchFailed: { code, error in
                    self?.Log("\(code):\(String(describing: error))")
                }
            }
            
            
        case "GetAccessToken":
            MWSDK.GetAccessToken(callBack: { token in
                self.Log("Access Token is : \(token)")
                loadingActive.stopAnimating()
            })
            //Wallet
        case "Get wallet tokens":
            MWSDK.Solana.Wallet.getWalletTokens { response in
                
                let res = response?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                
                self.Log("Get wallet tokens:\(res ?? "null")")
                loadingActive.stopAnimating()
            } onFailed: {
                self.Log("Get wallet tokens: failed")
            }
            
        case "Get wallet transactions":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.limit,.next_before])
            paramtersView.paramtersJson = {[weak self] datas in
                let limit:Int = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! Int
                
                let next_before:String = (datas.first(where: {$0.keyText == "next_before"})?.valueText)! as! String
                
                
                MWSDK.Solana.Wallet.getWalletTransactions(limit: Int(limit) , next_before: next_before) { response in
                    self?.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item): failed ~")
                }
            }
            break
        case "Get wallet transaction by signature":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.signature])
            paramtersView.paramtersJson = {[weak self] datas in
                let signature:String = (datas.first(where: {$0.keyText == "signature"})?.valueText)! as! String
                MWSDK.Solana.Wallet.GetWalletTransactionBySignature(signature: signature) { response in
                    self?.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    loadingActive.stopAnimating()
                    self?.Log("\(item):failed~")
                }
            }
            break
        case "Transfer SOL to another address":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount])
            paramtersView.paramtersJson = {[weak self] datas in
                let to_publickey:String = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amount:Int = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! Int
                MWSDK.Solana.Wallet.transferSOL(to_publickey: to_publickey, amount: Int(amount) ) { response in
                    self?.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item):failed~")
                }
                
            }
            break
        case "Transfer Token to another address":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount,.token_mint,.decimals])
            paramtersView.paramtersJson = {[weak self] datas in
                let to_publickey:String = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amount:Int = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! Int
                let token_mint:String = (datas.first(where: {$0.keyText == "token_mint"})?.valueText)! as! String
                let decimals:Int = (datas.first(where: {$0.keyText == "decimals"})?.valueText)! as! Int
                
                MWSDK.Solana.Wallet.transferToken(to_publickey: to_publickey, amount: Int(Double(amount) ?? 0.0), token_mint: token_mint, decimals: Int(decimals) ?? 1) { response in
                    self?.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item):failed~")
                }
                
            }
            break
            //Asset
//        case "CheckStatusOfTransactions":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.signature,.another_signature])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let signature:String = (datas.first(where: {$0.keyText == "signature"})?.valueText)! as! String
//                let another_signature:String = (datas.first(where: {$0.keyText == "another signature"})?.valueText)! as! String
//                MWSDK.Solana.Asset.checkTransactionsStatus(signatures: [signature,another_signature]) { data in
//                    self?.Log(data)
//                } onFailed: { code, message in
//                    self?.Log("CheckStatusOfTransactions failed,code is:\(code);message:\(String(describing: message))")
//                }
//
//            }
//            break
//        case "MintNewCollection":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.name,.symbol,.url,.seller_fee_basis_points])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let name:String = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
//                let symbol:String = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
//                let url:String = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
//                let seller_fee_basis_points:Int = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! Int
//
//                MWSDK.Solana.Asset.mintNFT(name: name, symbol: symbol, url: url, seller_fee_basis_points: Int(seller_fee_basis_points) ?? 100, onSuccess: { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                }, onFailed: { code,message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                })
//            }
//            break
//        case "CreateVerifiedSubCollection":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.name,.collection_mint,.url,.symbol])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let name:String = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
//                let collection_mint:String = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
//                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
//                MWSDK.Solana.Asset.mintCollection(name: name, collection_mint: collection_mint, symbol: symbol, url: url) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//
//            }
//
//            break
//        case "MintNewNFT":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint,.name,.symbol,.url,.seller_fee_basis_points])
//            paramtersView.paramtersJson = {[weak self] datas in
//
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
//                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
//                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
//                let seller_fee_basis_points = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! String
//                //            5dw2PLdbTtn6sUHdNLy3EH4buPHh3Ch9JQTCoP9d6DwN
//                //            https://market-assets.mirrorworld.fun/gen1/1.json
//                MWSDK.MintNewNFT(collection_mint: collection_mint, name: name, symbol: symbol, url: url, seller_fee_basis_points: Int(seller_fee_basis_points) ?? 100) { data in
//
//                    self?.Log("mintNewNFT - response:\n")
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//            }
//            break
//        case "CheckStatusOfMinting":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.another_mint_address])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let another_address = (datas.first(where: {$0.keyText == "another_mint_address"})?.valueText)! as! String
//                MWSDK.CheckStatusOfMinting(mintAddress: [mint_address,another_address]) { isSucc, data in
//                    self?.Log("Check status of Minting result is:\(isSucc). data is:\(data)")
//                }
//            }
//            break
//        case "UpdateNFTProperties":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.name,.symbol,.update_authorities,.url,.seller_fee_basis_points,.confirmation])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mintAddress = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
//                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
//                let update_authority = (datas.first(where: {$0.keyText == "update_authorities"})?.valueText)! as! String
//                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
//                let sellerString = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! String
//                let confirmation = (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String
//
//                MWSDK.UpdateNFTProperties(mintAddresses: mintAddress,name:name,symbol:symbol,updateAuthority:update_authority,NFTJsonUrl: url,seller_fee_basis_points:sellerString,confirmation:confirmation) { data in
//                    self?.Log(data)
//                } _: { message in
//                    self?.Log(message)
//                }
//
//            }
//            break
//        case "FetchSingleNFT":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                MirrorWorldSDK.share.FetchSingleNFT(mint_Address: mint_address) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                }
//            }
//            break
//        case "UpdateNFTListing":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.price])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
//                MWSDK.UpdateNFTListing(mint_address: mint_address, price: Double(price) ?? 1.0) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                }
//            }
//
//
//            break
//
//        case "MintNewNFTOnCollection":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint,.name,.symbol,.url,.seller_fee_basis_points])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
//                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
//                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
//                let seller_fee_basis_points = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! String
//                MWSDK.MintNewNFT(collection_mint: collection_mint, name: name, symbol: symbol, url: url, seller_fee_basis_points: Int(seller_fee_basis_points) ?? 100, confirmation: "finalized") { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                }
//            }
//
//
//            break
//        case "ListNFT":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.price])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
//
//                MirrorWorldSDK.share.ListNFT(mint_address: mint_address, price: Double(price) ?? 0.1, confirmation: "finalized") { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//
//                }
//            }
//
//            break
//        case "CancelNFTListing":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.price])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
//                MWSDK.CancelNFTListing(mint_address: mint_address, price: Double(price) ?? 1.1) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//            }
//
//            break
//
//        case "BuyNFT":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.price])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
//                MWSDK.BuyNFT(mint_address: mint_address, price: Double(price) ?? 0.01) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//            }
//            break
//
//
//        case "FetchNFTsByMintAddresses":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//
//                var mint_address_arr:[String] = []
//                mint_address.split(separator: ",").forEach { subStr in
//                    mint_address_arr.append(String(subStr))
//                }
//                //                C1UuTyxQXGheoYCf1UGd7mv5Fbeo3siwpNY7WUTvNCxN
//                MWSDK.FetchNFTsByMintAddresses(mint_addresses: mint_address_arr) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//
//                }
//
//            }
//
//
//            break
//        case "FetchNFTsByUpdateAuthorities":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.update_authorities,.limit,.offset])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let update_authorities = (datas.first(where: {$0.keyText == "update_authorities"})?.valueText)! as! String
//                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
//                let offset = (datas.first(where: {$0.keyText == "offset"})?.valueText)! as! String
//
//                var update_authorities_arr:[String] = []
//                update_authorities.split(separator: ",").forEach { subStr in
//                    update_authorities_arr.append(String(subStr))
//                }
//
//                MWSDK.FetchNFTsByUpdateAuthorities(update_authorities: update_authorities_arr, limit: Double(limit) ?? 1.0, offset: Double(offset) ?? 0.1) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//            }
//
//
//
//            break
//        case "FetchNFTsByCreatorAddresses":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.creators,.limit,.offset])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let creators = (datas.first(where: {$0.keyText == "creators"})?.valueText)! as! String
//                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
//                let offset = (datas.first(where: {$0.keyText == "offset"})?.valueText)! as! String
//
//                var creatorsArr:[String] = []
//                creators.split(separator: ",").forEach { subStr in
//                    creatorsArr.append(String(subStr))
//                }
//                MWSDK.FetchNFTsByCreatorAddresses(creators: creatorsArr, limit: Double(limit) ?? 10.0, offset:Double(offset) ?? 0.1) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//            }
//
//            break
//        case "FetchNFTsByOwnerAddresses":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.owners,.limit,.offset])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let owners = (datas.first(where: {$0.keyText == "owners"})?.valueText)! as! String
//                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
//                let offset = (datas.first(where: {$0.keyText == "offset"})?.valueText)! as! String
//
//                var ownersArr:[String] = []
//                owners.split(separator: ",").forEach { subStr in
//                    ownersArr.append(String(subStr))
//                }
//                MWSDK.FetchNFTsByOwnerAddress(owners: ownersArr, limit: Double(limit) ?? 1, offset: Double(offset) ?? 0.1) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    loadingActive.stopAnimating()
//                }
//            }
//
//
//            break
//            //Metadata
//        case "Get collection filter info":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let collection = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                MWSDK.GetCollectionFilterInfo(collection: collection) {[weak self] data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: {[weak self] code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                }
//            }
//
//
//            break
//        case "Get nft info":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                MWSDK.GetNFTInfo(mint_address: mint_address) {[weak self] data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: {[weak self] code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//            }
//        case "Get collection info":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                MWSDK.GetCollectionInfo(collections: [collection_mint]) {[weak self] data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//
//                } onFailed: {[weak self] code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//            }
//
//
//            break
//        case "Get nft events":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.mint_address,.page,.page_size])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
//                let page = (datas.first(where: {$0.keyText == "page"})?.valueText)! as! String
//                let page_size = (datas.first(where: {$0.keyText == "page_size"})?.valueText)! as! String
//
//                MWSDK.GetNFTEvents(mint_address: mint_address, page: Int(page) ?? 0, page_size: Int(page_size) ?? 10) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//
//                } onFailed: { code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//
//
//
//            }
//            break
//        case "Search nfts":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint,.search])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                let search = (datas.first(where: {$0.keyText == "search"})?.valueText)! as! String
//
//                MWSDK.SearchNFTs(collections: [collection_mint], search: search) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//            }
//            break
//        case "Recommend search nft":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//
//                MWSDK.RecommentSearchNFT(collections: [collection_mint]) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//            }
//            break
//        case "GetNFTsByUnabridgedParams":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint,.page,.page_size,.sale])
//            paramtersView.paramtersJson = {[weak self] datas in
//
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                let page = (datas.first(where: {$0.keyText == "page"})?.valueText)! as! String
//                let page_size = (datas.first(where: {$0.keyText == "page_size"})?.valueText)! as! String
//                let sale = (datas.first(where: {$0.keyText == "sale"})?.valueText)! as! String
//
//
//                MWSDK.GetNFTsByUnabridgedParams(collection: collection_mint, page: Int(page) ?? 0, page_size: Int(page_size) ?? 10, order: ["order_by":"price","desc":true], sale: Int(sale) ?? 0, filter: [["filter_name" : "Rarity","filter_type":"enum","filter_value":["Common"]]]) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//
//            }
//
//            break
//        case "Get nft real price":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.fee,.price])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let fee = (datas.first(where: {$0.keyText == "fee"})?.valueText)! as! String
//                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
//
//                MWSDK.GetNFTRealPrice(price: price, fee: Double(fee) ?? 0) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//            }
//            break
//        case "Create new collection":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.collection_mint,.collection_name,.collection_type])
//            paramtersView.paramtersJson = {[weak self] datas in
//                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
//                let collection_name = (datas.first(where: {$0.keyText == "collection_name"})?.valueText)! as! String
//                let collection_type = (datas.first(where: {$0.keyText == "collection_type"})?.valueText)! as! String
//
//                MWSDK.CreateNewCollection(collection: collection_mint, collection_name: collection_name, collection_type: collection_type, collection_orders: [], collection_filter: [["filter_name" : "Background","filter_type":"enum","filter_value":["red","blue"]]]) { data in
//                    self?.Log(data)
//                    loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    loadingActive.stopAnimating()
//                    self?.Log("\(item):failed  code:\(code),message: \(message ?? "")")
//                }
//
//            }
//
//            break
//
        default:
            self.Log(item + " Coming soon.")
            loadingActive.stopAnimating()
            break

        }
    }
}
