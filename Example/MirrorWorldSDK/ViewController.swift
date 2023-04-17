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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var textView: UITextView!
    
    private lazy var paramtersView:inputParamsView = {
        let view = inputParamsView(frame: CGRect(x: 15, y: 120, width: UIScreen.main.bounds.size.width-30, height: 300))
        return view
    }()
    
    var dataSource = [(moudleTitle:"Init",MethodList:["initSDK"]),
                      (moudleTitle:"Auth",MethodList:["Start Login","Guest Login","Logs out a user","CheckAuthenticated"]),
                      (moudleTitle:"Wallet",MethodList:["OpenWallet","GetAccessToken","QueryUser","Get wallet tokens","Get wallet transactions","Get wallet transaction by signature","CheckStatusOfTransactions","Transfer SOL to another address","Transfer Token to another address"]),
                      (moudleTitle:"Marketplace",MethodList:[
                        "openMarketPlacePage",
                        "MintNewCollection",
                        "MintNewNFTOnCollection",
                        "CheckStatusOfMinting",
                        "UpdateNFTProperties",
                        "FetchSingleNFT",
                        "UpdateNFTListing",
                        "ListNFT",
                        "CancelNFTListing",
                        "FetchNFTsByMintAddresses",
                        "CreateVerifiedSubCollection","TransferNFTToAnotherSolanaWallet",
                        "BuyNFT","FetchNFTsByUpdateAuthorities","FetchNFTsByCreatorAddresses","FetchNFTsByOwnerAddresses"]),
                      (moudleTitle:"MetaDataFilter",MethodList:["Get collection filter info","Get nft info","Get collection info","Get nft events","Search nfts","Recommend search nft","GetNFTsByUnabridgedParams","Get nft real price","Create new collection"])
    ]
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let color = (bg:UIColor(red: 151/255.0, green: 180/255.0, blue: 29/255.0, alpha: 1),text:UIColor.black)
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DataModel.shared.data as! [(moudleTitle: String, MethodList: [String])]
        titleView.text = DataModel.shared.title
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
        if(DataModel.shared.chain == MWChain.Solana){
            var solanaView:SolanaAPIView = SolanaAPIView()
            solanaView.Init(textView: textView)
            solanaView.onAPISelected(view, paramtersView: paramtersView, loadingActive: loadingActive, dataSource: dataSource, tableView: tableView, didSelectRowAt: indexPath)
        }else if(DataModel.shared.chain == MWChain.Ethereum || DataModel.shared.chain == MWChain.Polygon || DataModel.shared.chain == MWChain.BNB){
            var evmView:EVMAPIView = EVMAPIView()
            evmView.Init(textView: textView)
            evmView.onAPISelected(view, paramtersView: paramtersView, loadingActive: loadingActive, dataSource: dataSource, tableView: tableView, didSelectRowAt: indexPath)
        }else{
            
        }
    }

}
