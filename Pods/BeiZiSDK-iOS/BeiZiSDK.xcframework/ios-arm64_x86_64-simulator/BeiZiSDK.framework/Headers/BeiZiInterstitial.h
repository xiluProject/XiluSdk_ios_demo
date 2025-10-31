//
//  BeiZiInterstitial.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BeiZiSDK/BeiZiBiddingProtocol.h>
#import <BeiZiSDK/BeiZiCustomEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BeiZiInterstitialDelegate;
@class BeiZiRequestError;

@interface BeiZiInterstitial : NSObject <BeiZiBiddingProtocol, BeiZiCustomEventProtocol>

@property (nonatomic, strong) NSDictionary *extInfo;
@property (nonatomic, strong) NSDictionary *materialInfo;
@property (nonatomic, copy, readonly) NSString *spaceID;
@property (nonatomic, copy, readonly) NSString *spaceParam;
@property (nonatomic, copy, readonly) NSDictionary *customParam;

/**
 单位：人民币（分）
 */
@property (nonatomic, assign) NSInteger eCPM;

/**
 用来接收 Interstitial 广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic, weak) id<BeiZiInterstitialDelegate> delegate;

/**
 渠道广告版本，1 or 2
 在 BeiZi_loadInterstitialAd 前设置版本，默认1
*/
@property (nonatomic, assign) NSInteger adVersion;

/**
 初始化方法
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @param lifeTime 超时时长，单位毫秒
 @return Interstitial 广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam
                       lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;

/**
 Interstitial 加载
 */
- (void)BeiZi_loadInterstitialAd;

/**
 S2S请求
 */
- (void)BeiZi_loadInterstitialAdWithToken:(NSString *)respToken;

/**
 Interstitial展示，确保广告加载成功后调用
 rootViewController 展示view的控制器或者弹出落地页的需要的控制器，此参数不能为空
 */
- (void)BeiZi_showInterstitialAdFromRootViewController:(UIViewController *)rootViewController;

@end

/**
 代理方法
 */
@protocol BeiZiInterstitialDelegate <NSObject>

@optional

/**
 插屏加载成功
 */
- (void)BeiZi_interstitialDidReceiveAd:(BeiZiInterstitial *)beiziInterstitial;

/**
 插屏展现
 */
- (void)BeiZi_interstitialDidPresentScreen:(BeiZiInterstitial *)beiziInterstitial;

/**
 插屏点击
 */
- (void)BeiZi_interstitialDidClick:(BeiZiInterstitial *)beiziInterstitial;

/**
 插屏消失&&关闭
 */
- (void)BeiZi_interstitialDidDismissScreen:(BeiZiInterstitial *)beiziInterstitial;

/**
 插屏请求失败
 */
- (void)BeiZi_interstitial:(BeiZiInterstitial *)beiziInterstitial didFailToLoadAdWithError:(BeiZiRequestError *)error;

@end

NS_ASSUME_NONNULL_END
