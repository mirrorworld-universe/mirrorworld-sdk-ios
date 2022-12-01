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
        // Do any additional setup after loading the view.
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
