//
//  MirrorWordNetWork.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/10/25.
//

import UIKit

public class MirrorWordNetWork: NSObject {
    
    /// get
    public func request(api:MirrorWordNetApi,_ success:((_ response:String?)->())?,_ faild:((_ errorDesc:String)->())?){
        let urlPath = api.serverUrl(env: MWSDK.sdkConfig.environment)
        let url:URL = URL(string: urlPath)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = api.method
        request.setValue(MWSDK.sdkConfig.apiKey, forHTTPHeaderField: "x-api-key")
        let access_token = MirrorWordSDKAuthData.share.access_token
        if access_token.count > 0 {
            request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        }
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
