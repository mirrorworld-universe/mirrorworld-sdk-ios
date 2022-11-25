//
//  MirrorWorldLog.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/24.
//

import Foundation

public enum MirrorWorldLogLevel{
    case fatal
    case error
    case warn
    case info
    case debug
    case all
}



public let MWLog = MirrorWorldLog.shard
public class MirrorWorldLog: NSObject {
    public static let shard = MirrorWorldLog()
    public var isDebug:Bool = true
    public var logLevel:MirrorWorldLogLevel = .warn
    public func console(_ text:Any?){
        guard let log = text else {return}
//        #if DEBUG
//        #else
//        #endif
        if isDebug{
            print("<iOS_MWSDK_LOG>: \(log)")
        }
    }
}











