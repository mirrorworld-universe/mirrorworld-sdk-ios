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
class SUIAPIView{
    
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
            //Asset
        case "getMintedCollections":
            MWSDK.SUI.Asset.getMintedCollection { response in
                
                let res = response?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                
                self.Log("result:\(res ?? "null")")
                loadingActive.stopAnimating()
            } onFailed: {code, error in
                self.Log("\(code):\(String(describing: error))")
            }
            break
        case "getMintedNFTsOnCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_address])
            paramtersView.paramtersJson = {datas in
                let collection_address = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                
                MWSDK.SUI.Asset.getMintedNFTsOnCollection(collection_address: collection_address,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "mintCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.name,.symbol,.description,.creators])
            paramtersView.paramtersJson = {datas in
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let description = (datas.first(where: {$0.keyText == "description"})?.valueText)! as! String
                var creators_arr:[String] = []
                
                let creatorsStr = (datas.first(where: {$0.keyText == "creators"})?.valueText)! as! String
                if(creatorsStr != ""){
                    creatorsStr.split(separator: ",").forEach { subStr in
                        creators_arr.append(String(subStr))
                    }
                }
                
                MWSDK.SUI.Asset.mintCollection(name:name,symbol: symbol, description: description,creators: creators_arr,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "mintNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_address,.name,.image,.attributes,.description,.to_wallet_address])
            paramtersView.paramtersJson = {datas in
                let collection_address = (datas.first(where: {$0.keyText == "collection_address"})?.valueText)! as! String
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let image = (datas.first(where: {$0.keyText == "image"})?.valueText)! as! String
                let description = (datas.first(where: {$0.keyText == "description"})?.valueText)! as! String
                let to_wallet_address = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                struct Item: Decodable {
                    let key: String
                    let value: String
                }
                var attributes:[[String:String]] = []
                attributes.append(["key": "face", "value": "round"])
                
                MWSDK.SUI.Asset.mintNFT(collection_address:collection_address,name: name,image_url: image,attributes: attributes,description: description,to_wallet_address:to_wallet_address,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "queryNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.nft_object_id])
            paramtersView.paramtersJson = {datas in
                let nft_object_id = (datas.first(where: {$0.keyText == "nft_object_id"})?.valueText)! as! String
                
                MWSDK.SUI.Asset.queryNFT(nft_object_id:nft_object_id,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "searchNFTsByOwner":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.owner_address])
            paramtersView.paramtersJson = {datas in
                let owner_address = (datas.first(where: {$0.keyText == "owner_address"})?.valueText)! as! String
                
                MWSDK.SUI.Asset.searchNFTsByOwner(owner_address:owner_address,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "searchNFTs":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.nft_object_ids])
            paramtersView.paramtersJson = {datas in
                let nft_object_ids = (datas.first(where: {$0.keyText == "nft_object_ids"})?.valueText)! as! String
                var nft_object_ids_arr:[String] = []
                nft_object_ids.split(separator: ",").forEach { subStr in
                    nft_object_ids_arr.append(String(subStr))
                }
                MWSDK.SUI.Asset.searchNFTs(nft_object_ids:nft_object_ids_arr,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
            //Wallet
        case "getTransactionByDigest":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.digest])
            paramtersView.paramtersJson = {datas in
                let digest = (datas.first(where: {$0.keyText == "digest"})?.valueText)! as! String
                
                MWSDK.SUI.Wallet.getTransactionByDigest(digest:digest,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()

                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "getTokens":
            MWSDK.SUI.Wallet.getTokens { response in
                let res = response?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
                
                self.Log("Get wallet tokens:\(res ?? "null")")
                loadingActive.stopAnimating()
            } onFailed: {code, error in
                self.Log("\(code):\(String(describing: error))")
            }
            break
        case "transferSUI":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount])
            paramtersView.paramtersJson = {datas in
                let to_publickey = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amountStr = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                let formatter = NumberFormatter()
                    let someString = datas.first(where: {$0.keyText == "limit"})?.valueText
                let amount:Int = formatter.number(from: amountStr as! String) as! Int
                
                MWSDK.SUI.Wallet.transferSUI(to_publickey:to_publickey,amount:amount,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
        case "transferToken":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount,.token_address])
            paramtersView.paramtersJson = {datas in
                let to_publickey = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amountStr = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                let formatter = NumberFormatter()
                    let someString = datas.first(where: {$0.keyText == "limit"})?.valueText
                let amount:Int = formatter.number(from: amountStr as! String) as! Int
                let token = (datas.first(where: {$0.keyText == "token_address"})?.valueText)! as! String
                
                MWSDK.SUI.Wallet.transferToken(to_publickey:to_publickey,amount:amount,token:token,onSuccess: { data in
                    self.Log(data)
                    loadingActive.stopAnimating()
                },onFailed: { code, message in
                    self.Log("\(item):failed:\(code),\(message ?? "")")
                    loadingActive.stopAnimating()
                })
            }
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
