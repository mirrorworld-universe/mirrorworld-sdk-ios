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
    extern void initSDK(char *apikey){
        NSString *key = [NSString stringWithFormat:@"%s",apikey];
        [[MirrorWorldSDK share] initSDKWithEnv:MWEnvironmentStagingDevNet apiKey:key];
    }
}

extern "C"
{
    typedef void (*LoginCallback) (const char *object);
    extern void StartLogin(LoginCallback callback){
        [[MirrorWorldSDK share] StartLoginOnSuccess:^(NSDictionary<NSString *,id> * userinfo) {
            // to string
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
    extern void OpenWallet(){
        [[MirrorWorldSDK share] OpenWallet];

    }
}


@end
