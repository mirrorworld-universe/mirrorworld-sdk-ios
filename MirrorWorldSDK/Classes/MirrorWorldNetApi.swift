//
//  MirrorWorldNetApi.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/31.
//

public enum MirrorWorldNetApi{
    
    //Get:  Checks whether is authenticated or not and returns the user object if true
    case authMe
    
    // Get: Request refresh token for user
    case refreshToken(refresh_token:String)
    
    //POST: Logs out a user
    case loginOut
    
    case queryUser(email:String)
    
    case getWalletTokens
    
    case getWalletTransactions(limit:Int,next_before:String)
    
    case getWalletTransactionBySignature(signature:String)
    
    case TransferSOLtoAnotherAddress(to_publickey:String,amount:Int)
    
    case TransferTokenToAnotherAddress(to_publickey:String,amount:Int,token_mint:String,decimals:Int)
    
    
//MARK: - marketPlace api
    
    case FetchSingleNFT(_ mint_address:String)
    
    case MintNewCollection(_ param:[String:Any])
    
    case MintNewNFT(_ param:[String:Any])
    
    case TransferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String)
    
    
    case ListNFT(_ mint_address:String,_ price:Double,_ confirmation:String)
    
    
    
    var path:String{
        switch self {
        case .authMe:
            return "auth/me"
        case .loginOut:
            return "auth/logout"
        case .refreshToken:
            return "auth/refresh-token"
        case .queryUser:
            return "auth/user"
        case .getWalletTokens:
            return "wallet/tokens"
        case .getWalletTransactions:
            return "wallet/transactions"
        case .getWalletTransactionBySignature(let signature):
            return "wallet/transactions/\(signature)"
        case .TransferSOLtoAnotherAddress:
            return "wallet/transfer-sol"
        case .TransferTokenToAnotherAddress:
            return "wallet/transfer-token"
        case .MintNewNFT:
            return "solana/mint/nft"
        case .MintNewCollection:
            return "solana/mint/collection"
        case .FetchSingleNFT(let path):
            return "solana/nft/\(path)"
        case .TransferNFTToAnotherSolanaWallet:
            return "solana/marketplace/transfer"
        case .ListNFT:
            return "solana/marketplace/transaction/list"
        }
        
    }
    
    var param:[String:Any]?{
        switch self {
        case .refreshToken(let refresh_token):
            return ["x-refresh-token":refresh_token]
        case .queryUser(let _):
            return nil
        case .getWalletTransactions(let limit, let next_before):
            return ["limit":limit,"next_before":next_before]
        case .TransferSOLtoAnotherAddress(let to_publickey, let amount):
            return ["to_publickey":to_publickey,"amount":amount]
        case .TransferTokenToAnotherAddress(let to_publickey ,let amount, let token_mint, let decimals):
            return ["to_publickey":to_publickey,"amount":amount,"token_mint":token_mint,"decimals":decimals]
        case .MintNewNFT(let param):
            return param
        case .MintNewCollection(let param):
            return param
        case .TransferNFTToAnotherSolanaWallet(let mint_address , let to_wallet_address,let confirmation):
            return ["mint_address":mint_address,"to_wallet_address":to_wallet_address,"confirmation":confirmation]
        case .ListNFT(let mint_address, let price, let confirmation):
            return ["mint_address":mint_address,"price":price,"confirmation":confirmation]
        default:
            return nil
           
        }
    }
    
    var method:String{
        switch self {
        case .authMe,.refreshToken,.queryUser,.getWalletTransactions:
            return "GET"
        case .loginOut,.TransferSOLtoAnotherAddress,.TransferTokenToAnotherAddress:
            return "POST"
        case .MintNewNFT,.MintNewCollection:
            return "POST"
        case .FetchSingleNFT:
            return "GET"
        case .TransferNFTToAnotherSolanaWallet,.ListNFT:
            return "POST"
        default:
            return "GET"
        }
    }
    func serverUrl(env:MWEnvironment) -> String {
        switch self {
        case .authMe,.refreshToken:
            return env.ssoRoot + path
        case .loginOut:
            return env.ssoRoot + path
        case .queryUser(let email):
            return env.ssoRoot + path + "?email=\(email)"
        case .getWalletTokens:
            return env.apiRoot + path
        case .getWalletTransactions,.getWalletTransactionBySignature:
            return env.apiRoot + path
        case .TransferSOLtoAnotherAddress,.TransferTokenToAnotherAddress:
            return env.apiRoot + path
        case .MintNewNFT,.MintNewCollection:
            return env.apiRoot + path
        case .FetchSingleNFT:
            return env.apiRoot + path
        case .ListNFT:
            return env.apiRoot + path
        default:
            return env.ssoRoot + path
            
        }
    }
    
    
}
