//
//  BeiZiNativeExpress.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BeiZiSDK/BeiZiBiddingProtocol.h>
#import <BeiZiSDK/BeiZiCustomEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BeiZiNativeAdvertisingStyle) {
    kBeiZiNativeAdvertisingStyleSinglePicture        = 0,
    kBeiZiNativeAdvertisingStyleLRTextPicture        = 1,
    kBeiZiNativeAdvertisingStyleTBPictureText        = 2
};

@protocol BeiZiNativeExpressDelegate;
@class BeiZiNativeAdDataModel;
@class BeiZiRequestError;

@interface BeiZiNativeExpress : NSObject <BeiZiBiddingProtocol, BeiZiCustomEventProtocol>

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
 用来接收原生广告获取状态变化通知的 delegate
 */
@property (nonatomic, weak) id<BeiZiNativeExpressDelegate> delegate;

/**
 渠道广告版本，1 or 2
 在 BeiZi_loadRewardedVideoAd 前设置版本，默认1
*/
@property (nonatomic, assign) NSInteger adVersion;

/**
 广告类型
*/
@property (nonatomic, assign) BeiZiNativeAdvertisingStyle adStyle;

/**
 beiziNativeViewController 展示view的控制器或者弹出落地页的需要的控制器，此参数不能为空
 */
@property (nonatomic, weak) UIViewController *beiziNativeViewController;


/**
 初始化方法
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @return 原生广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam
                       lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;


/**
 广告加载成功后获得的 View广告（数组内部为加载完成的View形式广告，直接add到目标View）
 */
@property (nonatomic, strong, readonly) NSArray *channeNativeAdView;

/**
 Native 获取
 @param viewSize 原生广告展示的size
 */
- (void)BeiZi_loadNativeExpressAdWithViewSize:(CGSize)viewSize;

/**
 S2S请求
 */
- (void)BeiZi_loadNativeExpressAdWithViewSize:(CGSize)viewSize token:(NSString *)respToken;


/**
 * 释放广告资源
 */
- (void)BeiZi_removeAds;


@end

/**
 代理方法
 */
@protocol BeiZiNativeExpressDelegate <NSObject>

@optional

/**
 原生模板广告请求成功
 */
- (void)BeiZi_nativeExpressDidLoad:(BeiZiNativeExpress *)beiziNativeExpress;

/**
 原生模板广告显示
 */
- (void)BeiZi_nativeExpressDidShow:(BeiZiNativeExpress *)beiziNativeExpress;

/**
 原生模板广告点击
 */
- (void)BeiZi_nativeExpressDidClick:(BeiZiNativeExpress *)beiziNativeExpress;

/**
 原生模板广告点击关闭
 */
- (void)BeiZi_nativeExpressDislikeDidClick:(BeiZiNativeExpress *)beiziNativeExpress;

/**
 原生模板广告请求失败
 */
- (void)BeiZi_nativeExpress:(BeiZiNativeExpress *)beiziNativeExpress didFailToLoadAdWithError:(BeiZiRequestError *)error;


@end

NS_ASSUME_NONNULL_END
