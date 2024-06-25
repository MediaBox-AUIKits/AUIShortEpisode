# AUIShortEpisode
阿里云 · AUIKits微短剧场景集成工具

## 介绍
基于阿里云在微短剧场景的实践经验，AUI Kits针对微短剧场景进行业务封装，沉淀了音视频终端SDK的本地缓存、智能预加载等最佳实践，提供低代码集成套件，帮助集成方快速搭建微短剧App并获得更好的视听体验。

## 源码说明

### 源码下载
下载地址[请参见](https://github.com/MediaBox-AUIKits/AUIShortEpisode/tree/main/iOS)


### 代码结构
```
├── AUIShortEpisode   // iOS平台根目录
│   ├── AUIShortEpisode.podspec           // pod描述文件
│   ├── Source                            // AUI源代码文件
│       ├── API                           // 不含UI的源码文件
│   ├── Resources                         // 资源文件
│   ├── Example                           // Demo代码
│   ├── README.md                         // Readme   
│   ├── AUIBaseKits                       // 基础UI组件   
```

### 环境要求

- Xcode 14.0 及以上版本，推荐使用最新正式版本
- CocoaPods 1.9.3 及以上版本
- iOS版本10.0或以上版本的真机

### 前提条件

您已获取MediaBox音视频SDK的播放器的License授权和License Key。获取方法，请参见获取[License](https://help.aliyun.com/document_detail/2391512.html)。

## 跑通demo

- 源码下载后，进入Example目录
- 修改Podfile中依赖的播放器SDK为最新版本，版本号参考[iOS播放器SDK](https://help.aliyun.com/zh/vod/developer-reference/release-notes-for-apsaravideo-player-sdk-for-ios)
- 在Example目录里执行命令“pod install  --repo-update”，自动安装依赖SDK
- 打开工程文件“AUIShortEpisodeExample.xcworkspace”，修改包Id
- 在控制台上申请试用License，开通播放器能力，获取License文件和LicenseKey，如果已开通License直接进入下一步
- 把License文件放到Example/目录下，并修改文件名为“license.crt”
- 打开“Example/Info.plist”，把“LicenseKey”（如果没有，请在控制台拷贝），填写到字段“AlivcLicenseKey”的值中
- 编译运行

## 快速开发自己的短剧功能
可通过以下几个步骤快速集成AUIShortEpisode到你的APP中，让你的APP具备语短剧功能

### 集成源码
- 导入AUIShortEpisode：仓库代码下载后，拷贝iOS文件夹到你的APP代码目录下，与你的Podfile文件在同一层级，改名为AUIShortEpisode，可以删除Example目录
- 修改你的Podfile，引入：
  - AliPlayerSDK_iOS：阿里视频云播放器SDK，最近使用最新版本，版本号参考[iOS播放器SDK](https://help.aliyun.com/zh/vod/developer-reference/release-notes-for-apsaravideo-player-sdk-for-ios)。如果已经同时使用了阿里视频云的其他SDK（例如短视频SDK、直播推流SDK），那么可以替换为音视频终端SDK：AliVCSDK_UGC（播放器+短视频）、AliVCSDK_InteractiveLive（播放器+直播）、AliVCSDK_Standard（全量包），参考[快速集成](https://help.aliyun.com/document_detail/2412571.htm)
  - AUIFoundation：基础UI组件
  - AUIShortEpisode：短剧场景UI组件源码
```ruby

#需要iOS10.0及以上才能支持
platform :ios, '10.0'

target '你的App target' do
    # 根据自己的业务场景，集成合适SDK，支持：AliPlayerSDK_iOS、AliVCSDK_UGC、AliVCSDK_InteractiveLive、AliVCSDK_Standard等，请使用最新的版本，可以从官网进行查询
    pod 'AliPlayerSDK_iOS', '~> x.x.x'
  
    # 基础UI组件
    pod 'AUIFoundation', :path => "./AUIShortEpisode/AUIBaseKits/AUIFoundation/"
  
    # 短剧UI组件源码
    pod 'AUIShortEpisode/AUI', :path => "./AUIShortEpisode/"
    # 短剧依赖的SDK，需要与集成的SDK对应，支持：AliPlayerSDK_iOS、AliVCSDK_UGC、AliVCSDK_InteractiveLive、AliVCSDK_Standard等
    pod 'AUIShortEpisode/AliPlayerSDK_iOS', :path => "./AUIShortEpisode/"
end
```
- 执行“pod install --repo-update”
- 源码集成完成

## 功能开发
1. 编写功能入口代码
   
在当前页面中打开短剧主界面AUIShortEpisodeViewController
```ObjC
#import "AUIShortEpisodeViewController.h"

AUIShortEpisodeViewController *vc = [[AUIShortEpisodeViewController alloc] init];
[self.navigationController pushViewController:vc animated:YES];
```

2. 加载数据集

本组件默认使用了内置的剧集数据进行演示，在你集成组件后需要修改这块的逻辑，需要对接到你的服务端，通过服务端提供的接口来获取剧集数据

- 在源码中找到AUIShortEpisodeDataManager类，进入fetchData:completed:方法，修改为通过服务端接口获取剧集数据
```ObjC
//  AUIShortEpisodeData.m

@implementation AUIShortEpisodeDataManager

+ (void)fetchData:(NSString *)eid completed:(void (^)(AUIShortEpisodeData *, NSError *))completed {
    // TODO: 请求服务端返回短剧数据，需要你的服务端提供接口，并在这里请求接口
    // TODO：接口成功返回的数据还需转换为AUIShortEpisodeData，最终通过completed参数回调给业务
    
}

```

- 剧集模型字段说明

从服务端获取到的数据，需要根据数据协议转换为剧集模型

a. 剧集：AUIShortEpisodeData
  
| 字段 |  含义   |
|-----|--------|
| id |	剧集唯一ID |
| title |	剧集名称 |
| list |	剧集视频列表 |

b. 单集视频：AUIVideoInfo
  
| 字段 |  含义   |
|-----|--------|
| videoId |	视频唯一标识 |
| url |	播放源url |
| duration |	时长 |
| coverUrl |	封面 |
| author |	作者 |
| title |	标题 |
| videoPlayCount |	播放次数 |
| isLiked |	是否被点赞 |
| likeCount |	点赞数 |
| commentCount |	评论数 |
| shareCount |	分享数 |


3. 视频互动功能开发

点赞、评论、分享仅在视频上透出入口，点击后具体的操作需要自己来实现，可以到AUIShortEpisodeViewController类中对接实现
```ObjC
//  AUIShortEpisodeViewController.m

    cell.onLikeBtnClickBlock = ^(AUIShortEpisodePlayCell * _Nonnull cell, AVBaseButton *likeBtn) {
        likeBtn.selected = !likeBtn.selected;
        cell.videoInfo.isLiked = likeBtn.selected;
        cell.videoInfo.likeCount = likeBtn.selected ? (cell.videoInfo.likeCount + 1) : (cell.videoInfo.likeCount - 1);
        [cell refreshUI];
        // TODO: 发送点赞请求给服务端，需要自己实现
    };
    cell.onCommentBtnClickBlock = ^(AUIShortEpisodePlayCell * _Nonnull cell, AVBaseButton *commentBtn) {
        // TODO: 打开评论页面，需要自己实现
    };
    cell.onShareBtnClickBlock = ^(AUIShortEpisodePlayCell * _Nonnull cell, AVBaseButton *shareBtn) {
        // TODO: 打开分享页面，需要自己实现
    };

```

## 核心能力介绍

本组件功能通过阿里云播放器SDK的AliListPlayer进行实现，使用了本地缓存、智能预加载、智能预渲染、HTTPDNS、加密播放等核心能力，在播放延迟、播放稳定性及安全性方面大幅度提升观看体验。
具体介绍参考[进阶功能](https://help.aliyun.com/zh/vod/developer-reference/advanced-features-1)
