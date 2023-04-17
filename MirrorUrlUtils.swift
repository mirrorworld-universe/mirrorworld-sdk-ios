//
//  MirrorUrlUtils.swift
//  MirrorWorldSDK
//
//  Created by squall on 2023/4/13.
//

import Foundation

class MirrorUrlUtils :NSObject{
    public static let shard = MirrorUrlUtils()
    public var chain:MWChain = MWChain.Solana
    public var env:MWEnvironment = MWEnvironment.DevNet
    private var inited:Bool = false;
    
    public func initSDKParams(chain:MWChain,env:MWEnvironment){
        self.chain = chain
        self.env = env
        self.inited = true
    }
    
    public func getMirrorUrl(serviceEnum:MirrorService ,APIPath:String) -> String{
        if(!self.inited){
            MirrorWorldLog.shard.console("MirrorUrlUtils not inited!")
            return ""
        }
        var host = getUrlHost(service:serviceEnum);
        var version = "v2";
        var chainStr = getChainString();
        var network = getNetworkString();

        var finalUrl = "\(host)/\(version)/\(chainStr)/\(network)/\(serviceEnum)/\(APIPath)";
        return finalUrl;
    }
    
    public func getActionRoot()->String{
        let version = "v2"
        if(env == MWEnvironment.StagingMainNet){
            return "https://api-staging.mirrorworld.fun/"+version+"/";
        }else if(env == MWEnvironment.StagingDevNet){
            return "https://api-staging.mirrorworld.fun/"+version+"/";
        }else if(env == MWEnvironment.DevNet){
            return "https://api.mirrorworld.fun/"+version+"/";
        }else if(env == MWEnvironment.MainNet){
            return "https://api.mirrorworld.fun/"+version+"/";
        }else {
            MirrorWorldLog.shard.console("Unknown env:\(env)");
            return "https://api.mirrorworld.fun/v1/";
        }
    }
    
    private func getUrlHost(service:MirrorService) -> String{
        if(service == MirrorService.Wallet || belongToAsset(service: service) || belongToMetadata(service: service)
        || service == MirrorService.AssetConfirmation){
            if(env == MWEnvironment.StagingMainNet){
                return "https://api-staging.mirrorworld.fun";
            }else if(env == MWEnvironment.StagingDevNet){
                return "https://api-staging.mirrorworld.fun";
            }else if(env == MWEnvironment.DevNet){
                return "https://api.mirrorworld.fun";
            }else if(env == MWEnvironment.MainNet){
                return "https://api.mirrorworld.fun";
            }else {
                MirrorWorldLog.shard.console("Unknown env:\(env)");
                return "https://api-staging.mirrorworld.fun";
            }
        }else {
            if(env == MWEnvironment.StagingMainNet){
                return "https://auth-staging.mirrorworld.fun";
            }else if(env == MWEnvironment.StagingDevNet){
                return "https://auth-staging.mirrorworld.fun";
            }else if(env == MWEnvironment.DevNet){
                return "https://auth.mirrorworld.fun";
            }else if(env == MWEnvironment.MainNet){
                return "https://auth.mirrorworld.fun";
            }else {
                MirrorWorldLog.shard.console("Unknown env:\(env).Will use production host.");
                return "https://auth.mirrorworld.fun";
            }
        }
    }
    
    
    private func getChainString() -> String{
        if(chain == MWChain.Solana){
            return "solana";
        }else if(chain == MWChain.Ethereum){
            return "ethereum";
        }else if(chain == MWChain.Polygon){
            return "polygon";
        }else if(chain == MWChain.BNB){
            return "bnb";
        }else if(chain == MWChain.SUI){
            return "sui";
        }else {
            MirrorWorldLog.shard.console("Invalida chain enum:\(chain)");
            return "solana";
        }
    }

    
    private func getNetworkString() -> String{
        if(chain == MWChain.Solana){
            if(env == MWEnvironment.StagingMainNet){
                return "mainnet-beta";
            }else if(env == MWEnvironment.StagingDevNet){
                return "devnet";
            }else if(env == MWEnvironment.MainNet){
                return "mainnet-beta";
            }else if(env == MWEnvironment.DevNet){
                return "devnet";
            }else {
                MirrorWorldLog.shard.console("Unknown env: \(env).Will use mainnet.");
                return "devnet";
            }
        }else if(chain == MWChain.Ethereum){
            if(env == MWEnvironment.StagingMainNet){
                return "mainnet";
            }else if(env == MWEnvironment.StagingDevNet){
                return "goerli";
            }else if(env == MWEnvironment.MainNet){
                return "mainnet";
            }else if(env == MWEnvironment.DevNet){
                return "goerli";
            }else {
                MirrorWorldLog.shard.console("Unknown env:\(env).Will use mainnet.");
                return "goerli";
            }
        }else if(chain == MWChain.Polygon){
            if(env == MWEnvironment.StagingMainNet){
                return "mumbai-mainnet";
            }else if(env == MWEnvironment.StagingDevNet){
                return "mumbai-testnet";
            }else if(env == MWEnvironment.MainNet){
                return "mumbai-mainnet";
            }else if(env == MWEnvironment.DevNet){
                return "mumbai-testnet";
            }else {
                MirrorWorldLog.shard.console("Unknown env: \(env).Will use mainnet.");
                return "mumbai-testnet";
            }
        }else if(chain == MWChain.BNB){
            if(env == MWEnvironment.StagingMainNet){
                return "bnb-mainnet";
            }else if(env == MWEnvironment.StagingDevNet){
                return "bnb-testnet";
            }else if(env == MWEnvironment.MainNet){
                return "bnb-mainnet";
            }else if(env == MWEnvironment.DevNet){
                return "bnb-testnet";
            }else {
                MirrorWorldLog.shard.console("Unknown env: \(env).Will use mainnet.");
                return "bnb-testnet";
            }
        }
        else {
            MirrorWorldLog.shard.console("MirrorSDK Unknwon chain \(chain)");
            return "unknwon-net";
        }
    }
    
