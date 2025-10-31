//
//  BeiZiRequestError.h
//  BeiZiSDK
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// BeiZiSDK Ads error domain.
extern NSString *const kBeiZiErrorDomain;

// NSError codes for BeiZi error domain.
typedef NS_ENUM(NSInteger, BeiZiErrorCode) {
    kBeiZiErrorTimeout                              = 9999,
    
    // 未知错误
    kBeiZiErrorUnknow                               = 1,
    
    // 配置文件错误
    kBeiZiErrorConfigureError                       = 10001,
    
    // 未发现此广告位
    kBeiZiErrorSpaceIDNULL                          = 10100,
    
    // 广告类型不匹配
    kBeiZiErrorIDUseError                           = 10110,
    
    // 广告请求时间过短
    kBeiZiErrorRequestTimeLess                      = 10120,
    
    // 渠道过滤失败
    kBeiZiErrorFilterError                          = 10130,
    
    // 内部错误
    kBeiZiErrorStatusError                          = 10131,
    
    // 内部错误
    kBeiZiErrorInternalError                        = 10132,
    
    // 广告没有填充
    kBeiZiErrorNoFill                               = 10140,
    
    // 广告没有填充
    kBeiZiErrorFixedTimeNoFill                      = 10141,
    
    // 没有广告位信息
    kBeiZiErrorNoBuyerInfo                          = 10150,
    
    // 没有渠道SDK
    kBeiZiErrorNoFoundSDK                           = 10151,
    
    // 渠道未知错误
    kBeiZiErrorChannelUnknow                        = 10160,
    
    // 广告load失败
    kBeiZiErrorLoadAdError                          = 10200,
    
    // 广告类型不匹配
    kBeiZiErrorMapIDError                           = 10220,
    
    // 广告请求频繁
    kBeiZiErrorFrequentError                        = 10300,
    
};

@interface BeiZiRequestError : NSError

+ (BeiZiRequestError *)errorWithCode:(BeiZiErrorCode)code;

@end

NS_ASSUME_NONNULL_END
