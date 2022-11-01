//
//  MirrorWordLoginAuthController.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/10/21.
//

import UIKit
import SafariServices

class MirrorWordLoginAuthController: SFSafariViewController {
    
    var finsh:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

}
extension MirrorWordLoginAuthController:SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("click finish")
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


extension MirrorWordLoginAuthController{
    
}
