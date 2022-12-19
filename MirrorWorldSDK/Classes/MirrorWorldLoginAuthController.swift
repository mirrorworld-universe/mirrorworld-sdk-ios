//
//  MirrorWorldLoginAuthController.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/21.
//

import UIKit
import SafariServices

@objc class MirrorWorldLoginAuthController: SFSafariViewController {
    
    
    var finsh:(()->())?
    var done:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
//        self.preferredBarTintColor = .red
        self.preferredControlTintColor = UIColor(red: 166/255.0, green: 226/255.0, blue: 46/255.0, alpha: 1)
    }

}
extension MirrorWorldLoginAuthController:SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.done?()
    }
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("start loading")
    }
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("load finish")
    }
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        print("open with safari")
    }
    
}


extension MirrorWorldLoginAuthController{
    
}
