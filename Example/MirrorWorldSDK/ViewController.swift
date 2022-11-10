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
//    func loginListener(_ userInfo: [String : Any]?, _ onSuccess: Bool, _ onFail: Bool) {
//
//    }
//
//    func loginOut(_ success: Bool?) {
//        if success ?? false{
//            self.textView.text = ""
//            self.textView.text = "logged out"
//        }
//    }
//
//    func userInfo(_ userInfo: [String : Any]?) {
//        let info = userInfo?.toString() ?? ""
//
//    }
//
//    func getToken(_ userInfo: [String : Any]?) {
//
//    }
    
    @IBOutlet weak var loadingActive: UIActivityIndicatorView!
    
    @IBAction func clearConsole(_ sender: Any) {
        self.textView.text = ""
    }
    func Log(_ info:String){
        var text = self.textView.text
        text?.append(info)
        text?.append("\n")
        self.textView.text = text
        self.textView.scrollRangeToVisible(NSRange(location: 0, length: text?.count ?? 0))
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var textView: UITextView!
    
    
    var dataSource = [(moudleTitle:"Auth",MethodList:["Start Login","Logs out a user","CheckAuthenticated"]),
                      (moudleTitle:"Wallet",MethodList:["OpenWallet","GetAccessToken","QueryUser","Get wallet tokens","Get wallet transactions","Get wallet transaction by signature","Transfer SOL to another address","Transfer Token to another address"]),
                      (moudleTitle:"Marketplace",MethodList:[
                        "MintNewCollection",
                        "MintNewNFT",
                        "FetchSingleNFT",
                        "ListNFT",
                        "MintNewNFTOnCollection","CreateVerifiedCollection","CreateVerifiedSubCollection","TransferNFTToAnotherSolanaWallet","CancelNFTListing","BuyNFT","UpdateNFTListing","ListNFT","FetchNFTsByUpdateAuthorities","FetchNFTsByCreatorAddresses","FetchNFTsByOwnerAddresses"])
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
        case "Start Login":

            MWSDK.StartLogin { userInfo in
                self.Log("login success :\(userInfo?.toString() ?? "")")
            } onFail: {
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
                self.Log("This device's login state is:\(onBool)")
            }
            break
        case "OpenWallet":
            print("123")
            MWSDK.OpenWallet()
            break
        case "QueryUser":
            MWSDK.QueryUser(email: "jbakebwa@gmail.com") { user in
                self.Log(user ?? "null")
                self.loadingActive.stopAnimating()
            } onFetchFailed: { code, error in
                self.Log("\(code):\(error ?? "")")
            }
        case "GetAccessToken":
            MWSDK.GetAccessToken(callBack: { token in
                self.Log("Access Token is : \(token)")
                self.loadingActive.stopAnimating()
            })
        case "Get wallet tokens":
            MWSDK.GetWalletTokens { res in
                self.Log("Get wallet tokens:\n \(res ?? "")")
                self.loadingActive.stopAnimating()
            } onFailed: {
                self.Log("Get wallet tokens: failed")
            }
            
        case "Get wallet transactions":

            MirrorWorldSDK.share.GetWalletTransactions(limit: 10, next_before: "") { response in
                self.Log("Get wallet transactions:\(response ?? "")")
                self.loadingActive.stopAnimating()
            } onFailed: {
                self.Log("\(item): failed ~")
            }

            break
            
        case "Get wallet transaction by signature":
            MirrorWorldSDK.share.GetWalletTransactionsBy(signature: "signature") { response in
                self.Log(response ?? "null")
                self.loadingActive.stopAnimating()
            } onFailed: {
                self.Log("\(item):failed~")
            }

            break
        case "Transfer SOL to another address":
            MirrorWorldSDK.share.TransferSolToAnotherAddress(to_publickey: "6Rp5grdihB8bpNCc9v25wZSgVMiNvLfRNF4B8z7esdZ4", amount: 123) { response in
                self.Log(response ?? "nil")
                self.loadingActive.stopAnimating()
            } onFailed: {
                self.Log("\(item):failed~")
            }
            break
        case "Transfer Token to another address":
            MWSDK.TransferTokenToAnotherAddress(to_publickey: "3UPoqgwgEgERSLNeF2rcawidfisdAtCzFe3F8Txxxxxx", amount: 123, token_mint: "3UPoqgwgEgERSLNeF2rcawidfisdAtCzFe3F8Txxxxxx", decimals: 123) { response in
                self.Log(response ?? "nil")
                self.loadingActive.stopAnimating()
            } onFailed: {
                self.Log("\(item):failed~")
            }
        case "MintNewCollection":
            MWSDK.MintNewCollection(name: "testNewCollection", symbol: "NA", url: "https://market-assets.mirrorworld.fun/gen1/1.json", confirmation: "finalized", seller_fee_basis_points: 200, onSuccess: { data in
                self.Log(data ?? "")
                self.loadingActive.stopAnimating()
            }, onFailed: { code,message in
                self.Log("\(item):failed:\(code),\(message ?? "")")
            })
        case "MintNewNFT":
            MWSDK.MintNewNFT(collection_mint: "", name: "testNFT", symbol: "NA", url: "https://market-assets.mirrorworld.fun/gen1/1.json", seller_fee_basis_points: 500, confirmation: "finalized") { data in
                self.Log(data ?? "")
                self.loadingActive.stopAnimating()
            } onFailed: { code, message in
                self.Log("\(item):failed:\(code),\(message ?? "")")
                self.loadingActive.stopAnimating()
            }

            break
        case "FetchSingleNFT":
            MirrorWorldSDK.share.FetchSingleNFT(mint_Address: "E5LBzZBgyNAmXFevhybmqTKL4X9UPVeiEBhPbRfU1pDL") { data in
                self.Log(data ?? "")
                self.loadingActive.stopAnimating()
            } onFailed: { code, message in
                self.Log("\(item):failed:\(code),\(message ?? "")")
            }
            break
        case "TransferNFTToAnotherSolanaWallet":
            MWSDK.TransferNFTToAnotherSolanaWallet(mint_address: "", to_wallet_address: "", confirmation: "") { data in
                self.Log(data ?? "")
                self.loadingActive.stopAnimating()
            } onFailed: { code, message in
                self.Log("\(item):failed:\(code),\(message ?? "")")
            }
            break
            
        case "MintNewNFTOnCollection":
//            MWSDK.
            break
        case "ListNFT":
            MirrorWorldSDK.share.ListNFT(mint_address: "test", price: 1.1, confirmation: "finalized") { data in
                self.Log(data ?? "")
                self.loadingActive.stopAnimating()

            } onFailed: { code, message in
                self.Log("\(item):failed:\(code),\(message ?? "")")
                self.loadingActive.stopAnimating()

            }

            break
            
        default:
            self.Log(item + " Coming soon.")
            self.loadingActive.stopAnimating()
            break
        }
    }

}
