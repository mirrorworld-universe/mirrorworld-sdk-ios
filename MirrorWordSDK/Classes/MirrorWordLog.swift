//
//  MirrorWordLog.swift
//  MirrorWordSDK
//
//  Created by ZMG on 2022/10/24.
//

import Foundation

public enum MirrorWordLogLevel{
    case fatal
    case error
    case warn
    case info
    case debug
    case all
}



public let MWLog = MirrorWordLog.shard
public class MirrorWordLog: NSObject {
    public static let shard = MirrorWordLog()
    public var logLevel:MirrorWordLogLevel = .warn
    public func console(_ text:Any?){
        guard let log = text else {return}
        #if DEBUG
        print("MWSDK:- \(log)")
        #else
        #endif
    }
}











