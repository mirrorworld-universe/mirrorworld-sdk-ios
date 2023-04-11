//
//  Entrance.swift
//  MirrorWorldSDK_Example
//
//  Created by squall on 2023/4/10.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SwiftUI
import MirrorWorldSDK
import UIKit

class Entrance :UIViewController{
    var selectedChain = MWChain.Solana;
    var selectedEnv:MWEnvironment = MWEnvironment.DevNet
    @IBOutlet weak var textView: UITextField!
    
    @IBAction func onChainItemClicked(_ sender: Any) {
        if let button = sender as? UICommand {
            let buttonName = button.title
                print("You choose chain: \(buttonName)")
            if(buttonName == "Solana"){
                selectedChain = MWChain.Solana
            }else if(buttonName == "Ethreum"){
                selectedChain = MWChain.Ethreum
            }else if(buttonName == "Polygon"){
                selectedChain = MWChain.Polygon
            }else if(buttonName == "BNB"){
                selectedChain = MWChain.BNB
            }else{
                print("⚠️ Warning: Unknwon chain:"+buttonName)
            }
        }
    }
    
    @IBAction func onEnvClicked(_ sender: Any){
        if let button = sender as? UICommand{
            let buttonName = button.title
            if(buttonName == "MainNet"){
                selectedEnv = MWEnvironment.MainNet
            }else if(buttonName == "DevNet"){
                selectedEnv = MWEnvironment.DevNet
            }else{
                print("⚠️ Warning: Unknwon chain:"+buttonName)
            }
        }
    }
    
    @IBAction func onInitSDKClicked(_ sender: UIButton){
        print("onInitSDKClicked")
        if let apiKey:String = textView.text{
            print("Input API key is:"+apiKey)
            if(!apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
                MirrorWorldSDK.share.initSDK(env: selectedEnv, chain: selectedChain, apiKey:apiKey)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Main")
                if(selectedChain == MWChain.Solana){
                    setUIData()
                }else if(selectedChain == MWChain.Ethreum){
                    setUIData()
                }else if(selectedChain == MWChain.Polygon){
                    
                }else if(selectedChain == MWChain.BNB){
                    
                }else{
                    print("⚠️ Warning: Unknown chain")
                }
                present(viewController, animated: true, completion: nil)
            }else{
                print("⚠️ Warning: Please input your API Key.")
                showToast(notice:"Notice",content:"Please input API Key.",btnText: "OK")
            }
        }else{
            print("⚠️ Warning: Please input your API Key.")
            showToast(notice:"Notice",content:"Please input API Key.",btnText: "OK")
        }
    }
    
    func showToast(notice: String, content: String, btnText:String) -> Void {
        let alertController = UIAlertController(title: notice, message: content, preferredStyle: .alert)
                
        let okAction = UIAlertAction(title: btnText, style: .default) { (action) in
            // 点击确定按钮后执行的代码
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUIData(){
        DataModel.shared.data = [
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
    }
}
