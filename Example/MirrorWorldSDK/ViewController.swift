//
//  ViewController.swift
//  MirrorWorldSDK
//
//  Created by 791738673@qq.com on 10/21/2022.
//  Copyright (c) 2022 791738673@qq.com. All rights reserved.
//

import UIKit
import MirrorWorldSDK

class ViewController: UIViewController {

    
    @IBOutlet weak var loadingActive: UIActivityIndicatorView!
    
    @IBAction func clearConsole(_ sender: Any) {
        self.textView.text = ""
    }
    func Log(_ info:String?){
        let t = info ?? ""
        var text = self.textView.text
        text?.append(t)
        text?.append("\n")
        self.textView.text = text
        self.textView.scrollRangeToVisible(NSRange(location: 0, length: text?.count ?? 0))
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var textView: UITextView!
    
    private lazy var paramtersView:inputParamsView = {
        let view = inputParamsView(frame: CGRect(x: 15, y: 120, width: UIScreen.main.bounds.size.width-30, height: 300))
        return view
    }()
    
    
    var dataSource = [(moudleTitle:"Init",MethodList:["initSDK"]),(moudleTitle:"Auth",MethodList:["Start Login","Logs out a user","CheckAuthenticated"]),
                      (moudleTitle:"Wallet",MethodList:["OpenWallet","GetAccessToken","QueryUser","Get wallet tokens","Get wallet transactions","Get wallet transaction by signature","Transfer SOL to another address","Transfer Token to another address"]),
                      (moudleTitle:"Marketplace",MethodList:[
                        "openMarketPlacePage",
                        "MintNewCollection",
                        "MintNewNFT",
                        "FetchSingleNFT",
                        "UpdateNFTListing",
                        "ListNFT",
                        "CancelNFTListing",
                        "FetchNFTsByMintAddresses",
                        "MintNewNFTOnCollection",
                        "CreateVerifiedCollection",
                        "CreateVerifiedSubCollection","TransferNFTToAnotherSolanaWallet",
                        "BuyNFT","FetchNFTsByUpdateAuthorities","FetchNFTsByCreatorAddresses","FetchNFTsByOwnerAddresses"])
    ]
    
    @IBOutlet weak var tableView: UITableView!
    let color = (bg:UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1),text:UIColor.black)
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){
        self.view.backgroundColor = .black
        self.tableView.register(tableViewCell.self, forCellReuseIdentifier: "tableViewCellID")
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].MethodList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID",for: indexPath) as! tableViewCell
        cell.titleLbl.text = dataSource[indexPath.section].MethodList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .black
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.size.width-30, height: 40))
        label.textColor = color.bg
        label.text = dataSource[section].moudleTitle
        header.addSubview(label)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.section].MethodList[indexPath.row]
        self.Log("\n--------\(item):--------\n")
        
        loadingActive.startAnimating()
        
        switch item {
        case "initSDK":
            let initView = Bundle.main.loadNibNamed("selectEnvView", owner: self)?.last as! MWSelectEnvView
            view.addSubview(initView)
            initView.finishBlock = { env,apikey in
                if MWSDK.initSDK(env: env, apiKey: apikey) {
                    self.Log("initSDk success !")
                    MWSDK.CheckAuthenticated { onBool in
                        self.Log("CheckAuthenticated:\(onBool)")
                    }
                }
            }
//            MWSDK.initSDK(env: .StagingDevNet, apiKey: "mw_testgpyr7Dud9ZyLezOpEQAWbm7kISPGb7KQ3iX")

            break
        case "Start Login":
            MWSDK.StartLogin { userInfo in
                self.loadingActive.stopAnimating()
                self.Log("login success :\(userInfo?.toString() ?? "")")
            } onFail: {
                self.loadingActive.stopAnimating()
                self.Log("login failed!")
            }

        case "Logs out a user":
            MWSDK.loginOut {
                self.Log("Logs out a user : success")
            } onFail: {
                self.Log("Logs out a user : failed")
            }
        case "CheckAuthenticated":
            MWSDK.CheckAuthenticated { onBool in
                self.loadingActive.stopAnimating()
                self.Log("This device's login state is:\(onBool)")
            }
            break
        case "OpenWallet":
            MWSDK.OpenWallet {
                self.loadingActive.stopAnimating()
                self.Log("Wallet is logout")

            } loginSuccess: { userinfo in
                self.loadingActive.stopAnimating()
                self.Log("Wallet login: \(userinfo)")
            }

            self.loadingActive.stopAnimating()
            break
        case "openMarketPlacePage":
            MWSDK.openMarketPlacePage()
            break
        case "QueryUser":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.email])
            paramtersView.paramtersJson = {[weak self] datas in
                let email = (datas.first(where: {$0.keyText == "email"})?.valueText)! as! String
                
                MWSDK.QueryUser(email: email) { user in
                    self?.Log(user ?? "null")
                    self?.loadingActive.stopAnimating()
                } onFetchFailed: { code, error in
                    self?.Log("\(code):\(error)")
                }
            }

           
        case "GetAccessToken":
            MWSDK.GetAccessToken(callBack: { token in
                self.Log("Access Token is : \(token)")
                self.loadingActive.stopAnimating()
            })
        case "Get wallet tokens":
            MWSDK.GetWalletTokens { res in
                self.Log("Get wallet tokens:\n \(res)")
                self.loadingActive.stopAnimating()
            } onFailed: {
                self.Log("Get wallet tokens: failed")
            }
            
        case "Get wallet transactions":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.limit,.next_before])
            paramtersView.paramtersJson = {[weak self] datas in
                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
                let next_before = (datas.first(where: {$0.keyText == "next_before"})?.valueText)! as! String
                MirrorWorldSDK.share.GetWalletTransactions(limit: Int(limit) ?? 10, next_before: next_before) { response in
                    self?.Log("Get wallet transactions:\(response)")
                    self?.loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item): failed ~")
                }
            }
           

            break
            
        case "Get wallet transaction by signature":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.limit,.next_before])
            paramtersView.paramtersJson = {[weak self] datas in
                let signature = (datas.first(where: {$0.keyText == "signature"})?.valueText)! as! String
                MirrorWorldSDK.share.GetWalletTransactionsBy(signature: signature) { response in
                    self?.Log(response)
                    self?.loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item):failed~")
                }
            }
           

            break
        case "Transfer SOL to another address":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount])
            paramtersView.paramtersJson = {[weak self] datas in
                let to_publickey = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amount = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String

                //                6Rp5grdihB8bpNCc9v25wZSgVMiNvLfRNF4B8z7esdZ4
                MirrorWorldSDK.share.TransferSolToAnotherAddress(to_publickey: to_publickey, amount: Int(amount) ?? 1) { response in
                    self?.Log(response)
                    self?.loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item):failed~")
                }

            }
            break
        case "Transfer Token to another address":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.to_publickey,.amount,.token_mint,.decimals])
            paramtersView.paramtersJson = {[weak self] datas in
                let to_publickey = (datas.first(where: {$0.keyText == "to_publickey"})?.valueText)! as! String
                let amount = (datas.first(where: {$0.keyText == "amount"})?.valueText)! as! String
                let token_mint = (datas.first(where: {$0.keyText == "token_mint"})?.valueText)! as! String
                let decimals = (datas.first(where: {$0.keyText == "decimals"})?.valueText)! as! String

                MWSDK.TransferTokenToAnotherAddress(to_publickey: to_publickey, amount: Int(amount) ?? 1, token_mint: token_mint, decimals: Int(decimals) ?? 1) { response in
                    self?.Log(response)
                    self?.loadingActive.stopAnimating()
                } onFailed: {
                    self?.Log("\(item):failed~")
                }

            }
        case "MintNewCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.name,.symbol,.url,.seller_fee_basis_points])
            paramtersView.paramtersJson = {[weak self] datas in
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let seller_fee_basis_points = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! String

                MWSDK.MintNewCollection(name: name, symbol: symbol, url: url, seller_fee_basis_points: Int(seller_fee_basis_points) ?? 100, onSuccess: { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                }, onFailed: { code,message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                })

            }
        case "CreateVerifiedSubCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.name,.collection_mint,.url,.symbol])
            paramtersView.paramtersJson = {[weak self] datas in
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                MWSDK.CreateVerifiedSubCollection(name: name, collection_mint: collection_mint, symbol: symbol, url: url) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()

                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }

            }

            break
        case "MintNewNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint,.name,.symbol,.url,.seller_fee_basis_points])
            paramtersView.paramtersJson = {[weak self] datas in
//                MWSDK.MintNewNFT(collection_mint: "5dw2PLdbTtn6sUHdNLy3EH4buPHh3Ch9JQTCoP9d6DwN", name: "testNFT", symbol: "NA", url: "https://market-assets.mirrorworld.fun/gen1/1.json", seller_fee_basis_points: 500) { data in
//                    self?.Log(data)
//                    self?.loadingActive.stopAnimating()
//                } onFailed: { code, message in
//                    self?.Log("\(item):failed:\(code),\(message ?? "")")
//                    self?.loadingActive.stopAnimating()
//                }
                
                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let seller_fee_basis_points = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! String
                
                MWSDK.MintNewNFT(collection_mint: collection_mint, name: name, symbol: symbol, url: url, seller_fee_basis_points: Int(seller_fee_basis_points) ?? 100) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }

            
            

            break
        case "FetchSingleNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                MirrorWorldSDK.share.FetchSingleNFT(mint_Address: mint_address) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            break
        case "UpdateNFTListing":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
                MWSDK.UpdateNFTListing(mint_address: mint_address, price: Double(price) ?? 1.0) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            

            break
        case "TransferNFTToAnotherSolanaWallet":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.to_wallet_address])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let to_wallet_address = (datas.first(where: {$0.keyText == "to_wallet_address"})?.valueText)! as! String
                MWSDK.TransferNFTToAnotherSolanaWallet(mint_address: mint_address, to_wallet_address: to_wallet_address) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            
            break
            
        case "MintNewNFTOnCollection":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.collection_mint,.name,.symbol,.url,.seller_fee_basis_points])
            paramtersView.paramtersJson = {[weak self] datas in
                let collection_mint = (datas.first(where: {$0.keyText == "collection_mint"})?.valueText)! as! String
                let name = (datas.first(where: {$0.keyText == "name"})?.valueText)! as! String
                let symbol = (datas.first(where: {$0.keyText == "symbol"})?.valueText)! as! String
                let url = (datas.first(where: {$0.keyText == "url"})?.valueText)! as! String
                let seller_fee_basis_points = (datas.first(where: {$0.keyText == "seller_fee_basis_points"})?.valueText)! as! String
                MWSDK.MintNewNFT(collection_mint: collection_mint, name: name, symbol: symbol, url: url, seller_fee_basis_points: Int(seller_fee_basis_points) ?? 100, confirmation: "finalized") { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                }
            }
            

            break
        case "ListNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String

                MirrorWorldSDK.share.ListNFT(mint_address: mint_address, price: Double(price) ?? 0.1, confirmation: "finalized") { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()

                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()

                }
            }
            
            break
        case "CancelNFTListing":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
                MWSDK.CancelNFTListing(mint_address: mint_address, price: Double(price) ?? 1.1) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()

                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }
            
            break
            
        case "BuyNFT":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address,.price])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                let price = (datas.first(where: {$0.keyText == "price"})?.valueText)! as! String
                MWSDK.BuyNFT(mint_address: mint_address, price: Double(price) ?? 0.01) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }
            break

            
        case "FetchNFTsByMintAddresses":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.mint_address])
            paramtersView.paramtersJson = {[weak self] datas in
                let mint_address = (datas.first(where: {$0.keyText == "mint_address"})?.valueText)! as! String
                MWSDK.FetchNFTsByMintAddresses(mint_address: mint_address) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }
            

            break
        case "FetchNFTsByUpdateAuthorities":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.update_authorities,.limit,.offset])
            paramtersView.paramtersJson = {[weak self] datas in
                let update_authorities = (datas.first(where: {$0.keyText == "update_authorities"})?.valueText)! as! String
                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
                let offset = (datas.first(where: {$0.keyText == "offset"})?.valueText)! as! String
                MWSDK.FetchNFTsByUpdateAuthorities(update_authorities: [update_authorities], limit: Double(limit) ?? 1.0, offset: Double(offset) ?? 0.1) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }
            
            

            break
        case "FetchNFTsByCreatorAddresses":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.creators,.limit,.offset])
            paramtersView.paramtersJson = {[weak self] datas in
                let creators = (datas.first(where: {$0.keyText == "creators"})?.valueText)! as! String
                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
                let offset = (datas.first(where: {$0.keyText == "offset"})?.valueText)! as! String
                MWSDK.FetchNFTsByCreatorAddresses(creators: [creators], limit: Double(limit) ?? 10.0, offset:Double(offset) ?? 0.1) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }
            
            break
        case "FetchNFTsByOwnerAddresses":
            view.addSubview(paramtersView)
            paramtersView.setParams(keys: [.owners,.limit,.offset])
            paramtersView.paramtersJson = {[weak self] datas in
                let owners = (datas.first(where: {$0.keyText == "owners"})?.valueText)! as! String
                let limit = (datas.first(where: {$0.keyText == "limit"})?.valueText)! as! String
                let offset = (datas.first(where: {$0.keyText == "offset"})?.valueText)! as! String
                MWSDK.FetchNFTsByOwnerAddress(owners: [owners], limit: Double(limit) ?? 1, offset: Double(offset) ?? 0.1) { data in
                    self?.Log(data)
                    self?.loadingActive.stopAnimating()
                } onFailed: { code, message in
                    self?.Log("\(item):failed:\(code),\(message ?? "")")
                    self?.loadingActive.stopAnimating()
                }
            }
           

            break
            
        default:
            self.Log(item + " Coming soon.")
            self.loadingActive.stopAnimating()
            break
        }
    }

}
