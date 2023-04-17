//
//  MirrorSolana.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/12.
//

import Foundation

@objc public class MirrorEVM: MirrorBaseMoudle {
    var config:MirrorWorldSDKConfig?
    public var Asset:EVMAsset = EVMAsset()
    public var Wallet:EVMWallet = EVMWallet()
    public var Metadata:EVMMetadata = EVMMetadata()
}
