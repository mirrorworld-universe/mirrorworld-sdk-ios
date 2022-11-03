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

### Authentication Methods

`public let MWSDK = MirrorWorldSDK.share`

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
- CheckAuthenticated

    Checks whether the current user is logged in. You can use this function to judge  whether a user needs to start login flow.

```
MWSDK.CheckAuthenticated { onBool in
    self.Log("This device's login state is:\(onBool)")
}

### Wallet Methods

```

- OpenWallet
  Open a webview which would show the wallet page.
  ```
  MWSDK.OpenWallet()
  ```
- GetAccessToken

Get access token so that users can visit APIs.

```
            MWSDK.GetAccessToken(callBack: { token in
                self.Log("Access Token is : \(token)")
            })
```

<br/>

- QueryUser
  
  Check user's info, then we can get user's base information such as wallet address and so on.
  ```
   MWSDK.QueryUser(email: "zg72296@gmail.com") { user in
                  self.Log(user ?? "null")
              } onFetchFailed: { code, error in
                  self.Log("\(code):\(error)")
              }
  ```

<br/>

## License

MirrorWorldSDK is available under the MIT license. See the LICENSE file for more info.
