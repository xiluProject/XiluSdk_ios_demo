//
//  BeiZiBannerView.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <UIKit/UIKit.h>
#import <BeiZiSDK/BeiZiSDKDefines.h>
#import <BeiZiSDK/BeiZiBiddingProtocol.h>
#import <BeiZiSDK/BeiZiCustomEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BeiZiBannerViewDelegate;
@class BeiZiRequestError;

@interface BeiZiBannerView : UIView <BeiZiBiddingProtocol, BeiZiCustomEventProtocol>

@property (nonatomic, strong) NSDictionary *extInfo;
@property (nonatomic, strong) NSDictionary *materialInfo;
@property (nonatomic, copy, readonly) NSString *spaceID;
@property (nonatomic, copy, readonly) NSString *spaceParam;

/**
 单位：人民币（分）
 */
@property (nonatomic, assign) NSInteger eCPM;

/**
 用来接收 Banner 广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic, weak) id<BeiZiBannerViewDelegate> delegate;

/**
 beiziBannerViewController 展示view的控制器或者弹出落地页的需要的控制器，此参数不能为空
 */
@property (nonatomic, weak) UIViewController *beiziBannerViewController;

/**
 初始化方法
 @param frame 广告展示的位置和大小，banner默认比例6.4:1；只需要设置宽度，高度自适应，默认宽度屏幕宽度
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return Banner 广告对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      spaceID:(NSString *)spaceID
                   spaceParam:(NSString *)spaceParam
                     lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;

/**
 Banner 加载
 */
- (void)BeiZi_loadBannerAd;

/**
 Banner 广告移除 开发者自行调用
 */
- (void)BeiZi_bannerCloseAd;


@end

/**
 代理方法
 */
@protocol BeiZiBannerViewDelegate <NSObject>

@optional

/**
 Banner加载成功
 */
- (void)BeiZi_bannerDidReceiveAd:(BeiZiBannerView *)beiziBanner;

/*
 banner曝光
 */
- (void)BeiZi_bannerDidPresentScreen:(BeiZiBannerView *)beiziBanner;

/**
 Banner点击
 */
- (void)BeiZi_bannerDidClick:(BeiZiBannerView *)beiziBanner;

/*
 banner点击不喜欢
 */
- (void)BeiZi_bannerDislikeDidClick:(BeiZiBannerView *)beiziBanner;

/*
 banner关闭
 */
- (void)BeiZi_bannerDidClose:(BeiZiBannerView *)beiziBanner;

/**
 Banner请求失败
 */
- (void)BeiZi_banner:(BeiZiBannerView *)beiziBanner didFailToLoadAdWithError:(BeiZiRequestError *)error;

@end

NS_ASSUME_NONNULL_END
