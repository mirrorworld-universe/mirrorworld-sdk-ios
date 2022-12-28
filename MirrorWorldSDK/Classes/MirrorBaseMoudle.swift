//
//  MirrorBaseMoudle.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/20.
//
import UIKit

public typealias onSuccess = ((_ data:String?)->Void)?
public typealias onFailed = ((_ code:Int,_ message:String?)->Void)?
@objc public class MirrorBaseMoudle:NSObject{
    
    /// authorization
    public var authorization:MirrorSecurityVerification = MirrorSecurityVerification()
    
    ///
    func checkAccessToken(finish:((_ succ:Bool)->Void)?){
        let accessToken = MirrorWorldSDKAuthData.share.access_token
        if accessToken.count == 0{
            MirrorWorldSDKAuthData.share.getRefreshToken()

            let api = MirrorWorldNetApi.refreshToken(refresh_token: MirrorWorldSDKAuthData.share.refresh_token)
            MirrorWorldNetWork().request(api: api) { response in
                let responseJson = response?.toJson()
                let data = responseJson?["data"] as? [String:Any]
                let user = data?["user"] as? [String:Any]
                let refreshToken = data?["refresh_token"] as? String
                let accessToken = data?["access_token"] as? String
                MirrorWorldSDKAuthData.share.refresh_token = refreshToken ?? ""
                MirrorWorldSDKAuthData.share.saveRefreshToken()
                MirrorWorldSDKAuthData.share.access_token = accessToken ?? ""
                MirrorWorldSDKAuthData.share.userInfo = user
                DispatchQueue.main.async {
                    finish?(true)
                }
            } _: { code,errorDesc in
                DispatchQueue.main.async {
                    finish?(false)
                }
            }

        }else{
            MWLog.console("AccessToken already exists.")
            finish?(true)
        }

    }
    
    func handleResponse(response:String?,success:((_ response:String?)->Void)?,failed:((_ code: Int,_ message:String)->())?) {
        let responseJson = response?.toJson()
        let code = responseJson?["code"] as? Int ?? -1
        let _ = responseJson?["error"] as? String ?? ""
        let message = responseJson?["message"] as? String ?? ""
        let _ = responseJson?["status"] as? String ?? ""
       
        var dataString:String? = ""
        if responseJson?["data"] is Array<Any>{
            let data = responseJson?["data"] as? [Any]
//            dataString = data?.toString()
            dataString = MirrorTool.arrayToString(data)
        }else{
            let data = responseJson?["data"] as? [String:Any]
//            dataString = data?.toString()
            dataString = MirrorTool.dicToString(data)
        }
//        if responseJson?["data"] is String{
//            
//        }
       
        DispatchQueue.main.async {
            if code == 0 {
                success?(dataString)
            }else{
                failed?(code,message)
            }
        }
    }
}
