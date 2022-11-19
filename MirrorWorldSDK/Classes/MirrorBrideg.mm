//
//  MirrorBrideg.m
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/3.
//

#import "MirrorBrideg.h"
#import "MirrorWorldSDK/MirrorWorldSDK-Swift.h"




@implementation MirrorBrideg


extern "C"
{
    extern void IOSInitSDK(int environment,char *apikey){
        
        NSLog(@"IOS-SDK1:environment:%d,apikey:%s",environment,apikey);
        
        MWEnvironment env = MWEnvironmentMainNet;
        if (environment == 3){ env = MWEnvironmentDevNet; }
        if (environment == 0){env = MWEnvironmentStagingDevNet; }
        if (environment == 1){env = MWEnvironmentStagingMainNet; }
        
        NSLog(@"IOS-SDK2:environment:%ld",(long)env);

        NSString *key = [NSString stringWithFormat:@"%s",apikey];
        [[MirrorWorldSDK share] initSDKWithEnv:env apiKey:key];
    }
}

extern "C"
{
    typedef void (*IOSLoginCallback) (const char *object);
    extern void IOSStartLogin(IOSLoginCallback callback){
        [[MirrorWorldSDK share] StartLoginOnSuccess:^(NSDictionary<NSString *,id> * userinfo) {
            
            
            NSMutableDictionary *unityDic = [[NSMutableDictionary alloc] initWithDictionary:userinfo];

            //            [MirrorWorldSDKAuthData sha]
//            [unityDic setValue:<#(nullable id)#> forKey:"access_token"];
//            [unityDic setValue:<#(nullable id)#> forKey:"refresh_token"];
            
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userinfo options:NSJSONWritingPrettyPrinted error:nil];
            NSString *user = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            const char *cString = [user UTF8String];
            callback(cString);
        } onFail:^{
            
        }];
    }
}


extern "C"
{
    typedef void (*iOSWalletLogOutCallback)(const char *object);
    extern void IOSOpenWallet(iOSWalletLogOutCallback callback){
        [[MirrorWorldSDK share] OpenWalletOnLogout:^{
            callback("wallet is logout.");
        }];
    }

}



@end
