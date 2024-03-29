//
//  MirrorWorldSDKProtocol.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/24.
//

import Foundation

 public protocol MirrorWorldSDKProtocol:NSObjectProtocol {
    func loginListener(_ userInfo:[String:Any]?,_ onSuccess:Bool,_ onFail:Bool)
    func userInfo(_ userInfo:[String:Any]?)
    func getToken(_ userInfo:[String:Any]?)
    func loginOut(_ success:Bool?)
}



extension MirrorWorldSDKProtocol{
    func loginListener(_ userInfo:[String:Any]?,_ onSuccess:Bool,_ onFail:Bool){}
    func userInfo(_ userInfo:[String:Any]?){}
    func getToken(_ userInfo:[String:Any]?){}
    func loginOut(_ success:Bool?){}
}

enum MirrorWorldSchemeInfo {
    case userinfo(_ info:[String:Any]?)
    case wallet
    
    func saveInfo(){
        switch self {
        case .userinfo(let info):
            if info != nil {
                let data = try? JSONSerialization.data(withJSONObject:info!,options: [])
                if data != nil {
                    let str = String(data: data!,encoding:String.Encoding.utf8)
                    UserDefaults.standard.set(str, forKey: "mw_userinfo")
                    UserDefaults.standard.synchronize()
                }
            }
            
            break
        default:
            break
        }
    }
    func getInfo()->Any?{
        switch self {
        case .userinfo:
            return (UserDefaults.standard.object(forKey: "mw_userinfo") as? String)?.toJson()
        default:
            return nil
        }
    }
    func clearUserInfo(){
        
    }
    
}
public class MirrorWorldHandleProtocol:NSObject{
    
    var loginSuccess:((_ userInfo:[String:Any]?)->Void)?
    var loginFail:((_ errorDesc:String)->Void)?
   
    var onWalletLogOut:(()->())?
    
    var userInfoBolck:((_ userInfo:[String:Any]?)->Void)?
    var accessTokenBlock:((_ accessToken:String?)->())?
    var refreshTokenBlock:((_ refreshToken:String?)->())?
    var authorizationTokenBlock:((_ uuId:String?,_ refreshToken:String?)->())?
    
    func urlSchemeDecode(url:URL){
        
        MWLog.console("SDK received1:\(url)")

        guard let urlString = url.absoluteString.removingPercentEncoding else {
            MWLog.console("UrlScheme Decode failed !")
            return
        }
        MWLog.console("SDK received2:\(urlString)")

        let result = handleParam(paramsString: urlString)
        let keys = result?.keys
        if keys?.count ?? 0 > 0 {
            var access_tokenKey = ""
            var refresh_tokenKey = ""
            var userInfoObject:[String:Any]?
            var authorization_token = ""
            keys?.forEach({ key in
                let value = result?[key]
                if key == "access_token"{
                    var accToken = String(format: "%@",value ?? "")
                    accToken.removeFirst(1)
                    accToken.removeLast(1)
                    MirrorWorldSDKAuthData.share.access_token = accToken
                    accessTokenBlock?(accToken)
                    access_tokenKey = accToken
                    
                }
                if key == "refresh_token"{
                    var refreToken = String(format: "%@",value ?? "")
                    refreToken.removeFirst(1)
                    refreToken.removeLast(1)
                    MirrorWorldSDKAuthData.share.refresh_token = refreToken
                    MirrorWorldSDKAuthData.share.saveRefreshToken()
                    refreshTokenBlock?(refreToken)
                    refresh_tokenKey = refreToken
                }
                if key == "data"{
                    userInfoObject = value?.toJson()
                    MirrorWorldSDKAuthData.share.userInfo = userInfoObject
                    let schemeInfo = MirrorWorldSchemeInfo.userinfo(userInfoObject)
                    schemeInfo.saveInfo()
                }
                if key == "authorization_token"{
                    authorization_token = value ?? ""
                }
                
            })
           
            var loginResponse:[String:Any] = [:]
            loginResponse["user"] = userInfoObject
            loginResponse["refresh_token"] = refresh_tokenKey
            loginResponse["access_token"] = access_tokenKey
            MWLog.console("SDK received3:\(loginResponse)")
            loginSuccess?(loginResponse)
            
        }else{
            MWLog.console("UrlScheme No parameters.")
        }
    }
    func handleParam(paramsString:String) -> [String:String]?{
        guard paramsString.hasPrefix("mwsdk:") else{
            MWLog.console("Unsupported URLScheme type!")
            return nil
        }
        let schemeComponents = paramsString.components(separatedBy: "mwsdk://")
        guard schemeComponents.count > 0 else { return nil}
        let schemeValue = schemeComponents.last
        if (schemeValue?.hasPrefix("userinfo") ?? false){
            let data = schemeValue?.components(separatedBy: "userinfo?").last
            let params = data?.components(separatedBy: "&")
            var paramDic:[String:String] = [:]
            if params?.count ?? 0 > 0{
                params?.forEach({ item in
                    let key = item.components(separatedBy: "=").first
                    let value = item.components(separatedBy: "=").last
                    paramDic[key ?? ""] = value
                })
            }
            return paramDic
        }else if (schemeValue?.hasPrefix("data") ?? false){
            let data = schemeValue?.components(separatedBy: "data?").last
            let params = data?.components(separatedBy: "&")
            var paramDic:[String:String] = [:]
            if params?.count ?? 0 > 0{
                params?.forEach({ item in
                    let key = item.components(separatedBy: "=").first
                    let value = item.components(separatedBy: "=").last
                    paramDic[key ?? ""] = value
                })
            }
            return paramDic
        }else if (schemeValue?.hasPrefix("wallet") ?? false){
            MirrorWorldSDKAuthData.share.clearToken()
            onWalletLogOut?()
            return nil
        }else if (schemeValue?.hasPrefix("approve") ?? false){
            let approveData = schemeValue?.components(separatedBy: "approve?data=").last
            let authToken = (approveData?.toJson()?["authorization_token"] as? String) ?? ""
            let actionJson = approveData?.toJson()?["action"] as? [String:Any]
            let uuid = (actionJson?["uuid"] as? String) ?? ""
            authorizationTokenBlock?(uuid, authToken)
        }else {
            MWLog.console("unSupport the schemeType :")
            return nil
        }
       return nil
       
    }
    
    func handleUserInfo(data:String?)->[String:Any]?{
        return data?.toJson()
    }
}
public extension String{
    func toJson()->[String:Any]?{
        guard let data = self.data(using: .utf8) else { return nil}
        if let json = try? JSONSerialization.jsonObject(with: data,options: .mutableContainers) as? [String:Any]{
            return json
        }
        return nil
    }
}


/*
public extension [String:Any] {
    func toString() -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: self,options: .prettyPrinted)
            let convertedString = String(data: data1, encoding: .utf8)
            return convertedString
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
public extension [Any] {
    func toString() -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: self,options: .prettyPrinted)
            let convertedString = String(data: data1, encoding: .utf8)
            return convertedString
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
*/
