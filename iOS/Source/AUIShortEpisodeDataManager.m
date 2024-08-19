//
//  AUIShortEpisodeDataManager.m
//  AUIShortEpisode
//
//  Created by Bingo on 2023/9/17.
//

#import "AUIShortEpisodeDataManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AUIFoundation.h"

NSString * const AUI_EPISODE_TEST = @"https://alivc-demo-cms.alicdn.com/versionProduct/resources/player/aui_episode.json";
NSString * const AUI_EPISODE_TEST_ENCRYPT = @"https://alivc-demo-cms.alicdn.com/versionProduct/resources/player/aui_episode_encrypt.json";


@implementation AUIShortEpisodeDataManager

+ (void)fetchData:(NSString *)eid completed:(void (^)(AUIShortEpisodeData *, NSError *))completed {
    // TODO: 请求服务端返回短剧数据，此次是仅模拟，有需要请自身实现
    NSString *url = AUI_EPISODE_TEST;
    
    if (AVLocalization.isInternational) {
        url = [url stringByReplacingOccurrencesOfString:@".json" withString:@"_en.json"];
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to request data: %@", error);
            if (completed) {
                completed(nil, error);
            }
        }
        else {
            NSDictionary *jsonDictionary = responseObject;
            if ([jsonDictionary isKindOfClass:NSDictionary.class]) {
                NSLog(@"Request data success: %@", jsonDictionary);
                AUIShortEpisodeData *episode = [[AUIShortEpisodeData alloc] initWithDict:jsonDictionary];
                if (completed) {
                    completed(episode, nil);
                }
            }
            else {
                NSError *jsonError = [NSError errorWithDomain:@"error" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"response data error"}];
                NSLog(@"Failed to request data: %@", jsonError);
                if (completed) {
                    completed(nil, jsonError);
                }
            }
        }
    }];
    [dataTask resume];
}

@end
