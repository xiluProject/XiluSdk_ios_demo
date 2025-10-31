//
//  BeiZiSplash.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BeiZiSDK/BeiZiBiddingProtocol.h>
#import <BeiZiSDK/BeiZiCustomEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BeiZiSplashButtonType) {
    BeiZiSplashButtonTypeFullScreen     = 1,
    BeiZiSplashButtonTypeDownloadBar    = 2
};

@protocol BeiZiSplashDelegate;
@class BeiZiRequestError;

@interface BeiZiSplash : NSObject <BeiZiBiddingProtocol, BeiZiCustomEventProtocol>

@property (nonatomic, strong) NSDictionary *extInfo;
@property (nonatomic, strong) NSDictionary *materialInfo;
@property (nonatomic, copy, readonly) NSString *spaceID;
@property (nonatomic, copy, readonly) NSString *spaceParam;
@property (nonatomic, copy, readonly) NSDictionary *customParam;
@property (nonatomic, copy, readonly) NSDictionary *anyParam;

/**
 单位：人民币（分）
 */
@property (nonatomic, assign) NSInteger eCPM;

/**
 用来接收开屏广告读取和展示状态变化通知的 delegate
 */
@property (nonatomic, weak) id<BeiZiSplashDelegate> delegate;

/**
 showLaunchImage 是否展示启动图片到广告显示。
 ps：广告异步加载，会先进入主页，广告加载完成后在弹出，此属性可控制是否进入先进入主页。默认开启。
 请在load广告前设置是否需要。
 */
@property (nonatomic, assign) BOOL showLaunchImage;

/**
 是否为点睛广告
 */
@property (nonatomic, assign, readonly) BOOL isZoomOutAd;

/**
 launchImage 展示的启动图片到广告显示。
 */
@property (nonatomic, strong) UIImage *launchImage;

/**
 广告点击区域类型设置
 */
@property (nonatomic, assign) BeiZiSplashButtonType splashButtonType;

/**
 初始化方法
 @param spaceID 广告位 ID
 @param spaceParam 广告位参数 可填写任意字符串
 @param lifeTime 给予广告请求时间
 @return 开屏广告对象
 */
- (instancetype)initWithSpaceID:(NSString *)spaceID
                     spaceParam:(NSString *)spaceParam
                       lifeTime:(uint64_t)lifeTime NS_DESIGNATED_INITIALIZER;

/**
 请求加载开屏广告并控制是否要不显示，需要用此方法load
 */
- (void)BeiZi_loadSplashAd;

/**
 S2S请求
 */
- (void)BeiZi_loadSplashAdWithToken:(NSString *)respToken;

/**
 显示广告
 广告返回后调用此方法
 */
- (void)BeiZi_showSplashAdWithWindow:(UIWindow *)window;

/**
 使用BeiZi_loadAndDisplaySplashAd加载的开屏，不在显示。
 */
- (void)BeiZi_removeSplashAd;

/**
 显示点睛广告视图
 @param rootViewController 广告视图消失后显示的主页面，如果不为主页面会导致点击后无效果，降低广告单价
 */
- (void)BeiZi_showZoomOutSplashAdWithController:(UIViewController *)rootViewController;

/**
 获取启动图片，特殊需求时获取
 @return 启动Image
 */
+ (UIImage *)BeiZi_launchImage;

/**
 获取视图
 */
- (UIView *)getAnyView;

@end

/**
 代理方法
 */
@protocol BeiZiSplashDelegate <NSObject>

@optional

/**
 @return 展示下部logo位置，需要给传入view设置尺寸。
 */
- (UIView *)BeiZi_splashBottomView;

/**
 开屏请求成功
 */
- (void)BeiZi_splashDidLoadSuccess:(BeiZiSplash *)beiziSplash;

/**
 开屏展现
 */
- (void)BeiZi_splashDidPresentScreen:(BeiZiSplash *)beiziSplash;

/**
 开屏点击
 */
- (void)BeiZi_splashDidClick:(BeiZiSplash *)beiziSplash;

/**
 开屏即将消失
 */
- (void)BeiZi_splashWillDismissScreen:(BeiZiSplash *)beiziSplash;


/**
 开屏已经消失
 */
- (void)BeiZi_splashDidDismissScreen:(BeiZiSplash *)beiziSplash;

/**
 开屏请求失败
 */
- (void)BeiZi_splash:(BeiZiSplash *)beiziSplash didFailToLoadAdWithError:(BeiZiRequestError *)error;

/**
 开屏剩余时间，自定义跳过按钮时候有回调
*/
- (void)BeiZi_splashAdLifeTime:(int)lifeTime;

/**
 开屏点睛点击
 */
- (void)BeiZi_splashZoomOutDidClick:(BeiZiSplash *)beiziSplash;
/**
 开屏点睛关闭
 */
- (void)BeiZi_splashZoomOutDidClose:(BeiZiSplash *)beiziSplash;

@end

NS_ASSUME_NONNULL_END
