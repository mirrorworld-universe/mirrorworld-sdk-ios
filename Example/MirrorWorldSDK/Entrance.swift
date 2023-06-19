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
                selectedChain = MWChain.Ethereum
            }else if(buttonName == "Polygon"){
                selectedChain = MWChain.Polygon
            }else if(buttonName == "BNB"){
                selectedChain = MWChain.BNB
            }else if(buttonName == "SUI"){
                selectedChain = MWChain.SUI
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
                    setSolanaUIData()
                }else if(selectedChain == MWChain.Ethereum){
                    setEthreumUIData()
                }else if(selectedChain == MWChain.Polygon){
                    setPolygonUIData()
                }else if(selectedChain == MWChain.BNB){
                    setBNBUIData()
                }else if(selectedChain == MWChain.SUI){
                    setSUIUIData()
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
    
    func setSolanaUIData(){
        DataModel.shared.chain = MWChain.Solana
        DataModel.shared.title = "Mirror World SDK(Solana)";
        DataModel.shared.data = [
                          (moudleTitle:"Authentication",MethodList:["startLogin","guestLogin","logout","isLogged","loginWithEmail"]),
                          (moudleTitle:"Client APIs",MethodList:["openWallet","openMarket","queryUser"]),
                          (moudleTitle:"Wallet",MethodList:["getTransactions","getTransactionsByWallet","getTransactionBySignature","getTokens","getTokensByWallet","transferSOL","transferToken"]),
                          (moudleTitle:"Asset",MethodList:[
                            "mintCollection",
                            "mintNFT",
                            "checkMintingStatus",
                            "checkTransactionsStatus",
                            "updateNFT",
                            "queryNFT",
                            "listNFT",
                            "cancelNFTListing",
                            "searchNFTs",
                            "transferNFT",
                            "buyNFT","searchNFTsByOwner"]),
                          (moudleTitle:"Metadata",MethodList:[
                            "getCollectionFilterInfo","getNFTInfo","getCollectionsInfo","getNFTEvents","Metadata searchNFTs","recommentSearchNFT","getNFTs"])
        ]
    }
    
    func setEthreumUIData(){
        DataModel.shared.chain = MWChain.Ethereum
        DataModel.shared.title = "Mirror World SDK(Ethreum)";
        DataModel.shared.data = [
            (moudleTitle:"Authentication",MethodList:["startLogin","guestLogin","logout","isLogged","loginWithEmail"]),
            (moudleTitle:"Client APIs",MethodList:["openWallet","openMarket","queryUser"]),
            (moudleTitle:"Wallet",MethodList:["getTransactions","getTransactionsByWallet","getTransactionBySignature","getTokens","transferETH","transferToken"]),
            (moudleTitle:"Asset",MethodList:[
              "mintCollection",
              "mintNFT",
              "queryNFT",
              "listNFT",
              "cancelNFTListing",
              "searchNFTs",
              "transferNFT",
              "buyNFT",
              "searchNFTsByOwner"]),
            (moudleTitle:"Metadata",MethodList:[
              "getCollectionFilterInfo","getNFTInfo","getCollectionsInfo","getNFTEvents","Metadata searchNFTs","recommentSearchNFT","getNFTs","getMarketplaceEvents"])
        ]
    }
    
    func setPolygonUIData(){
        DataModel.shared.chain = MWChain.Polygon
        DataModel.shared.title = "Mirror World SDK(Polygon)";
        DataModel.shared.data = [
            (moudleTitle:"Authentication",MethodList:["startLogin","guestLogin","logout","isLogged","loginWithEmail"]),
            (moudleTitle:"Client APIs",MethodList:["openWallet","openMarket","queryUser"]),
            (moudleTitle:"Wallet",MethodList:["getTransactions","getTransactionsByWallet","getTransactionBySignature","getTokens","transferMatic","transferToken"]),
            (moudleTitle:"Asset",MethodList:[
              "mintCollection",
              "mintNFT",
              "queryNFT",
              "listNFT",
              "cancelNFTListing",
              "searchNFTs",
              "transferNFT",
              "buyNFT",
              "searchNFTsByOwner"]),
            (moudleTitle:"Metadata",MethodList:[
              "getCollectionFilterInfo","getNFTInfo","getCollectionsInfo","getNFTEvents","Metadata searchNFTs","recommentSearchNFT","getNFTs","getMarketplaceEvents"])
        ]
    }
    
    func setBNBUIData(){
        DataModel.shared.chain = MWChain.BNB
        DataModel.shared.title = "Mirror World SDK(BNB)";
        DataModel.shared.data = [
            (moudleTitle:"Authentication",MethodList:["startLogin","guestLogin","logout","isLogged","loginWithEmail"]),
            (moudleTitle:"Client APIs",MethodList:["openWallet","openMarket","queryUser"]),
            (moudleTitle:"Wallet",MethodList:["getTransactions","getTransactionsByWallet","getTransactionBySignature","getTokens","transferBNB","transferToken"]),
            (moudleTitle:"Asset",MethodList:[
              "mintCollection",
              "mintNFT",
              "queryNFT",
              "listNFT",
              "cancelNFTListing",
              "searchNFTs",
              "transferNFT",
              "buyNFT",
              "searchNFTsByOwner"]),
            (moudleTitle:"Metadata",MethodList:[
              "getCollectionFilterInfo","getNFTInfo","getCollectionsInfo","getNFTEvents","Metadata searchNFTs","recommentSearchNFT","getNFTs","getMarketplaceEvents"])
        ]
    }
    
    func setSUIUIData(){
        DataModel.shared.chain = MWChain.SUI
        DataModel.shared.title = "Mirror World SDK(SUI)";
        DataModel.shared.data = [
            (moudleTitle:"Authentication",MethodList:["startLogin","guestLogin","logout","isLogged","loginWithEmail"]),
            (moudleTitle:"Client APIs",MethodList:["openWallet","openMarket","queryUser"]),
            (moudleTitle:"Wallet",MethodList:["getTransactionByDigest","getTransactionBySignature","getTokens","transferSUI","transferToken"]),
            (moudleTitle:"Asset",MethodList:[
                "getMintedCollections",
                "getMintedNFTsOnCollection",
                  "mintCollection",
                  "mintNFT",
                  "queryNFT",
                  "searchNFTs",
                  "searchNFTsByOwner"]
            )
        ]
    }
}
