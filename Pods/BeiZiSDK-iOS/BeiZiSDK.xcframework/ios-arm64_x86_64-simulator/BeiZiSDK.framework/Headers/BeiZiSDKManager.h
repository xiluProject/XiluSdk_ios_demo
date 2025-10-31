//
//  BeiZiSDKManager.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BeiZiSDKInitStatus) {
    //  未初始化
    kBeiZiSDKInitStatusNormal          = 0,
    //  初始化完成
    kBeiZiSDKInitStatusSuccess         = 1,
    //  初始化中重复调用
    kBeiZiSDKInitStatusFailRepeat      = 2,
};

typedef void (^BeiZiSDKInitResults)(BeiZiSDKInitStatus results);

@interface BeiZiSDKManager : NSObject

/**
 配置 AppID
 @param applicationID 商户分配到的唯一appID
 */
+ (void)configureWithApplicationID:(NSString *)applicationID;

+ (void)configureWithApplicationID:(NSString *)applicationID
                           results:(BeiZiSDKInitResults)results;

/**
 配置 AppID
 @param ext 自定义字典
 */
+ (void)setAnyCustomExt:(NSDictionary *)ext;

/**
 配置 AppID
 @param channelString 自定义参数
 */
+ (void)appChannelString:(NSString *)channelString;

/**
 是否使用个性化推荐广告信息的能力
 @param state YES使用，NO不使用，默认为YES
 */
+ (void)setPersonalRecommend:(BOOL)state;

/**
 自定义IDFA
 @param idfa 确保idfa的真实性，避免填充率过低
 */
+ (void)setCustomIDFA:(NSString *)idfa;

/**
 开启错误日志
 */
+ (void)openTheBeiZiLog;

/**
  设置用户信息, ⚠️注意：请在广告初始化前设置该属性！！！
  已支持的key有：
  @"lng", 实时的地理位置经度, 值为字符串格式的经度值, 比如 @"116.67765"
  @"lat", 实时的地理位置纬度, 值为字符串格式的纬度值, 比如 @"39.365678"
  @"type", 坐标系类型，比如 @"WGS84"
  @"locTime", 实时的地理位置获取时间, 值为字符串格式的unix时间戳, 单位秒, 比如 @"1639450944"
  @"isLocation", 是否授权SDK位置使用权限, 默认全部授权, 字符串格式设置 @"0" @"1" @"2", 0代表不授权；1代表全授权；2代表仅授权粗略位置；
 */
+ (void)setExtraUserData:(NSDictionary <NSString *, NSString *> *)userDictionary;

/**
 是否运行设置音频会话
 默认允许，如遵循外部，设置NO
 */
+ (void)enableAudioSessionSetting:(BOOL)enabled;

/**
 ⚠️注意：请在广告初始化成功后获取
 获取S2S 的 sdkToken
 */
+ (NSString *)getSDKInfoWithSpaceId:(NSString *)spaceId;

/**
 SDK版本号
 @return SDK版本号
 */
+ (NSString *)sdkVersion;

/**
 仅支持部分渠道
 */
+ (void)closeShakeInteraction;

/**
 开启部分HTTPS，影响填充，使用前联系开发者
 */
+ (void)openAnyHTTPS:(BOOL)state;
+ (void)openHTTPS:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
