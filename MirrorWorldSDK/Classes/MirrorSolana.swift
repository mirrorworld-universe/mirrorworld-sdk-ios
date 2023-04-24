//
//  MirrorSolana.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/12.
//

import Foundation

@objc public class MirrorSolana: MirrorBaseMoudle {
    var config:MirrorWorldSDKConfig?
    public var Wallet:SolanaWallet = SolanaWallet()
    public var Asset:SolanaAsset = SolanaAsset()
    public var Metadata:SolanaMetadata = SolanaMetadata()
}
