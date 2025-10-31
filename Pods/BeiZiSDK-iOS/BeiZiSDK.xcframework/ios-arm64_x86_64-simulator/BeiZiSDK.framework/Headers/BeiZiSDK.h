//
//  BeiZiSDK.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#ifndef BeiZiSDK_h
#define BeiZiSDK_h


#import <UIKit/UIKit.h>

//! Project version number for BeiZiSDK.
FOUNDATION_EXPORT double BeiZiSDKVersionNumber;

//! Project version string for BeiZiSDK.
FOUNDATION_EXPORT const unsigned char BeiZiSDKVersionString[];

// 初始化SDK
#import <BeiZiSDK/BeiZiSDKManager.h>

// 竞价协议
#import <BeiZiSDK/BeiZiBiddingProtocol.h>

//自定义信息
#import <BeiZiSDK/BeiZiCustomEventProtocol.h>

// 开屏广告
#import <BeiZiSDK/BeiZiSplash.h>

//原生广告
#import <BeiZiSDK/BeiZiNativeExpress.h>

//激励视频广告
#import <BeiZiSDK/BeiZiRewardedVideo.h>

//横幅广告
#import <BeiZiSDK/BeiZiBannerView.h>

//全屏视频广告
#import <BeiZiSDK/BeiZiFullscreenVideo.h>

//Draw流广告
#import <BeiZiSDK/BeiZiDrawFlow.h>

//插屏广告
#import <BeiZiSDK/BeiZiInterstitial.h>

// 错误信息
#import <BeiZiSDK/BeiZiRequestError.h>

#import <BeiZiSDK/BeiZiUnifiedCustom.h>

#import <BeiZiSDK/BeiZiUnifiedNative.h>

#import <BeiZiSDK/BeiZiSDKDefines.h>

#import <BeiZiSDK/BeiZiNativeDataObject.h>

#endif /* BeiZiSDK_h */
