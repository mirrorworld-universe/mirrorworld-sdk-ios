//
//  MirrorSecurityVerification.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/12/1.
//  Requesting Action Authorization

import UIKit

@objc public class MirrorSecurityVerification: NSObject {
    public func requestActionAuthorization(config:MirrorWorldSDKConfig?,_ params:[String:Any]?,actionType:String,_ callback:@escaping (_ success:Bool,_ authToken:String?,_ errorDesc:String?)->()){
        MirrorSecurityVerificationShared.share.onAuthTokenCallback = callback
        
        var value:Double = 0.0
        var decimals:Int = 9
        params?.keys.forEach({ key in
            if key == "amount" {
//                print("11111\(var param?[key])")
                value = Double(((params?[key] as? Double) ?? 0))
//                print("11111\(value)")
            }
            if key == "price"{
//                print("22222\(var param?[key])")
                value = (params?[key] as? Double) ?? 0.00
//                print("22222\(value)")
            }
            if key == "decimals"{
//                print("33333\(var param?[key])")
                decimals = (params?[key] as? Int) ?? 9
//                print("33333\(value)")
            }
        })
        let url = MirrorUrlUtils.shard.getActionRoot() + "auth/actions/request"
        let requestParams =  ["type":actionType,
                              "message":"",
                              "value":value,
                              "params":params as Any] as [String : Any]
        MirrorWorldNetWork().request(url: url,method: "Post",params: requestParams) { response in
            print("response is:\(String(describing: response))")
              let responseJson = response?.toJson()
              let data = responseJson?["data"] as? [String:Any]
            let uuid:String = (data?["uuid"] as? String)!
            MirrorSecurityVerificationShared.share.bindUUID = uuid
            print("requestActionAuthorization bindUUID:\(String(describing: MirrorSecurityVerificationShared.share.bindUUID))")
            let urlString =  MirrorUrlUtils.shard.getUrlHost(service: MirrorService.Auth)
              let approve = urlString + "/approve/" + uuid + "?key=" + MirrorWorldSDKAuthData.share.access_token
              DispatchQueue.main.async {
                  guard let url = URL(string: approve) else {
                  MWLog.console("please check your param.")
                      MirrorSecurityVerificationShared.share.onAuthTokenCallback?(false,nil, "action authorization failed.")
                  return }
                  let authTokenVC = MirrorWorldLoginAuthController.init(url: url)
                  let baseVc = MirrorUIConfig().baseViewContoller
                  baseVc?.present(authTokenVC, animated: true)
                  MirrorSecurityVerificationShared.share.authController = authTokenVC
                  authTokenVC.done? = {
                      MirrorSecurityVerificationShared.share.onAuthTokenCallback?(false,nil, "user cancel authorization.")
                  }
              }
          } _: {code, errorDesc in
              DispatchQueue.main.async {
                  MirrorSecurityVerificationShared.share.onAuthTokenCallback?(false,nil, errorDesc)
              }
          }

    }
    
    public func callBackToken(uuid:String?,token:String?){
//        print("callBackToken uuid:\(uuid)")
//        print("callBackToken bindUUID:\(String(describing: MirrorSecurityVerificationShared.share.bindUUID))")
        guard let uuId = uuid,uuId.count > 0 else {
            MWLog.console("callBackToken the request approve: uuid is empty.")
            return }
        guard let bid = MirrorSecurityVerificationShared.share.bindUUID,bid.count > 0 else {
            MWLog.console("callBackToken the request action failed: uuid is empty.")
            return }
        if isRequestActionWith(uuid: uuId, binduuid: bid){
            MirrorSecurityVerificationShared.share.authController?.dismiss(animated: true)
            MirrorSecurityVerificationShared.share.onAuthTokenCallback?(true,token, nil)
        }
        
//        self.authController?.dismiss(animated: true)
//        self.onAuthTokenCallback?(true,token, nil)
    }
    
    public func isRequestActionWith(uuid:String,binduuid:String)->Bool{
        return (uuid == binduuid)
    }
    
}


@objc public class MirrorSecurityVerificationShared:NSObject{
    @objc public static let share = MirrorSecurityVerificationShared()
    var bindUUID:String?
    var onAuthTokenCallback1:((_ onSuccess:Bool,_ authToken:String?)->())?
    var onAuthTokenCallback:((_ success:Bool,_ authToken:String?,_ errorDesc:String?)->())?
    var authController:MirrorWorldLoginAuthController?
    
     var approveCallback:((_ uuid:String?,_ authToken:String?)->())?
     @objc public func openWebPage(_ urlString:String){
        guard let url = URL(string: urlString) else { return }
        authController = MirrorWorldLoginAuthController.init(url: url)
        let baseVc = MirrorUIConfig().baseViewContoller
        guard nil != authController else { return }
        baseVc?.present(authController!, animated: true)
    }
    @objc public func getApproveCallBack(finish:@escaping (_ udid:String?,_ authToken:String?)->Void){
        approveCallback = finish
    }
    public func ApproveCallBack(uuid:String?,token:String?){
        approveCallback?(uuid,token)
        self.authController?.dismiss(animated: true)
    }
    
    @objc public func getSecurityToken(params:[String:Any],config:MirrorWorldSDKConfig?,_ finish:@escaping ((_ onSuccess:Bool,_ authToken:String?)->())){
        print("getSecurityToken called!")
        self.onAuthTokenCallback1 = finish

        let api = MirrorWorldNetApi.SecurityVerification(params)
        MirrorWorldNetWork().request(url: api.path,method: "Post",params: api.param) {[weak self] response in
            let responseJson = response?.toJson()
            let data = responseJson?["data"] as? [String:Any]
            let uuid = (data?["uuid"] as? String) ?? ""
          
            self?.bindUUID = uuid
            print("getSecurityToken bindUUID:\(String(describing: self?.bindUUID))")
            let urlString =  (config?.environment.authRoot ?? "")
            let approve = urlString + uuid
            DispatchQueue.main.async {
                guard let url = URL(string: approve) else {
                MWLog.console("please check your param.")
                    self?.onAuthTokenCallback1?(false,"")
                return }
                let authTokenVC = MirrorWorldLoginAuthController.init(url: url)
                let baseVc = MirrorUIConfig().baseViewContoller
                baseVc?.present(authTokenVC, animated: true)
                self?.authController = authTokenVC
                authTokenVC.done? = {[weak self] in
                    self?.onAuthTokenCallback1?(false,"")
                }
            }
        } _: {[weak self] code, errorDesc in
            DispatchQueue.main.async {
                self?.onAuthTokenCallback1?(false,"")
            }
        }
    }
    public func authTokenCallBack(uuid:String?,token:String?){
//        print("authTokenCallBack uuid:\(uuid)")
//        print("authTokenCallBack bindUUID:\(bindUUID)")
        guard let uuId = uuid,uuId.count > 0 else {
            MWLog.console("authTokenCallBack the request approve: uuid is empty.")
            return }
        guard let bid = bindUUID,bid.count > 0 else {
            MWLog.console("authTokenCallBack the request action failed: uuid is empty.")
            return }
        if isRequestActionWith(uuid: uuId, binduuid: bid){
            self.authController?.dismiss(animated: true)
            self.onAuthTokenCallback1?(true,token)
        }
//        self.authController?.dismiss(animated: true)
//        self.onAuthTokenCallback?(true,token)
    }
    public func isRequestActionWith(uuid:String,binduuid:String)->Bool{
        return (uuid == binduuid)
    }
}

extension Double {
    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}


