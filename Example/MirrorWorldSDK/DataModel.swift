//
//  DataModel.swift
//  MirrorWorldSDK_Example
//
//  Created by squall on 2023/4/11.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import MirrorWorldSDK
class DataModel {
    static let shared = DataModel()
    
    var title:String?
    var chain:MWChain?
    var data: Any?
}
