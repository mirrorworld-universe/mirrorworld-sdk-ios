//
//  MirrorWorldNetWork.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/25.
//

import UIKit

@objc public class MirrorWorldNetWork: NSObject {
    
    public func request(api:MirrorWorldNetApi,_ success:((_ response:String?)->())?,_ faild:((_ code:Int,_ errorDesc:String)->())?){
        let urlPath = api.serverUrl(env: MWSDK.sdkConfig.environment)
        let url:URL = URL(string: urlPath)!
        
//        let sessionConfigure = URLSessionConfiguration.default
//        sessionConfigure.httpAdditionalHeaders = ["Content-Type": "application/json"]
//        sessionConfigure.timeoutIntervalForRequest = 30
//        sessionConfigure.requestCachePolicy = .reloadIgnoringLocalCacheData
//        let session = URLSession(configuration: sessionConfigure)
        
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = api.method
        request.setValue(MWSDK.sdkConfig.apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let access_token = MirrorWorldSDKAuthData.share.access_token
        if access_token.count > 0 {
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        }else{
            MWLog.console("access_token is nil !")
        }
        if api.method == "GET"{
            let keys = api.param?.keys
            if keys?.count ?? 0 > 0 {
                keys?.forEach({ k in
                    let value = api.param?[k] as? String
                    let headerField = String(format: "%@", k)
                    request.setValue(value, forHTTPHeaderField: headerField)
                })
            }
        }
        
        if api.method == "POST" {
//            let postString = api.param?.compactMap({ (key,value) ->String in
//                return "\(key)=\(value)"
//            }).joined(separator: "&")
//            request.httpBody = postString?.data(using: .utf8)
            let bodyString = api.param?.toString()
            request.httpBody = bodyString?.data(using: .utf8)
        }
        
        
        let task = session.dataTask(with: request as URLRequest) { (
            data, response, error) in
            guard let data = data, let _:URLResponse = response, error == nil else {
                faild?(error?._code ?? -1,error.debugDescription)
                return }
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            MWLog.console("\n========================================\n")
            MWLog.console(request.url?.absoluteString)
            MWLog.console((dataString ?? "null"))
            MWLog.console("\n========================================\n")
            success?(dataString)
        }
        task.resume()
    }
 
    
}
