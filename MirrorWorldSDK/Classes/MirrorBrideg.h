//
//  MirrorBrideg.h
//  MirrorWorldSDK
//
//  Created by ZMG on 2022/11/3.
//

#import <Foundation/Foundation.h>

@interface MirrorBrideg : NSObject

extern "C"
{
    extern void initSDK(char *apikey);
}

extern "C"
{
    extern void StartLogin();
}

extern "C"
{
    extern void OpenWallet();
}




@end


