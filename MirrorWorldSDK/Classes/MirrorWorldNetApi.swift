//
//  MirrorWorldNetApi.swift
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/10/31.
//

public enum MirrorWorldNetApi{
    
    //Get:  Checks whether is authenticated or not and returns the user object if true
    
    case requestActionAuthorization(type:String,message:String,value:Double,params:[String:Any])
    
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
    
    case CreateVerifiedSubCollection(name:String,collection_mint:String,symbol:String,url:String,confirmation:String)
    
    case MintNewNFT(_ param:[String:Any])
    
    case TransferNFTToAnotherSolanaWallet(mint_address:String,to_wallet_address:String,confirmation:String)
    
    
    case ListNFT(_ mint_address:String,_ price:Double,_ confirmation:String)
    
    case UpdateNFTListing(mint_address:String,price:Double, confirmation:String)
    
    case cancelNFTListing(mint_address:String,price:Double)
    
    case BuyNFT(mint_address:String,price:Double,confirmation:String)
    
    
    case FetchNFTsByMintAddresses(mint_addresses:[String])
   
    case FetchNFTsByCreatorAddresses(creators:[String],limit:Double,offset:Double)
    case FetchNFTsByUpdateAuthorities(update_authorities:[String],limit:Double,offset:Double)
    
    case FetchNFTsByOwnerAddress(owners:[String],limit:Double,offset:Double)

    
    var path:String{
        switch self {
        case .requestActionAuthorization:
            return "auth/actions/request"
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
            return "solana/marketplace/list"
        case .UpdateNFTListing:
            return "solana/marketplace/update"
        case .cancelNFTListing:
            return "solana/marketplace/cancel"
        case .FetchNFTsByMintAddresses:
            return "solana/nft/mints"
        case .FetchNFTsByCreatorAddresses:
            return "solana/nft/creators"
        case .FetchNFTsByUpdateAuthorities:
            return "solana/nft/update-authorities"
        case .FetchNFTsByOwnerAddress:
            return "solana/nft/owners"
        case .BuyNFT:
            return "solana/marketplace/buy"
        case .CreateVerifiedSubCollection:
            return "solana/mint/sub-collection"
        }
        
    }
    
    var param:[String:Any]?{
        switch self {
        case .requestActionAuthorization(let type,let message,let value, let params):
            return ["type":type,
                    "message":message,
                    "value":value,
                    "params":params]
        case .refreshToken(let refresh_token):
            return ["x-refresh-token":refresh_token]
        case .queryUser:
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
        case .UpdateNFTListing(let mint_address, let price, let confirmation):
            return ["mint_address":mint_address,"price":price,"confirmation":confirmation]
        case .cancelNFTListing(let mint_address,let price):
            return ["mint_address":mint_address,"price":price]
        case .FetchNFTsByMintAddresses(let mint_addresses):
            return ["mint_addresses":mint_addresses]
        case .FetchNFTsByCreatorAddresses(let creators, let limit, let offset):
            return ["creators":creators,"limit":limit,"offset":offset]
        case .FetchNFTsByUpdateAuthorities(let update_authorities ,let limit ,let offset):
            return ["update_authorities":update_authorities,"limit":limit,"offset":offset]
        case .FetchNFTsByOwnerAddress(let owners,let limit,let offset):
            return ["owners":owners,"limit":limit,"offset":offset]
        case .BuyNFT(let mint_address,let price,let confirmation):
            return ["mint_address":mint_address,"price":price,"confirmation":confirmation]
        case .CreateVerifiedSubCollection(let name,let collection_mint,let symbol,let url,let confirmation):
            return ["name":name,"collection_mint":collection_mint,"symbol":symbol,"url":url,"confirmation":confirmation]
        default:
            return nil
           
        }
    }
    
    var actionType:String{
        switch self {
        case .MintNewNFT:
            return "mint_nft"
        case .TransferSOLtoAnotherAddress:
            return "transfer_sol"
        case .TransferTokenToAnotherAddress:
            return "transfer_spl_token"
        case .MintNewCollection:
            return "create_collection"
        case .ListNFT:
            return "list_nft"
        case .BuyNFT:
            return "buy_nft"
        case .cancelNFTListing:
            return "cancel_listing"
        case .UpdateNFTListing:
            return "update_listing"
        case .TransferNFTToAnotherSolanaWallet:
            return "transfer_nft"
//            10. create_marketplace - Create a new marketplace instance
//            11. update_marketplace - Update the marketplace instance
        default :
            return "interaction"
        }
        
    }
    
    
    var method:String{
        switch self {
        case .requestActionAuthorization:
            return "POST"
        case .authMe,.refreshToken,.queryUser,.getWalletTransactions:
            return "GET"
        case .loginOut,.TransferSOLtoAnotherAddress,.TransferTokenToAnotherAddress:
            return "POST"
        case .MintNewNFT,.MintNewCollection:
            return "POST"
        case .FetchSingleNFT:
            return "GET"
        case .TransferNFTToAnotherSolanaWallet,.ListNFT,.UpdateNFTListing:
            return "POST"
        case .cancelNFTListing,.FetchNFTsByMintAddresses,.FetchNFTsByCreatorAddresses,.FetchNFTsByUpdateAuthorities,.FetchNFTsByOwnerAddress,.BuyNFT:
            return "POST"
        case .CreateVerifiedSubCollection:
            return "POST"
        default:
            return "GET"
        }
    }
    func serverUrl(env:MWEnvironment) -> String {
        switch self {
        case .requestActionAuthorization:
            return env.ssoRoot + path
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
        case .cancelNFTListing:
            return env.apiRoot + path
        case .FetchNFTsByMintAddresses,.FetchNFTsByCreatorAddresses,.FetchNFTsByOwnerAddress,.FetchNFTsByUpdateAuthorities:
            return env.apiRoot + path
        case .BuyNFT:
            return env.apiRoot + path
        case .CreateVerifiedSubCollection:
            return env.apiRoot + path
        default:
            return env.apiRoot + path
            
        }
    }
    
    
}
