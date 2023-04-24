# MirrorWorldSDK

[![CI Status](https://img.shields.io/travis/791738673@qq.com/MirrorWorldSDK.svg?style=flat)](https://travis-ci.org/791738673@qq.com/MirrorWorldSDK)
[![Version](https://img.shields.io/cocoapods/v/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)
[![License](https://img.shields.io/cocoapods/l/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)
[![Platform](https://img.shields.io/cocoapods/p/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)

## Introduction to Mirror World

- The Mirror World Smart SDK is a cross-platform interface that provides simple, declarative API interfaces for building Mobile and Web Applications into Web 3 Architecture.

## Supported iOS & SDK Versions

- iOS 11.0+
- Swift
- Objective-C/C++/C

## Installation

MirrorWorldSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
pod 'MirrorWorldSDK'
end

```

Then, run the following command:

```sh
pod install
```

## Getting started

Create a developer account on the Developer dashboard <https://app.mirrorworld.fun/> . Create project and create an API Key.

## Usage

`First, you should configure UrlScheme(mwsdk) in your project`

Set UrlScheme in the info.plist file of your project ： `mwsdk`

like this:
![Image text](https://github.com/mirrorworld-universe/mirrorworld-sdk-ios/blob/master/Example/MirrorWorldSDK/infoplist-UrlScheme-desc.png)

Then

```Swift
import MirrorWorldSDK

```

init SDK in the AppDelegate.

```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
   
    MWSDK.initSDK(env: .StagingDevNet, apiKey: "Your API Key")
    
    // ---------
    return true
}

func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    MirrorWorldSDK.share.handleOpen(url: url)
    return true
}

```

## Choose your chain
Mirror World SDK supports multi-chain operation. You can use different instance to call all chains' API.
- For all client APIs: the instance is MWSDK
- For all Solana APIs: the instance is MWSDK.Solana
- For all EVM APIs: the instance is MWSDK.EVM. EVM include Ethereum\Polygon\BNB.

There are three modules in the Mirror World SDK: Wallet, Asset, and Metadata. You can use different modules depending on which type of APIs you want to call.

*For example, a user use MWSDK.startLogin() to let user login and use MWSDK.Solana.Wallet.getTokens() to check his tokens.*


### Client APIs
*This kind of API doesn't belong to any module, you can just use MWSDK.functionName to call it.*

- startLogin

Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.

```Swift
MWSDK.startLogin { userInfo in
    print("login success :\(MirrorTool.dicToString(userInfo) ?? "")")
} onFail: {
    print("login failed!")
}
```

- loginWithEmail

Allow the user to log in using their email and password. Only after logging in, the user can use other APIs.

```Swift
MWSDK.loginWithEmail(email: email, passWord: password) {
    print("email login success")
} onFail: {
    print("email login success")
}
```

- guestLogin

Use this API to make a user logged in as a guest who has a new account and a new wallet.
```Swift
MWSDK.guestLogin {
    print("guest login success")
} onFail: {
    print("guest login failed")
}
```

- isLogged

Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.

```Swift
MWSDK.isLogged { onBool in
    print("This device's login state is:\(onBool)")
}
```

- Logout

```Swift
MWSDK.Logout {
    print("Logs out a user : success")
} onFail: {
    print("Logs out a user : failed !")
}
```

- openWallet

Open a webview which would show the wallet page.

```Swift
MWSDK.openWallet {
    print("Wallet is logout")
    
} loginSuccess: { userinfo in
    print("Wallet login: \(String(describing: userinfo))")
}
```

- openMarket
Open the market place page which publish before.
You can refer to [How to publish self Storefront](https://docs.mirrorworld.fun/overview/storefront).
```Swift
let marketUrl = "Your market place url"
MWSDK.openMarket(url: url)
```

- QueryUser

Check user's info, then we can get user's base information such as wallet address and so on.

```Swift
MWSDK.QueryUser(email: email) { user in
    print(user ?? "null")
} onFetchFailed: { code, error in
    print("\(code):\(String(describing: error))")
}
```


### Wallet Methods

*This kind of API are all belong to mudule 'Wallet'. To use them, you can call MWSDK.ChainName.functionName.*

- getTokens
Allow users to check their tokens in their wallet.
```Swift
MWSDK.Solana.Wallet.getTokens { response in
    let res = response?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    
    print("Get wallet tokens:\(res ?? "null")")
    loadingActive.stopAnimating()
} onFailed: {
    print("Get wallet tokens: failed")
}
```

- getTokensByWallet
Allow users to check wallet tokens by a wallet address.
```Swift
MWSDK.Solana.Wallet.getTokensByWallet(wallet_address: to_wallet_address) { response in
    print("success, result is:\(String(describing: response))")
} onFailed: {
    print("failed ~")
}
```

- getTransactions
Get transactions that belong to the current wallet.
```Swift
MWSDK.Solana.Wallet.getTransactions(limit: Int(limit) , next_before: next_before) { response in
    print("success, result is:\(String(describing: response))")
} onFailed: {
    print("failed ~")
}
```

- getTransactionsByWallet
Get transactions that belong to a wallet.
```Swift
MWSDK.Solana.Wallet.getTransactionsByWallet(wallet_address:wallet_address, limit: limit, next_before: next_before){ response in
    print(response)
} onFailed: {
    print("failed~")
}
```

- getTransactionBySignature
Get transaction by a signature address.
```Swift
MWSDK.Solana.Wallet.getTransactionBySignature(signature: signature) { response in
    print(response)
} onFailed: {
    print("failed~")
}
```

- transferSOL
Transfer SOL to another wallet.
```Swift
MWSDK.Solana.Wallet.transferSOL(to_publickey: to_publickey, amount: Int(amount) ) { response in
    print(response)
} onFailed: {
    print("failed~")
}
```

- transferToken
Transfer Token to another wallet.
```Swift
MWSDK.Solana.Wallet.transferToken(to_publickey: to_publickey, amount: Int(Double(amount) ?? 0.0), token_mint: token_mint, decimals: Int(decimals) ?? 1) { response in
    print(response)
} onFailed: {
    print("failed~")
}
```

## Asset APIs
*This kind of API belongs to 'Asset' module, you can just use 'MWSDK.ChainName.Asset.functionName' to call it.*

- buyNFT

Buy a NFT on market place.
```Swift
MWSDK.Solana.Asset.buyNFT(mint_address: mint_address, price: Double(price) ?? 0.01,auction_house: auction_house,confirmation: confirmation,skip_preflight: skip_preflight) { data in
    print(data)
} onFailed: { code, message in
    print("failed:\(code),\(message ?? "")")
}
```

- cancelNFTListing
Cancel listing of NFT.

```Swift
MWSDK.Solana.Asset.cancelNFTListing(mint_address: mint_address, price: Double(price) ?? 1.1,auction_house: auction_house,confirmation: confirmation,skip_preflight: skip_preflight) { data in
    print(data)

} onFailed: { code, message in
    print("failed:\(code),\(message ?? "")")
}
```

- listNFT
List a NFT on market place.

```Swift
MWSDK.Solana.Asset.listNFT(mint_address: mint_address, price: Double(price) ?? 0.1,auction_house: auction_house, confirmation: "finalized",skip_preflight: skip_preflight) { data in
    self.Log(data)
} onFailed: { code, message in
    self.Log("failed:\(code),\(message ?? "")")
}
```

- transferNFT
Transfer NFT to another Sol wallet.

```Swift
MWSDK.Solana.Asset.transferNFT(mint_address: mint_address, to_wallet_address: to_wallet_address, confirmation: confirmation, skip_preflight: skip_preflight,onSuccess: { data in
    self.Log(data)

},onFailed: { code, message in
    self.Log("failed:\(code),\(message ?? "")")
})
```

- checkMintingStatus

Get status of a minting operation. Because minting may has some delay before success.
```Swift
MWSDK.Solana.Asset.checkMintingStatus(mint_addresses: [mint_address,another_address],onSuccess: { data in
    print("Check status of Minting result is:\(String(describing: data))")
},onFailed:{ code,errorDesc in
    print("Check status of Minting error(\(code)),desc is:\(String(describing: errorDesc))")
})
```

- checkTransactionsStatus

Get status of transactions by their signatures.
```Swift
MWSDK.Solana.Asset.checkTransactionsStatus(signatures: [signature,another_signature]) { data in
    print(data)
} onFailed: { code, message in
    print("CheckStatusOfTransactions failed,code is:\(code);message:\(String(describing: message))")
}
```

- mintCollection
Mint a parent NFT collection.

```Swift
MWSDK.Solana.Asset.mintCollection(url:url,name: name, symbol: symbol, to_wallet_address: to_wallet_address, seller_fee_basis_points: Int(seller_fee_basis_points) ,confirmation:confirmation,skip_preflight:skip_preflight, onSuccess: { data in
    print(data)
}, onFailed: { code,message in
    print("failed:\(code),\(message ?? "")")
})
```

- mintNFT
Mint a new NFT.

```Swift
MWSDK.Solana.Asset.mintNFT(collection_mint: collection_mint, url: url, to_wallet_address: to_wallet_address, seller_fee_basis_points: seller_fee_basis_points, confirmation: confirmation, skip_preflight: skip_preflight){ data in
    print("mintNewNFT - response:\n")
} onFailed: { code, message in
    print("\(item):failed:\(code),\(message ?? "")")
}
```

- updateNFT
Update properties of a NFT.
```Swift
let mintAddress = "NFT mint address"
let name = "Awsom NFT"
let symbol = "My symbol"
let updateAuthority = "Update authority"
let url = "Your NFT json url"
let points = 100
let confirmation = "confirmed"

MWSDK.Solana.Asset.updateNFT(mint_address: mintAddress, url: url, seller_fee_basis_points: seller_fee_basis_points, name: name, symbol: symbol, updateAuthority: update_authority, confirmation: confirmation, skip_preflight: skip_preflight)
{ isSucc,data in
    print("result:\(isSucc),data is:\(data)")
}
```

- queryNFT
Fetch the details of a NFT.

```Swift
MWSDK.Solana.Asset.queryNFT(mint_Address: mint_address) { data in
    print(data)
} onFailed: { code, message in
    print("failed:\(code),\(message ?? "")")
}
```

- searchNFTs
Get a collection of NFT by mint addresses.

```Swift
MWSDK.Solana.Asset.searchNFTs(mint_addresses: mint_address_arr) { data in
    print(data)
} onFailed: { code, message in
    print("failed:\(code),\(message ?? "")")
}
```

- searchNFTsByOwner
Get a collection of NFT by creator addresses

```Swift
MWSDK.Solana.Asset.searchNFTsByOwner(owners: ownersArr, limit: limit , offset: offset ) { data in
    print(data)
} onFailed: { code, message in
    print("failed:\(code),\(message ?? "")")
}
```

## Metadata APIs
*This kind of API belongs to 'Metadata' module, you can just use 'MWSDK.ChainName.Metadata.functionName' to call them.*

- getCollectionsInfo
Get collections info by collection addresses.

```Swift
MWSDK.Solana.Metadata.getCollectionsInfo(collections: [collection_mint]) {data in
    print(data)
} onFailed: {code, message in
    print("failed  code:\(code),message: \(message ?? "")")
}
```

- getCollectionFilterInfo
Get collection filters info.
```Swift
 MWSDK.Solana.Metadata.getCollectionFilterInfo(collection: collection) {data in
    self.Log(data)
} onFailed: {code, message in
    self.Log("failed:\(code),\(message ?? "")")
}
```

- getCollectionsSummary
Get collections summary info.
```Swift
MWSDK.Solana.Metadata.getCollectionsSummary(collections: [collection]) {data in
    print(data)
} onFailed: {code, message in
    print("failed:\(code),\(message ?? "")")
}
```

- getNFTInfo
Get NFT info. You need to parse the rawJsonString by yourself, cause SDK don't know what format your NFT is like.

```Swift
MWSDK.Solana.Metadata.getNFTInfo(mint_address: mint_address) {data in
    print(data)
} onFailed: {code, message in
    print("failed  code:\(code),message: \(message ?? "")")
}
```

- getNFTs
Get NFTs by unabridged rules.
```Swift
MWSDK.Solana.Metadata.getNFTs(collection: collection_mint, sale: sale, page: page, page_size: page_size, order: ["order_by":"price","desc":true], auction_house: auction_house, filter: [["filter_name" : "Rarity","filter_type":"enum","filter_value":["Common"]]]){ data in
    print(data)
} onFailed: { code, message in
    print("\(item):failed  code:\(code),message: \(message ?? "")")
}
```

- getNFTEvents
Get NFT's events.
```Swift
MWSDK.Solana.Metadata.getNFTEvents(mint_address: mint_address, page: page, page_size: page_size) { data in
    print(data)
} onFailed: { code, message in
    print("failed  code:\(code),message: \(message ?? "")")
}
```

- searchNFTs
Search NFTs by given search string.
```Swift
MWSDK.Solana.Metadata.searchNFTs(collections: [collection_mint], search: search) { data in
    print(data)
} onFailed: { code, message in
    print("failed  code:\(code),message: \(message ?? "")")
}
```

- recommentSearchNFT
Search NFTs by recommend, server will give 10 NFT as recommend NFT at most.
Developer may use them to fill some blank of searching UI.

```Swift
MWSDK.Solana.Metadata.recommentSearchNFT(collections: [collection_mint]) { data in
    print(data)
} onFailed: { code, message in
    print("failed  code:\(code),message: \(message ?? "")")
}
```

## Using iOS-SDK for Unity

in Unity:

```Unity

using System.Runtime.InteropServices;
public class MirrorSDK : MonoBehaviour
{
    [DllImport("__Internal")]
    private static extern void initSDK(string apikey);
    
    private void Awake()
    {
    #elif (UNITY_IOS && !(UNITY_EDITOR))
        initSDK(apiKey);
    #endif
    }
}

```

## License

MirrorWorldSDK is available under the MIT license. See the LICENSE file for more info.

[`markdownlint/Ruby`](https://github.com/markdownlint/markdownlint) for the inspiration and [`markdown-it`](https://github.com/markdown-it/markdown-it) for the parser and interactive demo idea!
