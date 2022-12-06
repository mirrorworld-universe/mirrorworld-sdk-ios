//
//  MirrorSecurityVerification.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/12/1.
//  Requesting Action Authorization

import UIKit

@objc public class MirrorSecurityVerification: NSObject {
    
    
    var bindUUID:String?
    var onAuthTokenCallback:((_ success:Bool,_ authToken:String?,_ errorDesc:String?)->())?
    var authController:MirrorWorldLoginAuthController?
    public func requestActionAuthorization(config:MirrorWorldSDKConfig?,_ router:MirrorWorldNetApi,_ callback:@escaping (_ success:Bool,_ authToken:String?,_ errorDesc:String?)->()){
        self.onAuthTokenCallback = callback
          let api = MirrorWorldNetApi.requestActionAuthorization(type: router.actionType, message: "", value: 1.00, params: router.param ?? [:])
        MirrorWorldNetWork().request(api: api) {[weak self] response in
              let responseJson = response?.toJson()
              let data = responseJson?["data"] as? [String:Any]
              let uuid = (data?["uuid"] as? String) ?? ""
              self?.bindUUID = uuid
              let urlString =  (config?.environment.authRoot ?? "")
              let approve = urlString + uuid
              DispatchQueue.main.async {
                  guard let url = URL(string: approve) else {
                  MWLog.console("please check your param.")
                      self?.onAuthTokenCallback?(false,nil, "action authorization failed.")
                  return }
                  let authTokenVC = MirrorWorldLoginAuthController.init(url: url)
                  let baseVc = MirrorUIConfig().baseViewContoller
                  baseVc?.present(authTokenVC, animated: true)
                  self?.authController = authTokenVC
                  authTokenVC.done? = {[weak self] in
                      self?.onAuthTokenCallback?(false,nil, "user cancel authorization.")
                  }
              }
          } _: {[weak self] code, errorDesc in
              DispatchQueue.main.async {
                  self?.onAuthTokenCallback?(false,nil, errorDesc)
              }
          }

    }
    
    public func callBackToken(uuid:String?,token:String?){
        guard let uuId = uuid,uuId.count > 0 else {
            MWLog.console("the request approve: uuid is empty.")
            return }
        guard let bid = bindUUID,bid.count > 0 else {
            MWLog.console("the request action failed: uuid is empty.")
            return }
        
        if isRequestActionWith(uuid: uuId, binduuid: bid){
            self.authController?.dismiss(animated: true)
            self.onAuthTokenCallback?(true,token, nil)
        }
    }
    
    public func isRequestActionWith(uuid:String,binduuid:String)->Bool{
        return (uuid == binduuid)
    }
    
}
