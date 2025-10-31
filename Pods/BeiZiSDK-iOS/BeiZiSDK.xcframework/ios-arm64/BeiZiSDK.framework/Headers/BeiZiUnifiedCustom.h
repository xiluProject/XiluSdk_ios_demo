//
//  BeiZiUnifiedCustom.h
//  BeiZiSDK
//
//  Created by Cookie on 2022/3/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BeiZiUnifiedCustomDelegate;
@class BeiZiRequestError;

@interface BeiZiUnifiedCustom : NSObject

@property (nonatomic, copy, readonly) NSString *spaceID;
@property (nonatomic, copy, readonly) NSString *spaceParam;

/**
 用来接收自定义广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic, weak) id <BeiZiUnifiedCustomDelegate> delegate;

/**
 初始化方法
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @param lifeTime 给予广告请求时间
 @return 自定义广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam
                       lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;

/**
 请求加载自定义广告
 */
- (void)BeiZi_loadUnifiedCustomAd;

/**
 显示广告
 广告返回后调用此方法
 */
- (void)BeiZi_showUnifiedCustomAdWithViewController:(UIViewController *)rootViewController;

/**
 adType为1时，adView会有内容
 */
@property (nonatomic, assign) NSInteger adType;
/**
 广告View
 */
@property (nonatomic, strong) UIView *adView;

/**
 弹出落地页的需要的控制器
 */
@property (nonatomic, weak) UIViewController *rootViewController;

/**
 销毁并移除广告
 */
- (void)BeiZi_removeUnifiedCustom;

@end

/**
 代理方法
 */
@protocol BeiZiUnifiedCustomDelegate <NSObject>

@optional
/**
 自定义广告请求成功
 */
- (void)BeiZi_unifiedDidLoadSuccess:(BeiZiUnifiedCustom *)unifiedCustom;

/**
 自定义展现
 */
- (void)BeiZi_unifiedDidPresentScreen:(BeiZiUnifiedCustom *)unifiedCustom;

/**
 自定义点击
 */
- (void)BeiZi_unifiedDidClick:(BeiZiUnifiedCustom *)unifiedCustom;

/**
 自定义详情页关闭
 */
- (void)BeiZi_unifiedDidCloseDetailView:(BeiZiUnifiedCustom *)unifiedCustom;

/**
 自定义已经消失
 */
- (void)BeiZi_unifiedDidDismissScreen:(BeiZiUnifiedCustom *)unifiedCustom;

/**
 自定义请求失败
 */
- (void)BeiZi_unified:(BeiZiUnifiedCustom *)unifiedCustom didFailToLoadAdWithError:(BeiZiRequestError *)error;

@end

NS_ASSUME_NONNULL_END
