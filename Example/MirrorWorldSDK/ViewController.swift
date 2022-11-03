//
//  ViewController.swift
//  MirrorWorldSDK
//
//  Created by 791738673@qq.com on 10/21/2022.
//  Copyright (c) 2022 791738673@qq.com. All rights reserved.
//

import UIKit
import MirrorWorldSDK

class ViewController: UIViewController,MirrorWorldSDKProtocol {
    func loginListener(_ userInfo: [String : Any]?, _ onSuccess: Bool, _ onFail: Bool) {
        
    }
    
    func loginOut(_ success: Bool?) {
        if success ?? false{
            self.textView.text = ""
            self.textView.text = "logged out"
        }
    }
    
    func userInfo(_ userInfo: [String : Any]?) {
        let info = userInfo?.toString() ?? ""
        
    }
    
    func getToken(_ userInfo: [String : Any]?) {
        
    }
    
    func Log(_ info:String){
        var text = self.textView.text
        text?.append(info)
        text?.append("\n")
        self.textView.text = text
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var textView: UITextView!
    
//    var dataSource:[(String,String)] = [(title:"openLogin",content:"openLogin"),(title:"Logs out a user",content:"Logs out a user"),(title:"openWallet",content:"")]
//
//    var dataSource = ["Auth":["Start Login","Logs out a user","CheckAuthenticated"],
//              "Wallet":["Waiting for development"],
//              "Marketplace":["OpenWallet"],
//    ]
    var dataSource = [(moudleTitle:"Auth",MethodList:["Start Login","Logs out a user","CheckAuthenticated"]),
                      (moudleTitle:"Wallet",MethodList:["OpenWallet","GetAccessToken","QueryUser"]),
                      (moudleTitle:"Marketplace",MethodList:["FetchSingleNFT","MintNewNFTOnCollection","CreateVerifiedCollection","CreateVerifiedSubCollection","TransferNFTToAnotherSolanaWallet","CancelNFTListing","BuyNFT","UpdateNFTListing","ListNFT","FetchNFTsByUpdateAuthorities","FetchNFTsByCreatorAddresses","FetchNFTsByOwnerAddresses"])
    ]
    
    @IBOutlet weak var tableView: UITableView!
    let color = (bg:UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1),text:UIColor.black)
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        MWSDK.delegate = self
        
//  test：  mw_testIb0RM5IMP5UmgSwIAu4qCGPTP1BO7Doq1GN
//  relese-test：mw_ulbp1f55rorzXGXjAaAa3CKGJYzPicsvd2y
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
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return dataSource[section].0
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let t = dataSource[indexPath.section].MethodList[indexPath.row]
//        ["Start Login","Logs out a user","CheckAuthenticated"])
        switch t {
        case "Start Login":
//            MirrorWorldSDK.share.StartLogin(baseController: self) { userInfo in
//                self.Log("login success :\(userInfo?.toString() ?? "")")
//            } onFail: {
//                self.Log("login failed !")
//            }
            MWSDK.StartLogin { userInfo in
                
            } onFail: {
                
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
            MWSDK.OpenWallet(controller: self)
            break
        case "QueryUser":
            MWSDK.QueryUser(email: "zg72296@gmail.com") { user in
                self.Log(user ?? "null")
            } onFetchFailed: { code, error in
                self.Log("\(code):\(error)")
            }
        case "GetAccessToken":
            MWSDK.GetAccessToken(callBack: { token in
                self.Log("Access Token is : \(token)")
            })

            break
        case "jsTest":
            break
        default:
            break
        }
    }

}
