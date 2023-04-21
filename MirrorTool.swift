//
//  MirrorTool.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/19.
//

import Foundation

@objc public class MirrorTool:NSObject{
    
    public class func getInputInt(someString:String) -> Int{
        if(someString.isEmpty){
            return 0
        }
        print("getTransactions input limit: \(String(describing: someString))")
        let formatter = NumberFormatter()
        if let limit = formatter.number(from: someString)?.intValue {
            return limit
        } else {
            return 0 // or any other default value you want to return
        }
    }
    public class func getInputDouble(someString: String) -> Double {
        if someString.isEmpty {
            return 0.0
        }
        print("getInputDouble input value: \(someString)")
        let formatter = NumberFormatter()
        if let doubleValue = formatter.number(from: someString)?.doubleValue {
            return doubleValue
        } else {
            return 0.0 // or any other default value you want to return
        }
    }
    public class func getInputConfirmation(someString:String) -> String{
        if(someString.isEmpty){
            return "confirmed"
        }else{
            return someString
        }
    }
    public class func getInputDouble(_ str: String) -> Double {
        return Double(str) ?? 0.0
    }
    
    public class func getContractType(str:String) -> String{
        if(str.isEmpty){
            return "erc1155"
        }
        if(str != "erc1155" && str != "erc721"){
            print("Unexcepted contract type:" + str)
            return "erc1155"
        }
        return str;
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
