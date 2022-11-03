# MirrorWorldSDK

[![CI Status](https://img.shields.io/travis/791738673@qq.com/MirrorWorldSDK.svg?style=flat)](https://travis-ci.org/791738673@qq.com/MirrorWorldSDK)
[![Version](https://img.shields.io/cocoapods/v/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)
[![License](https://img.shields.io/cocoapods/l/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)
[![Platform](https://img.shields.io/cocoapods/p/MirrorWorldSDK.svg?style=flat)](https://cocoapods.org/pods/MirrorWorldSDK)

## Introduction to Mirror World

- The Mirror World Smart SDK is a cross-platform interface that provides simple, declarative API interfaces for building Mobile and Web Applications into Web 3 Architecture.

## Author

MirrorWorld

## Supported iOS & SDK Versions
- iOS 10.0+
- Swift 5

## Our Mission
- Mirror World's contribution to this vision is to create top-class composable and easy-to-use APIs and SDKs for building applications and games on a decentralized web without limits. Our core SDK primarily provides features around Authentication, NFT APIs, Marketplaces and Storefronts, Tokenization and On-ramp strategies.
- The vision of the Mirror World Smart SDK is to create easy-to-integrate tools to help creators step out of the walled-garden solutions to building digital economies on decentralized applications and games.

## Our open-source initiative

- We also want to foster an open-source friendly community where builders can contribute to the tools we create and be rewarded for their significant contributions to the Mirror World development ecosystem.

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

```bash
$ pod install
```


## Getting started
Create a developer account on the Developer dashboard https://app.mirrorworld.fun/ . Create project and create an API Key.

## Usage
```
Set UrlScheme in the info.plist file of your project ： `mwsdk`

```
Than

```
import MirrorWorldSDK

```
init SDK in the AppDelegate.
```
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


Authentication Methods

- StartLogin

Calling this api would popup a dialog, user can finish login flow on it. In which dialog, user can login with third method like google, twitter. Or he can login with his email which registered on our website.
```
    MirrorWorldSDK.share.StartLogin(baseController: self) { userInfo in
        print("login success :\(userInfo?.toString() ?? "")")
    } onFail: {
        print("login failed !")
    }
```
- CheckAuthenticated

Checks whether the current user is logged in. You can use this function to judge whether a user needs to start login flow.
```
    MWSDK.CheckAuthenticated { onBool in
        print("This device's login state is:\(onBool)")
    }
```
- Logs out a user
```
    MWSDK.loginOut {
        print("Logs out a user : success")
    } onFail: {
        print("Logs out a user : failed !")
    }
```



## License

MirrorWorldSDK is available under the MIT license. See the LICENSE file for more info.
