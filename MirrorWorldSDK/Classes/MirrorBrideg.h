//
//  MirrorBrideg.h
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/3.
//

#import <Foundation/Foundation.h>

@interface MirrorBrideg : NSObject


typedef void (* eckShowPlayerHandler)(const char * userinfo);

extern "C"
{
    extern void initSDK(char *apikey);
}

extern "C"
{
    typedef void (*LoginCallback) (const char *object);
    extern void StartLogin(LoginCallback callback);
}

extern "C"
{

    ///
//    extern void OpenWallet();
    /// wallet log out callback
    typedef void (*iOSWalletLogOutCallback)(const char *object);
    extern void OpenWallet(iOSWalletLogOutCallback callback);
}




@end


