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
        case "startLogin":
            MWSDK.startLogin { userInfo in
                loadingActive.stopAnimating()
                self.Log("login success :\(MirrorTool.dicToString(userInfo) ?? "")")
            } onFail: {
                loadingActive.stopAnimating()
                self.Log("login failed!")
            }
            
        case "loginWithEmail":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.email,.password])
            paramtersView.paramtersJson = {datas in
                let email = (datas.first(where: {$0.keyText == "email"})?.valueText)! as! String
                let password = (datas.first(where: {$0.keyText == "password"})?.valueText)! as! String
                
                MWSDK.loginWithEmail(email: email, passWord: password) {
                    loadingActive.stopAnimating()
                    self.Log("email login success")
                } onFail: {
                    loadingActive.stopAnimating()
                    self.Log("email login success")
                }
            }
        case "guestLogin":
            MWSDK.GuestLogin {
                self.Log("guest login success")
            } onFail: {
                self.Log("guest login failed")
            }

        case "logout":
            MWSDK.Logout {
                self.Log("Logs out a user : success")
            } onFail: {
                self.Log("Logs out a user : failed")
            }
        case "isLogged":
            MWSDK.isLogged { onBool in
                loadingActive.stopAnimating()
                self.Log("This device's login state is:\(onBool)")
            }
            break
            //Client APIs
        case "openWallet":
            MWSDK.openWallet {
                loadingActive.stopAnimating()
                self.Log("Wallet is logout")
                
            } loginSuccess: { userinfo in
                loadingActive.stopAnimating()
                self.Log("Wallet login: \(String(describing: userinfo))")
            }
            
            loadingActive.stopAnimating()
            break
        case "openMarket":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.url])
            paramtersView.paramtersJson = {datas in
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                MWSDK.openMarket(url: url)
                self.Log("openMarketPlacePage")
            }
            break
        case "queryUser":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.email])
            paramtersView.paramtersJson = {datas in
                let email = (datas.first(where: {$0.keyText == "email"})?.valueText)! as! String
                
                MWSDK.QueryUser(email: email) { user in
                    self.Log(user ?? "null")
                    loadingActive.stopAnimating()
                } onFetchFailed: { code, error in
                    self.Log("\(code):\(String(describing: error))")
                }
            }
            //???
        case "GetAccessToken":
            MWSDK.GetAccessToken(callBack: { token in
                self.Log("Access Token is : \(token)")
                loadingActive.stopAnimating()
            })
            //Wallet
        case "getTokens":
            MWSDK.Solana.Wallet.getTokens { response in
                
                let res = response?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                
                self.Log("Get wallet tokens:\(res ?? "null")")
                loadingActive.stopAnimating()
            } onFailed: {
                self.Log("Get wallet tokens: failed")
            }
            break
        case "getTokensByWallet":
                view.addSubview(paramtersView)
                paramtersView.setParams(keys: [.to_wallet_address])
                paramtersView.paramtersJson = {datas in
                    let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                    
                    
                    MWSDK.Solana.Wallet.getTokensByWallet(wallet_address: to_wallet_address) { response in
                        self.Log("success, result is:\(String(describing: response))")
                        loadingActive.stopAnimating()
                    } onFailed: {
                        self.Log("\(item): failed ~")
                    }
                }
                break
        case "getTransactions":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.limit,.next_before])
            paramtersView.paramtersJson = {datas in
                let someString = datas.first(where: {$0.keyText == "limit"})?.valueText
                print("getTransactions input limit: \(String(describing: someString))")
                let formatter = NumberFormatter()
                let limit:Int = formatter.number(from: someString as! String) as! Int
                
                let next_before:String = (datas.first(where: {$0.keyText == "next_before"})?.valueText)! as! String
                
                
                MWSDK.Solana.Wallet.getTransactions(limit: Int(limit) , next_before: next_before) { response in
                    self.Log("success, result is:\(String(describing: response))")
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item): failed ~")
                }
            }
            break
        case "getTransactionsByWallet":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_wallet_address,.limit,.next_before])
            paramtersView.paramtersJson = {datas in
                let wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                let limit:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "limit"})?.valueText) as! String)
                let next_before:String = (datas.first(where: {$0.keyText == "next_before"})?.valueText)! as! String
                MWSDK.Solana.Wallet.getTransactionsByWallet(wallet_address:wallet_address, limit: limit, next_before: next_before){ response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed~")
                }
            }
            break
        case "getTransactionBySignature":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.signature])
            paramtersView.paramtersJson = {datas in
                let signature:String = (datas.first(where: {$0.keyText == "signature"})?.valueText)! as! String
                MWSDK.Solana.Wallet.getTransactionBySignature(signature: signature) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed~")
                }
            }
            break
        case "transferSOL":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount])
            paramtersView.paramtersJson = {datas in
                let to_publickey:String = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amount:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "amount"})?.valueText) as! String)
                MWSDK.Solana.Wallet.transferSOL(to_publickey: to_publickey, amount: Int(amount) ) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item):failed~")
                }
                
            }
            break
        case "transferToken":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount,.token_mint,.decimals])
            paramtersView.paramtersJson = {datas in
                let to_publickey:String = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amount:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String)
                let token_mint:String = (datas.first(where: {$0.keyText == "token_mint"})?.valueText)! as! String
                let decimals:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "decimals"})?.valueText)! as! String)
                
                MWSDK.Solana.Wallet.transferToken(to_publickey: to_publickey, amount: Int(Double(amount) ?? 0.0), token_mint: token_mint, decimals: Int(decimals) ?? 1) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item):failed~")
                }
                
            }
            break
            ///Asset
        case "buyNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price,.auction_house,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let price:Double = MirrorTool.getInputDouble((datas.first(where: {$0.keyText == "price"})?.valueText)! as! String)
                let auction_house:String = (datas.first(where: {$0.keyText == "auction_house"})?.valueText)! as! String
                                let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false
                MWSDK.Solana.Asset.buyNFT(mint_address: mint_address, price: Double(price) ?? 0.01,auction_house: auction_house,confirmation: confirmation,skip_preflight: skip_preflight) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                }
            }
            break
        case "cancelNFTListing":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price,.auction_house,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in
                
                    let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                    let price:Double = MirrorTool.getInputDouble((datas.first(where: {$0.keyText == "price"})?.valueText)! as! String)
                    let auction_house:String = (datas.first(where: {$0.keyText == "auction_house"})?.valueText)! as! String
                                    let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                    let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false
                
                MWSDK.Solana.Asset.cancelNFTListing(mint_address: mint_address, price: Double(price) ?? 1.1,auction_house: auction_house,confirmation: confirmation,skip_preflight: skip_preflight) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                }
            }

            break
        case "listNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price,.auction_house,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let price:Double = MirrorTool.getInputDouble((datas.first(where: {$0.keyText == "price"})?.valueText)! as! String)
                let auction_house:String = (datas.first(where: {$0.keyText == "auction_house"})?.valueText)! as! String
                                let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false
                MWSDK.Solana.Asset.listNFT(mint_address: mint_address, price: Double(price) ?? 0.1,auction_house: auction_house, confirmation: "finalized",skip_preflight: skip_preflight) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()

                }
            }

            break
        case "transferNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.to_wallet_address,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                                let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false
                MWSDK.Solana.Asset.transferNFT(mint_address: mint_address, to_wallet_address: to_wallet_address, confirmation: confirmation, skip_preflight: skip_preflight,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()

                })
            }

            break
            ///Asset/Confirmation
        case "checkTransactionsStatus":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.signature,.another_signature])
            paramtersView.paramtersJson = {datas in
                let signature:String = (datas.first(where: {$0.keyText == "signature"})?.valueText)! as! String
                let another_signature:String = (datas.first(where: {$0.keyText == "another signature"})?.valueText)! as! String
                MWSDK.Solana.Asset.checkTransactionsStatus(signatures: [signature,another_signature]) { data in
                    self.Log(data)
                } onFailed: { code, message in
                    self.Log("CheckStatusOfTransactions failed,code is:\(code);message:\(String(describing: message))")
                }
            }
            break
        case "checkMintingStatus":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.another_mint_address])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let another_address:String = (datas.first(where: {$0.keyText == "another_mint_address"})?.valueText)! as! String
                MWSDK.Solana.Asset.checkMintingStatus(mint_addresses: [mint_address,another_address],onSuccess: { data in
                    self.Log("Check status of Minting result is:\(String(describing: data))")
                },onFailed:{ code,errorDesc in
                    self.Log("Check status of Minting error(\(code)),desc is:\(String(describing: errorDesc))")
                })
            }
            break
            ///Asset/Mint
        case "mintCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.url,.name,.symbol,.to_wallet_address,.seller_fee_basis_points,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in
                let url:String = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let name:String = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol:String = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                let seller_fee_basis_points:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText) as! String)
                let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false

                MWSDK.Solana.Asset.mintCollection(url:url,name: name, symbol: symbol, to_wallet_address: to_wallet_address, seller_fee_basis_points: Int(seller_fee_basis_points) ,confirmation:confirmation,skip_preflight:skip_preflight, onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                }, onFailed: { code,message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                })
            }
            break
        case "mintNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint,.name,.symbol,.url,.to_wallet_address,.seller_fee_basis_points,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in

                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                let seller_fee_basis_points:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText) as! String)
                                let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false
                MWSDK.Solana.Asset.mintNFT(collection_mint: collection_mint, url: url, to_wallet_address: to_wallet_address, seller_fee_basis_points: seller_fee_basis_points, confirmation: confirmation, skip_preflight: skip_preflight){ data in

                    self.Log("mintNewNFT - response:\n")
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                }
            }
            break
        
        case "updateNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.name,.symbol,.update_authorities,.url,.seller_fee_basis_points,.confirmation,.skip_preflight])
            paramtersView.paramtersJson = {datas in
                let mintAddress:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let name:String = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol:String = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let update_authority:String = (datas.first(where: {$0.keyText == "update_authorities"})?.valueText)! as! String
                let url:String = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let seller_fee_basis_points:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText) as! String)
                                let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let skip_preflight = datas.first(where: { $0.keyText == "skip_preflight" }).flatMap { $0.valueText as? Bool } ?? false

                MWSDK.Solana.Asset.updateNFT(mint_address: mintAddress, url: url, seller_fee_basis_points: seller_fee_basis_points, name: name, symbol: symbol, updateAuthority: update_authority, confirmation: confirmation, skip_preflight: skip_preflight)
                { isSucc,data in
                    self.Log("result:\(isSucc),data is:\(data)")
                }
            }
            break
        case "queryNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                MWSDK.Solana.Asset.queryNFT(mint_Address: mint_address) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            break
        case "searchNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                var mint_address_arr:[String] = []
                mint_address.split(separator: ",").forEach { subStr in
                    mint_address_arr.append(String(subStr))
                }
                MWSDK.Solana.Asset.searchNFTs(mint_addresses: mint_address_arr) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()

                }
            }
            break
        case "searchNFTsByOwner":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.owners,.limit,.offset])
            paramtersView.paramtersJson = {datas in
                let owners = (datas.first(where: {$0.keyText == "owners"})?.valueText)! as! String
                let limit:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "limit"})?.valueText) as! String)
                let offset:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "offset"})?.valueText) as! String)

                var ownersArr:[String] = []
                owners.split(separator: ",").forEach { subStr in
                    ownersArr.append(String(subStr))
                }
                MWSDK.Solana.Asset.searchNFTsByOwner(owners: ownersArr, limit: limit , offset: offset ) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                }
            }
            break
            //Metadata
        case "getCollectionsInfo":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint])
            paramtersView.paramtersJson = {datas in
                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                MWSDK.Solana.Metadata.getCollectionsInfo(collections: [collection_mint]) {data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                } onFailed: {code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
            break
        case "getCollectionFilterInfo":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint])
            paramtersView.paramtersJson = {datas in
                let collection = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                MWSDK.Solana.Metadata.getCollectionFilterInfo(collection: collection) {data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: {code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            break
        case "getCollectionsSummary":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint])
            paramtersView.paramtersJson = {datas in
                let collection = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                MWSDK.Solana.Metadata.getCollectionsSummary(collections: [collection]) {data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: {code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            break
        case "getNFTInfo":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address])
            paramtersView.paramtersJson = {datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                MWSDK.Solana.Metadata.getNFTInfo(mint_address: mint_address) {data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: {code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
        case "getNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint,.sale,.page,.page_size,.auction_house])
            paramtersView.paramtersJson = {datas in

                let collection_mint:String = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let auction_house:String = (datas.first(where: {$0.keyText == "auction_house"})?.valueText)! as! String
                let page:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page"})?.valueText) as! String)
                let page_size:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page_size"})?.valueText) as! String)
                let sale:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "sale"})?.valueText) as! String)


                MWSDK.Solana.Metadata.getNFTs(collection: collection_mint, sale: sale, page: page, page_size: page_size, order: ["order_by":"price","desc":true], auction_house: auction_house, filter: [["filter_name" : "Rarity","filter_type":"enum","filter_value":["Common"]]]){ data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }

            }
            break
        case "getNFTEvents":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.page,.page_size])
            paramtersView.paramtersJson = {datas in
                let mint_address:String = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let page:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page"})?.valueText) as! String)
                let page_size:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page_size"})?.valueText) as! String)

                MWSDK.Solana.Metadata.getNFTEvents(mint_address: mint_address, page: page, page_size: page_size) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
            break
        case "searchNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint,.search])
            paramtersView.paramtersJson = {datas in
                let collection_mint:String = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let search:String = (datas.first(where: {$0.keyText == "search"})?.valueText)! as! String

                MWSDK.Solana.Metadata.searchNFTs(collections: [collection_mint], search: search) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
            break
        case "recommentSearchNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint])
            paramtersView.paramtersJson = {datas in
                let collection_mint:String = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                MWSDK.Solana.Metadata.recommentSearchNFT(collections: [collection_mint]) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
            break
        default:
            self.Log(item + " Coming soon.")
            loadingActive.stopAnimating()
            break

        }
    }
}
