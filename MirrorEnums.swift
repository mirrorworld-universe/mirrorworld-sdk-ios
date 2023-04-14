//
//  MirrorEnums.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/13.
//

import Foundation
struct MWActionType {
    static let mintNFT = "mint_nft"
    static let updateNFT = "update_nft"
    static let transferSOL = "transfer_sol"
    static let transferSPLToken = "transfer_spl_token"
    static let createCollection = "create_collection"
    static let createSubCollection = "create_sub_collection"
    static let listNFT = "list_nft"
    static let buyNFT = "buy_nft"
    static let cancelListing = "cancel_listing"
    static let updateListing = "update_listing"
    static let transferNFT = "transfer_nft"
    static let interaction = "interaction"
    static let createMarketplace = "create_marketplace"
    static let updateMarketplace = "update_marketplace"
    static let transferBNB = "transfer_bnb"
    static let transferMATIC = "transfer_matic"
    static let transferETH = "transfer_eth"
    static let transferERC20Token = "transfer_erc20_token"
    static let signTransaction = "sign_transaction"
    static let personalSign = "personal_sign"
    static let signTypedData = "sign_typed_data"
    static let signTypedDataWithVersion = "sign_typed_data_with_version"
}
