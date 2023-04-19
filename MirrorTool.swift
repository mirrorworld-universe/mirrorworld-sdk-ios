//
//  MirrorTool.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/19.
//

import Foundation

@objc public class MirrorTool:NSObject{
    
    @objc public class func getInputInt(someString:String) -> Int{
            print("getTransactions input limit: \(String(describing: someString))")
            let formatter = NumberFormatter()
        let limit:Int = formatter.number(from: someString ) as! Int
            
        return limit
    }
   @objc public class func dicToString(_ dic:[String:Any]?) -> String? {
       guard let dictionary = dic else { return nil }
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: dictionary,options: .prettyPrinted)
            let convertedString = String(data: data1, encoding: .utf8)
            return convertedString
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    @objc public class func arrayToString(_ array:[Any]?) -> String? {
        guard let arr = array else { return nil }
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: arr,options: .prettyPrinted)
            let convertedString = String(data: data1, encoding: .utf8)
            return convertedString
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    
}
