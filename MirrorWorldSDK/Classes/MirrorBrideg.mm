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
    extern void StartLogin(){
        [[MirrorWorldSDK share] StartLoginOnSuccess:^(NSDictionary<NSString *,id> * _Nullable) { } onFail:^{ }];
    }
}
extern "C"
{
    extern void OpenWallet(){}
}
@end
