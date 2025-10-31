//
//  BeiZiFullscreenVideo.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BeiZiSDK/BeiZiBiddingProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BeiZiFullscreenVideoDelegate;
@class BeiZiRequestError;

@interface BeiZiFullscreenVideo : NSObject <BeiZiBiddingProtocol>

@property (nonatomic, copy, readonly) NSString *spaceID;
@property (nonatomic, copy, readonly) NSString *spaceParam;

/**
 单位：人民币（分）
 */
@property (nonatomic, assign) NSInteger eCPM;

/**
 渠道广告版本，1 or 2
 在 BeiZi_loadFullscreenVideoAd 前设置版本，默认1
*/
@property (nonatomic, assign) NSInteger adVersion;

/**
 广告是否加载完成。
*/
@property (nonatomic, readonly) BOOL adValid;

/**
 用来接收激励视频广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic, weak) id<BeiZiFullscreenVideoDelegate> delegate;

/**
 初始化方法
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @param lifeTime 超时时长，单位毫秒
 @return 全屏视频广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam
                       lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;

/**
 请求加载全屏视频广告
 */
- (void)BeiZi_loadFullscreenVideoAd;

/**
 全屏视频展示，确保广告加载成功后调用
 rootViewController 展示view的控制器或者弹出落地页的需要的控制器，此参数不能为空
 */
- (void)BeiZi_showFullscreenVideoAdFromRootViewController:(UIViewController *)rootViewController;

@end

/**
 代理方法
 */
@protocol BeiZiFullscreenVideoDelegate <NSObject>

@optional

/**
 全屏视频物料请求成功
 */
- (void)BeiZi_fullscreenVideoDidReceiveAd:(BeiZiFullscreenVideo *)beiziFullscreenVideo;

/**
 全屏展现并开始播放视频
 */
- (void)BeiZi_fullscreenVideoDidStartPlay:(BeiZiFullscreenVideo *)beiziFullscreenVideo;

/**
 全屏视频点击
 */
- (void)BeiZi_fullscreenVideoDidClick:(BeiZiFullscreenVideo *)beiziFullscreenVideo;

/**
 全屏视频消失
 */
- (void)BeiZi_fullscreenVideoDidDismissScreen:(BeiZiFullscreenVideo *)beiziFullscreenVideo;

/**
 全屏视频请求失败
 */
- (void)BeiZi_fullscreenVideo:(BeiZiFullscreenVideo *)beiziFullscreenVideo
 didFailToLoadAdWithError:(BeiZiRequestError *)error;

@end

NS_ASSUME_NONNULL_END
