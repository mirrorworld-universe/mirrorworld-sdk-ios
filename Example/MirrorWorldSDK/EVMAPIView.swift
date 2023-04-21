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
class EVMAPIView{
    
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
        case "getTransactions":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.limit])
            paramtersView.paramtersJson = {datas in
                let limit:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "limit"})?.valueText) as! String)
                MWSDK.EVM.Wallet.getTransactions(limit: Int(limit)) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item): failed ~")
                }
            }
            break
        case "getTransactionBySignature":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.signature])
            paramtersView.paramtersJson = {datas in
                let signature:String = (datas.first(where: {$0.keyText == "signature"})?.valueText)! as! String
                MWSDK.EVM.Wallet.getTransactionBySignature(signature: signature) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed~")
                }
            }
            break
            
        case "transferETH":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.nonce,.gasPrice,.gasLimit,.to,.amount])
            paramtersView.paramtersJson = {datas in
                let nonce:String = (datas.first(where: {$0.keyText == "nonce"})?.valueText)! as! String
                let gasPrice:String = (datas.first(where: {$0.keyText == "gasPrice"})?.valueText)! as! String
                let gasLimit:String = (datas.first(where: {$0.keyText == "gasLimit"})?.valueText)! as! String
                let to:String = (datas.first(where: {$0.keyText == "to"})?.valueText)! as! String
                let amount:String = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                MWSDK.EVM.Wallet.transferETH(nonce: nonce, gasPrice: gasPrice,gasLimit: gasLimit,to: to,amount: amount ) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item):failed~")
                }
            }
            break
        case "transferToken":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.nonce,.gasPrice,.gasLimit,.to,.amount,.contract])
            paramtersView.paramtersJson = {datas in
                let nonce:String = (datas.first(where: {$0.keyText == "nonce"})?.valueText)! as! String
                let gasPrice:String = (datas.first(where: {$0.keyText == "gasPrice"})?.valueText)! as! String
                let gasLimit:String = (datas.first(where: {$0.keyText == "gasLimit"})?.valueText)! as! String
                let to:String = (datas.first(where: {$0.keyText == "to"})?.valueText)! as! String
                let amount:String = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                let contract:String = (datas.first(where: {$0.keyText == "contract"})?.valueText)! as! String
                
                MWSDK.EVM.Wallet.transferToken(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: to,amount: amount,contract: contract) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item):failed~")
                }
            }
            break
            
        case "getTokens":
            MWSDK.EVM.Wallet.getTokens { response in
                let res = response?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                
                self.Log("Get wallet tokens:\(res ?? "null")")
                loadingActive.stopAnimating()
            } onFailed: {
                self.Log("Get wallet tokens: failed")
            }
