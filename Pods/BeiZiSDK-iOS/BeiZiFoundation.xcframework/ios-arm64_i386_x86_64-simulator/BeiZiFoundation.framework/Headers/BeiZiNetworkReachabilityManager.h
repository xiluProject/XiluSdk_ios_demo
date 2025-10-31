//
//  BeiZiNetworkReachabilityManager.h
//  BeiZiFoundation
//
//  Created by Arthur on 2021/7/5.
//
#import <Foundation/Foundation.h>

#if !TARGET_OS_WATCH
#import <SystemConfiguration/SystemConfiguration.h>

typedef NS_ENUM(NSInteger, BeiZiNetworkReachabilityStatus) {
    BeiZiNetworkReachabilityStatusUnknown          = -1,
    BeiZiNetworkReachabilityStatusNotReachable     = 0,
    BeiZiNetworkReachabilityStatusReachableViaWWAN = 1,
    BeiZiNetworkReachabilityStatusReachableViaWiFi = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface BeiZiNetworkReachabilityManager : NSObject

@property (readonly, nonatomic, assign) BeiZiNetworkReachabilityStatus networkReachabilityStatus;

@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

+ (instancetype)sharedManager;

+ (instancetype)manager;

+ (instancetype)managerForDomain:(NSString *)domain;

+ (instancetype)managerForAddress:(const void *)address;

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (void)startMonitoring;

- (void)stopMonitoring;

- (NSString *)localizedNetworkReachabilityStatusString;

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(BeiZiNetworkReachabilityStatus status))block;

@end

FOUNDATION_EXPORT NSString * const BeiZiNetworkingReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString * const BeiZiNetworkingReachabilityNotificationStatusItem;

FOUNDATION_EXPORT NSString * BeiZiStringFromNetworkReachabilityStatus(BeiZiNetworkReachabilityStatus status);

NS_ASSUME_NONNULL_END
#endif
