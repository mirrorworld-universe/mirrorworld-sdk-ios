//
//  MirrorWalletMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/1.
//

import UIKit

@objc class MirrorWalletMoudle: NSObject {
  
    var config:MirrorWorldSDKConfig?
    
    @objc func openWallet(controller:UIViewController?){
        let walletUrl = config?.environment.mainRoot ?? ""
        guard walletUrl.count > 0 else { return }
        let url = URL(string: walletUrl)!
        let auth = MirrorWorldLoginAuthController.init(url: url)
        controller?.present(auth, animated: true)
    }
    
    

}
