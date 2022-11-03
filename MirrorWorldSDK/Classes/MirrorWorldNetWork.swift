//
//  MirrorWorldNetWork.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/25.
//

import UIKit

@objc public class MirrorWorldNetWork: NSObject {
    
    public func request(api:MirrorWorldNetApi,_ success:((_ response:String?)->())?,_ faild:((_ errorDesc:String)->())?){
        let urlPath = api.serverUrl(env: MWSDK.sdkConfig.environment)
        let url:URL = URL(string: urlPath)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = api.method
        request.setValue(MWSDK.sdkConfig.apiKey, forHTTPHeaderField: "x-api-key")
        let access_token = MirrorWorldSDKAuthData.share.access_token
        if access_token.count > 0 {
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        }else{
            MWLog.console("access_token is nil !")
        }
//        curl --location --request GET 'https://api-staging.mirrorworld.fun/v1/auth/user?email=email@example.com' \
//        --header 'x-api-key: <API_KEY>'
        let keys = api.param?.keys
        if keys?.count ?? 0 > 0 {
            keys?.forEach({ k in
                let value = api.param?[k] as? String
                let headerField = String(format: "%@", k)
                request.setValue(value, forHTTPHeaderField: headerField)
            })
        }
        let task = session.dataTask(with: request as URLRequest) { (
            data, response, error) in
            guard let data = data, let _:URLResponse = response, error == nil else {
                faild?(error.debugDescription)
                return }
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            success?(dataString)
        }
        task.resume()
    }
 
    
}