//        case "getTokensByWallet":
//            view.addSubview(paramtersView)
//            paramtersView.setParams(keys: [.to_wallet_address])
//            paramtersView.paramtersJson = {datas in
//                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
//
//                MWSDK.EVM.Wallet.getTokensByWallet(wallet_address: to_wallet_address) { response in
//                    self.Log(response)
//                    loadingActive.stopAnimating()
//                } onFailed: {
//                    self.Log("\(item):failed~")
//                }
//            }
        case "getTransactionByWallet":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_wallet_address,.limit])
            paramtersView.paramtersJson = {datas in
                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                let limit:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "limit"})?.valueText) as! String)
                
                MWSDK.EVM.Wallet.getTransactionsByWallet(wallet_address: to_wallet_address, limit: limit) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item):failed~")
                }
            }
            
        case "transferMatic":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.nonce,.gasPrice,.gasLimit,.to,.amount])
            paramtersView.paramtersJson = {datas in
                let nonce:String = (datas.first(where: {$0.keyText == "nonce"})?.valueText)! as! String
                let gasPrice:String = (datas.first(where: {$0.keyText == "gasPrice"})?.valueText)! as! String
                let gasLimit:String = (datas.first(where: {$0.keyText == "gasLimit"})?.valueText)! as! String
                let to:String = (datas.first(where: {$0.keyText == "to"})?.valueText)! as! String
                let amount:String = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                MWSDK.EVM.Wallet.transferMatic(nonce: nonce, gasPrice: gasPrice,gasLimit: gasLimit,to: to,amount: amount ) { response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    self.Log("\(item):failed~")
                }
            }
            break
        case "transferBNB":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.nonce,.gasPrice,.gasLimit,.to,.amount])
            paramtersView.paramtersJson = {datas in
                let nonce:String = (datas.first(where: {$0.keyText == "nonce"})?.valueText)! as! String
                let gasPrice:String = (datas.first(where: {$0.keyText == "gasPrice"})?.valueText)! as! String
                let gasLimit:String = (datas.first(where: {$0.keyText == "gasLimit"})?.valueText)! as! String
                let to:String = (datas.first(where: {$0.keyText == "to"})?.valueText)! as! String
                let amount:String = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                MWSDK.EVM.Wallet.transferBNB(nonce: nonce, gasPrice: gasPrice,gasLimit: gasLimit,to: to,amount: amount ) { response in
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
            paramtersView.setParams(keys: [.collection_address,.token_id,.price,.marketplace_address,.confirmation])
            paramtersView.paramtersJson = {datas in
                let collection_address:String = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                let price:Double = MirrorTool.getInputDouble((datas.first(where: {$0.keyText == "price"})?.valueText)! as! String)
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                let marketplace_address:String = (datas.first(where: {$0.keyText == "marketplace_address"})?.valueText)! as! String
                 let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                MWSDK.EVM.Asset.buyNFT(collection_address: collection_address,token_id:token_id, price: Double(price) ,marketplace_address: marketplace_address, confirmation: confirmation) { data in
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
            paramtersView.setParams(keys: [.collection_address,.token_id,.price,.marketplace_address,.confirmation])
            paramtersView.paramtersJson = {datas in
                
                    let collection_address:String = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                    let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                    let marketplace_address:String = (datas.first(where: {$0.keyText == "marketplace_address"})?.valueText)! as! String
                     let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                MWSDK.EVM.Asset.cancelNFTListing(collection_address: collection_address,token_id:token_id,marketplace_address: marketplace_address,confirmation: confirmation) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                }
            }

            break
        case "getTransactionsByWallet":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_wallet_address,.limit])
            paramtersView.paramtersJson = {datas in
                let wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                let limit:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "limit"})?.valueText) as! String)
                MWSDK.EVM.Wallet.getTransactionsByWallet(wallet_address:wallet_address, limit: limit){ response in
                    self.Log(response)
                    loadingActive.stopAnimating()
                } onFailed: {
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed~")
                }
            }
            break
        case "listNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_address,.token_id,.price,.marketplace_address,.confirmation])
            paramtersView.paramtersJson = {datas in
                let collection_address:String = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                let price:Double = MirrorTool.getInputDouble((datas.first(where: {$0.keyText == "price"})?.valueText)! as! String)
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                let marketplace_address:String = (datas.first(where: {$0.keyText == "marketplace_address"})?.valueText)! as! String
                 let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                MWSDK.EVM.Asset.listNFT(collection_address: collection_address,token_id:token_id, price: Double(price) ,marketplace_address: marketplace_address, confirmation: confirmation) { data in
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
            paramtersView.setParams(keys: [.collection_address,.token_id,.to_wallet_address,.confirmation])
            paramtersView.paramtersJson = {datas in
                let collection_address:String = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                 let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                MWSDK.EVM.Asset.transferNFT(collection_address: collection_address, token_id: token_id, to_wallet_address: to_wallet_address, confirmation: confirmation,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()

                })
            }

            break
            ///Asset/Mint
        case "mintCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.url,.name,.symbol,.contract_type,.mint_start_id,.mint_end_id,.mint_amount,.confirmation])
            paramtersView.paramtersJson = {datas in
                let url:String = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let name:String = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol:String = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let contract_type:String = MirrorTool.getContractType(str: (datas.first(where: {$0.keyText == "contract_type"})?.valueText)! as! String)
                let mint_start_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "mint_start_id"})?.valueText) as! String)
                let mint_end_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "mint_end_id"})?.valueText) as! String)
                let mint_amount:Int = self.getMintAmount(someString: (datas.first(where: {$0.keyText == "mint_amount"})?.valueText) as! String)
                
                 let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)

                MWSDK.EVM.Asset.mintCollection(url:url,name: name, symbol: symbol, contract_type: contract_type, mint_start_id: mint_start_id,mint_end_id:mint_end_id,mint_amount: mint_amount ,confirmation:confirmation, onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                }, onFailed: { code,message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                })
            }
            break
        case "mintNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_address,.token_id,.to_wallet_address,.mint_amount,.confirmation])
            paramtersView.paramtersJson = {datas in
                let collection_address = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                let to_wallet_address:String = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                let mint_amount:Int = self.getMintAmount(someString: (datas.first(where: {$0.keyText == "mint_amount"})?.valueText) as! String)
                 let confirmation:String = MirrorTool.getInputConfirmation(someString: (datas.first(where: {$0.keyText == "confirmation"})?.valueText)! as! String)
                MWSDK.EVM.Asset.mintNFT(collection_address: collection_address, token_id: token_id, to_wallet_address: to_wallet_address, mint_amount: mint_amount, confirmation: confirmation){ data in

                    self.Log("mintNewNFT - response:\n")
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                }
            }
            break
        case "queryNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.token_address,.token_id])
            paramtersView.paramtersJson = {datas in
                let token_address:String = (datas.first(where: {$0.keyText == "token_address"})?.valueText)! as! String
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                MWSDK.EVM.Asset.queryNFT(token_address: token_address,token_id: token_id) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            break
        case "searchNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.token_address,.token_id])
            paramtersView.paramtersJson = {datas in
                let token_address:String = (datas.first(where: {$0.keyText == "token_address"})?.valueText)! as! String
                let token_id:String = (datas.first(where: {$0.keyText == "token_id"})?.valueText)! as! String
                
                var mint_address_arr:[[String:String]] = [
                    ["token_address":String(token_address),"token_id":String(token_id)]
                ] as [[String:String]]
                MWSDK.EVM.Asset.searchNFTs(tokens: mint_address_arr) { data in
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
            paramtersView.setParams(keys: [.owner_address,.limit,.cursor])
            paramtersView.paramtersJson = {datas in
                let owner_address:String = (datas.first(where: {$0.keyText == "owner_address"})?.valueText)! as! String
                let limit:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "limit"})?.valueText) as! String)
                let cursor:String = (datas.first(where: {$0.keyText == "cursor"})?.valueText)! as! String

                MWSDK.EVM.Asset.searchNFTsByOwner(owner_address: [owner_address], limit: limit , cursor: cursor ) { data in
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
                MWSDK.EVM.Metadata.getCollectionsInfo(collections: [collection_mint]) {data in
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
                MWSDK.EVM.Metadata.getCollectionFilterInfo(collection: collection) {data in
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
                MWSDK.EVM.Metadata.getCollectionsSummary(collections: [collection]) {data in
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
            paramtersView.setParams(keys: [.contract,.token_id])
            paramtersView.paramtersJson = {datas in
                let contract = (datas.first(where: {$0.keyText == "contract"})?.valueText)! as! String
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                MWSDK.EVM.Metadata.getNFTInfo(contract: contract,token_id:token_id) {data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: {code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
        case "getNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.contract,.sale,.page,.page_size,.marketplace_address])
            paramtersView.paramtersJson = {datas in

                let contract:String = (datas.first(where: {$0.keyText == "contract"})?.valueText)! as! String
                let marketplace_address:String = (datas.first(where: {$0.keyText == "marketplace_address"})?.valueText)! as! String
                let page:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page"})?.valueText) as! String)
                let page_size:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page_size"})?.valueText) as! String)
                let sale:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "sale"})?.valueText) as! String)


                MWSDK.EVM.Metadata.getNFTs(contract: contract, sale: sale, page: page, page_size: page_size, order: ["order_by":"price","desc":true], marketplace_address: marketplace_address, filter: [["filter_name" : "Rarity","filter_type":"enum","filter_value":["Common"]]]){ data in
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
            paramtersView.setParams(keys: [.contract,.token_id,.page,.page_size,.marketplace_address])
            paramtersView.paramtersJson = {datas in
                let contract:String = (datas.first(where: {$0.keyText == "contract"})?.valueText)! as! String
                let marketplace_address:String = (datas.first(where: {$0.keyText == "marketplace_address"})?.valueText)! as! String
                let token_id:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "token_id"})?.valueText) as! String)
                let page:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page"})?.valueText) as! String)
                let page_size:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page_size"})?.valueText) as! String)

                MWSDK.EVM.Metadata.getNFTEvents(contract: contract,token_id:token_id, page: page, page_size: page_size, marketplace_address: marketplace_address) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
            break
        case "Metadata searchNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint,.search])
            paramtersView.paramtersJson = {datas in
                let collection_mint:String = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let search:String = (datas.first(where: {$0.keyText == "search"})?.valueText)! as! String

                MWSDK.EVM.Metadata.searchNFTs(collections: [collection_mint], search: search) { data in
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
                MWSDK.EVM.Metadata.recommentSearchNFT(collections: [collection_mint]) { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                } onFailed: { code, message in
                    loadingActive.stopAnimating()
                    self.Log("\(item):failed  code:\(code),message: \(message ?? "")")
                }
            }
            break
        case "getMarketplaceEvents":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.marketplace_address,.page,.page_size])
            paramtersView.paramtersJson = {datas in
                let marketplace_address:String = (datas.first(where: {$0.keyText == "marketplace_address"})?.valueText)! as! String
                let page:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page"})?.valueText) as! String)
                let page_size:Int = MirrorTool.getInputInt(someString: (datas.first(where: {$0.keyText == "page_size"})?.valueText) as! String)
                MWSDK.EVM.Metadata.getMarketplaceEvents(marketplace_address: marketplace_address, page: page, page_size: page_size){ data in
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
    
    
    func getMintAmount(someString:String) -> Int{
        if(someString.isEmpty){
            return 1
        }
        return MirrorTool.getInputInt(someString: someString)
    }
}
