# MirrorWorldSDK

[![CI Status](https://img.shields.io/travis/791738673@qq.com/MirrorWorldSDK.svg?style=flat)](https://travis-ci.org/791738673@qq.com/MirrorWorldSDK)
[![Version](https://img.shields.io/cocoapods/v/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)
[![License](https://img.shields.io/cocoapods/l/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)
[![Platform](https://img.shields.io/cocoapods/p/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)

## Introduction to Mirror World

- The Mirror World Smart SDK is a cross-platform interface that provides simple, declarative API interfaces for building Mobile and Web Applications into Web 3 Architecture.

## Supported iOS & SDK Versions

- iOS 10.0+
- Swift
- Objective-C/C++/C

## Installation

MirrorWorldSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
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

### Authentication Methods

`public let MWSDK = MirrorWorldSDK.share`

- StartLogin

Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.

```Swift
MirrorWorldSDK.share.StartLogin { userInfo in
    print("login success :\(userInfo?.toString() ?? "")")
} onFail: {
    print("login failed !")
}
```

- GuestLogin

Use this API to make a user logged in as a guest who has a new account and a new wallet.
```Swift
MWSDK.GuestLogin {
    print("guest login success")
} onFail: {
    print("guest login failed")
}
```

- CheckAuthenticated

Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.

```Swift
MWSDK.CheckAuthenticated { onBool in
    print("This device's login state is:\(onBool)")
}
```

- Logs out a user

```Swift
MWSDK.loginOut {
    print("Logs out a user : success")
} onFail: {
    print("Logs out a user : failed !")
}
```

### Wallet Methods

- OpenWallet

Open a webview which would show the wallet page.

```Swift
MWSDK.OpenWallet()
```

- GetAccessToken

Get access token so that users can visit APIs.

```Swift

MWSDK.GetAccessToken(callBack: { token in
    self.Log("Access Token is : \(token)")
})

```

- QueryUser

Check user's info, then we can get user's base information such as wallet address and so on.

```Swift

MWSDK.QueryUser(email: "user Email") { user in
  self.Log(user ?? "null")
} onFetchFailed: { code, error in
 self.Log("\(code):\(error)")
}

```

## MarketPlace Method

- FetchSingleNFT
Fetch the details of a NFT.

```Swift

MirrorWorldSDK.share.FetchSingleNFT(mint_Address: "mint address") { data in
    self.Log(data)
} onFailed: { code, message in
    self.Log("\(item):failed:\(code),\(message ?? "")")
}

```

- MintNewNFTOnCollection
Mint a new NFT.

```Swift
MWSDK.MintNewNFT(collection_mint: "collection_mint", name: "test", symbol: "NA", url: "", seller_fee_basis_points: 100, confirmation: "finalized") { data in
        print(data)
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    }

```

- CheckStatusOfMinting

Get status of a minting operation. Because minting may has some delay before success.
```Swift
MWSDK.CheckStatusOfMinting(mintAddress: ["NFTMintAddress"]) { isSucc, data in
    print("Check status of Minting result is:\(isSucc). data is:\(data)")
}
```

- CheckStatusOfTransactions

Get status of transactions by their signatures.
```Swift
MWSDK.CheckStatusOfTransactions(signatures: ["signature"]) { data in
    print(data)
} onFailed: { code, message in
    print("CheckStatusOfTransactions failed,code is:\(code);message:\(message)")
}
```

- UpdateNFTProperties

Update properties of a NFT.
```Swift
let mintAddress = "NFT mint address"
let name = "Awsom NFT"
let symbol = "My symbol"
let updateAuthority = "Update authority"
let url = "Your NFT json url"
let points = 100
let confirmation = "confirmed"

MWSDK.UpdateNFTProperties(mintAddresses: mintAddress,name:name,symbol:symbol,updateAuthority:update_authority,NFTJsonUrl: url,seller_fee_basis_points:points,confirmation:confirmation) { data in
    print(data)
} _: { message in
    print(message)
}
```

- CreateVerifiedCollection
Mint a parent NFT collection.

```Swift
MWSDK.MintNewCollection(name: "testNewCollection", symbol: "NA", url: "https://market-assets.mirrorworld.fun/gen1/1.json", confirmation: "finalized", seller_fee_basis_points: 200, onSuccess: { data in
        self.Log(data)
    }, onFailed: { code,message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    })
```

- CreateVerifiedSubCollection
Mint a child NFT collection.

```Swift
MWSDK.CreateVerifiedSubCollection(name: "test", collection_mint: "xxxxxxxx", symbol: "test", url: "https://market-assets.mirrorworld.fun/gen1/1.json") { data in
        self.Log(data)
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    }
```

- TransferNFTToAnotherSolanaWallet
Transfer NFT to another Sol wallet.

```Swift
MWSDK.TransferNFTToAnotherSolanaWallet(mint_address: "", to_wallet_address: "", confirmation: "") { data in
    self.Log(data)
} onFailed: { code, message in
    self.Log("\(item):failed:\(code),\(message ?? "")")
}
```

- CancelNFTListing

Cancel listing of NFT.

```Swift
MWSDK.CancelNFTListing(mint_address: "test", price: 1.1) { data in
    self.Log(data)

} onFailed: { code, message in
    self.Log("\(item):failed:\(code),\(message ?? "")")
}
```

- BuyNFT

Buy a NFT on market place.
```Swift
    MWSDK.BuyNFT(mint_address: "test", price: 1.1) { data in
        self.Log(data)
        self.loadingActive.stopAnimating()
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
        self.loadingActive.stopAnimating()
    }

```

- UpdateNFTListing
Update the list of NFTs.

```Swift
MWSDK.UpdateNFTListing(mint_address: "mint address", price: 1) { data in
        self.Log(data)
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    }
```

- ListNFT
Get list of NFT on market place.

```Swift
MirrorWorldSDK.share.ListNFT(mint_address: "test", price: 1.1, confirmation: "finalized") { data in
        self.Log(data)
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    }
```

- CancelNFTListing
Cancel listing of NFT.

```Swift
MWSDK.CancelNFTListing(mint_address: "test", price: 1.1) { data in
        self.Log(data)
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    }
```

- FetchNFTsByUpdateAuthorities
Get a collection of NFT by authority addresses.

```Swift
MWSDK.FetchNFTsByUpdateAuthorities(update_authorities: ["test"], limit: 10, offset: 0.1) { data in
            self.Log(data)
        } onFailed: { code, message in
            self.Log("\(item):failed:\(code),\(message ?? "")")
        }
```

- FetchNFTsByCreatorAddresses
Get a collection of NFT by creator addresses

```Swift
MWSDK.FetchNFTsByCreatorAddresses(creators: ["test"], limit: 10, offset: 0.1) { data in
        self.Log(data)
        self.loadingActive.stopAnimating()
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
        self.loadingActive.stopAnimating()
    }
```

- FetchNFTsByOwnerAddresses
Get a collection of NFT by mint addresses.

```Swift
MWSDK.FetchNFTsByOwnerAddress(owners: ["test"], limit: 1, offset: 0.1) { data in
        self.Log(data)
    } onFailed: { code, message in
        self.Log("\(item):failed:\(code),\(message ?? "")")
    }
```

## Storefront Methods
- OpenMarketPlacePage
Open the market place page which publish before.
You can refer to [How to publish self Storefront](https://docs.mirrorworld.fun/overview/storefront).
```Swift
let marketUrl = "Your market place url"
MWSDK.OpenMarketPlacePage(url: url)
```

- GetCollectionFilterInfo
Get collection filters info.
```Swift
MWSDK.GetCollectionFilterInfo(collection: "Your collection address") { data in
    print("<iOS_MWSDK_LOG>: GetCollectionFilterInfo result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
}
```

- GetNFTInfo
Get NFT info. You need to parse the rawJsonString by yourself, cause SDK don't know what format your NFT is like.

```Swift
MWSDK.GetNFTInfo(mint_address: "your address") { data in
    print("<iOS_MWSDK_LOG>: GetNFTInfo result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: GetNFTInfo faild, code is \(code) message is \(message)")
}
```

- GetCollectionInfo
Get collections info by collection addresses.

```Swift
MWSDK.GetCollectionInfo(collections: ["Your collection address 1"]) { data in
    print("<iOS_MWSDK_LOG>: GetCollectionFilterInfo result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
}
```

- GetNFTEvents
Get NFT's events.
```Swift
MWSDK.GetNFTEvents(mint_address: "NFT address", page: 1, page_size: 10) { data in
    print("<iOS_MWSDK_LOG>: GetNFTEvents result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
}
```

- SearchNFTs
Search NFTs by given search string.
```Swift
MWSDK.SearchNFTs(collections: ["collection address 1"], search: "price") { data in
    print("<iOS_MWSDK_LOG>: SearchNFTs result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
}
```

- RecommendSearchNFT
Search NFTs by recommend, server will give 10 NFT as recommend NFT at most.
Developer may use them to fill some blank of searching UI.

```Swift
MWSDK.RecommentSearchNFT(collections: ["collection address 1"]) { data in
    print("<iOS_MWSDK_LOG>: RecommentSearchNFT result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
}
```

- GetNFTsByUnabridgedParams
Get NFTs by unabridged rules.
```Swift
MWSDK.GetNFTsByUnabridgedParams(collection: "collection address", page: 1, page_size: 10, order: ["price"], sale: 1, filter: ["price"]) { data in
    print("<iOS_MWSDK_LOG>: GetNFTsByUnabridgedParams result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
}
```

- GetNFTRealPrice
Get real price of a NFT.
The param 'fee' is deduct rate of server. So if you input '4250', server will deduct 4.25%.

```Swift
MWSDK.GetNFTRealPrice(price: "1.2", fee: 1250) { data in
    print("<iOS_MWSDK_LOG>: GetNFTRealPrice result:\(data)")
} onFailed: { code, message in
    print("<iOS_MWSDK_LOG>: Visit faild, code is \(code) message is \(message)")
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
