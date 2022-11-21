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
    func handleResponse(response:String?,success:((_ response:String?)->Void)?,failed:((_ code: Int,_ message:String)->())?) {
        let responseJson = response?.toJson()
        let code = responseJson?["code"] as? Int ?? -1
        let _ = responseJson?["error"] as? String ?? ""
        let message = responseJson?["message"] as? String ?? ""
        let status = responseJson?["status"] as? String ?? ""
        let data = responseJson?["data"] as? [String:Any]
        let dataString = data?.toString()
        DispatchQueue.main.async {
            if code == 0 {
                success?(dataString)
            }else{
                failed?(code,message)
            }
        }
    }
}