    private func getServiceString( serviceEnum:MirrorService) -> String{
        if(serviceEnum == MirrorService.Marketplace){
            return "marketplaces";
        }else if(serviceEnum == MirrorService.Wallet){
            return "wallet";
        }else if(serviceEnum == MirrorService.AssetAuction){
            return "asset/auction";
        }else if(serviceEnum == MirrorService.AssetMint){
            return "asset/mint";
        }else if(serviceEnum == MirrorService.AssetNFT){
            return "asset/nft";
        }else if(serviceEnum == MirrorService.AssetConfirmation){
            return "asset/confirmation";
        }else if(serviceEnum == MirrorService.Metadata){
            return "metadata";
        }else if(serviceEnum == MirrorService.MetadataCollection){
            return "metadata/collection";
        }else if(serviceEnum == MirrorService.MetadataNFT){
            return "metadata/nft";
        }else if(serviceEnum == MirrorService.MetadataNFTSearch){
            return "metadata/nft/search";
        }else if(serviceEnum == MirrorService.MetadataNFTMarketplace){
            return "metadata/marketplace";
        }else {
            MirrorWorldLog.shard.console("Unknown service:\(serviceEnum)");
            return "";
        }
    }
    
    private func belongToAsset( service:MirrorService) -> Bool{
        return service == MirrorService.AssetAuction || service == MirrorService.AssetMint || service == MirrorService.AssetNFT;
    }

    private func belongToMetadata( service:MirrorService) -> Bool{
        return service == MirrorService.Metadata || service == MirrorService.MetadataNFT
                || service == MirrorService.MetadataCollection || service == MirrorService.MetadataNFTSearch;
    }
}


@objc public enum MirrorService :Int{
    case AssetAuction
    case AssetMint
    case AssetNFT
    case AssetConfirmation
    case Metadata
    case MetadataCollection
    case MetadataNFT
    case MetadataNFTSearch
    case MetadataNFTMarketplace
    case Marketplace
    case Wallet
}
