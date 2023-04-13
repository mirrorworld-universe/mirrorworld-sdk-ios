//
//  MirrorSolana.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/12.
//

import Foundation

@objc public class MirrorSolana: MirrorBaseMoudle {
    var config:MirrorWorldSDKConfig?
    public var wallet:MirrorWalletMoudle = MirrorWalletMoudle()
    public var asset:MirrorMarketplaceMoudle = MirrorMarketplaceMoudle()
    private var metedataFilterMoudle:MirrorMetadataFilterMoudle = MirrorMetadataFilterMoudle()
}
