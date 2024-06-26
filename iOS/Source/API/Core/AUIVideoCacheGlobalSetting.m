//
//  AUIVideoCacheGlobalSetting.m
//  AUIShortEpisode
//
//

#import "AUIVideoCacheGlobalSetting.h"

#if __has_include(<AliVCSDK_Standard/AliVCSDK_Standard.h>)
#import <AliVCSDK_Standard/AliVCSDK_Standard.h>
#elif __has_include(<AliVCSDK_Premium/AliVCSDK_Premium.h>)
#import <AliVCSDK_Premium/AliVCSDK_Premium.h>
#elif __has_include(<AliVCSDK_InteractiveLive/AliVCSDK_InteractiveLive.h>)
#import <AliVCSDK_InteractiveLive/AliVCSDK_InteractiveLive.h>
#elif __has_include(<AliVCSDK_BasicLive/AliVCSDK_BasicLive.h>)
#import <AliVCSDK_BasicLive/AliVCSDK_BasicLive.h>
#elif __has_include(<AliVCSDK_StandardLive/AliVCSDK_StandardLive.h>)
#import <AliVCSDK_StandardLive/AliVCSDK_StandardLive.h>
#elif __has_include(<AliVCSDK_PremiumLive/AliVCSDK_PremiumLive.h>)
#import <AliVCSDK_PremiumLive/AliVCSDK_PremiumLive.h>
#elif __has_include(<AliVCSDK_UGC/AliVCSDK_UGC.h>)
#import <AliVCSDK_UGC/AliVCSDK_UGC.h>
#elif __has_include(<AliVCSDK_UGCPro/AliVCSDK_UGCPro.h>)
#import <AliVCSDK_UGCPro/AliVCSDK_UGCPro.h>
#endif

#if __has_include(<AliyunPlayer/AliyunPlayer.h>)
#import <AliyunPlayer/AliyunPlayer.h>
#endif

@implementation AUIVideoCacheGlobalSetting

+ (void)setupCacheConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        [AliPlayerGlobalSettings enableLocalCache:YES maxBufferMemoryKB:10*1024 localCacheDir:[docDir stringByAppendingPathComponent:@"alicache"]];
        [AliPlayerGlobalSettings setCacheFileClearConfig:30*60*24 maxCapacityMB:20480 freeStorageMB:0];
    });
}

+ (void)clearCaches {
    [AliPlayerGlobalSettings clearCaches];
}

@end
