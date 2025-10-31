//
//  BeiZiRewardedVideo.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BeiZiSDK/BeiZiBiddingProtocol.h>
#import <BeiZiSDK/BeiZiCustomEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BeiZiRewardedVideoDelegate;
@class BeiZiRequestError;

@interface BeiZiRewardedVideo : NSObject <BeiZiBiddingProtocol, BeiZiCustomEventProtocol>

@property (nonatomic, strong) NSDictionary *extInfo;
@property (nonatomic, strong) NSDictionary *materialInfo;
@property (nonatomic, copy, readonly) NSString *spaceID;
@property (nonatomic, copy, readonly) NSString *spaceParam;

/**
 单位：人民币（分）
 */
@property (nonatomic, assign) NSInteger eCPM;

// 媒体生成的用户ID
@property (nonatomic, strong) NSString *userID;
// 其他附加信息传递
@property (nonatomic, strong) NSString *extraInfo;



/**
 渠道广告版本，1 or 2
 在 BeiZi_loadRewardedVideoAd 前设置版本，默认1
*/
@property (nonatomic, assign) NSInteger adVersion;

/**
 广告是否有效。
*/
@property (nonatomic, readonly) BOOL adValid;

/**
 用来接收激励视频广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic, weak) id<BeiZiRewardedVideoDelegate> delegate;

/**
 初始化方法
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @param lifeTime 超时时长，单位毫秒
 @return 激励视频广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam
                       lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;

/**
 请求加载激励视频广告
 */
- (void)BeiZi_loadRewardedVideoAd;

/**
 S2S请求
 */
- (void)BeiZi_loadRewardedVideoAdWithToken:(NSString *)respToken;

/**
 激励视频展示，确保广告加载成功后调用
 rootViewController 展示view的控制器或者弹出落地页的需要的控制器，此参数不能为空
 */
- (void)BeiZi_showRewardedVideoAdFromRootViewController:(UIViewController *)rootViewController;

@end

/**
 代理方法
 */
@protocol BeiZiRewardedVideoDelegate <NSObject>

@optional

/**
 激励视频物料请求成功
 */
- (void)BeiZi_rewardedVideoDidReceiveAd:(BeiZiRewardedVideo *)beiziRewardedVideo;

/**
 激励展现并开始播放视频
 */
- (void)BeiZi_rewardedVideoDidStartPlay:(BeiZiRewardedVideo *)beiziRewardedVideo;

/**
 激励视频点击
 */
- (void)BeiZi_rewardedVideoDidClick:(BeiZiRewardedVideo *)beiziRewardedVideo;

/**
 激励视频播放完成
 */
- (void)BeiZi_rewardedVideoDidPlayEnd:(BeiZiRewardedVideo *)beiziRewardedVideo;

/**
 激励视频消失
 */
- (void)BeiZi_rewardedVideoDidDismissScreen:(BeiZiRewardedVideo *)beiziRewardedVideo;

/**
 激励视频请求失败
 */
- (void)BeiZi_rewardedVideo:(BeiZiRewardedVideo *)beiziRewardedVideo
 didFailToLoadAdWithError:(BeiZiRequestError *)error;

/**
 激励视频奖励
 如果有渠道时，此方法仅限用于给用户发放奖励回调，奖励内容不可用。
 @param reward 奖励内容 JSON字符串，自行解析
 */
- (void)BeiZi_rewardedVideo:(BeiZiRewardedVideo *)beiziRewardedVideo
  didRewardUserWithReward:(NSObject *)reward;

@end

NS_ASSUME_NONNULL_END
