//
//  BeiZiSecurityPolicy.h
//  BeiZiFoundation
//
//  Created by Arthur on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BeiZiSSLPinningMode) {
    BeiZiSSLPinningModeNone,
    BeiZiSSLPinningModePublicKey,
    BeiZiSSLPinningModeCertificate,
};

@interface BeiZiSecurityPolicy : NSObject <NSSecureCoding, NSCopying>

@property (readonly, nonatomic, assign) BeiZiSSLPinningMode SSLPinningMode;

@property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;

@property (nonatomic, assign) BOOL allowInvalidCertificates;

@property (nonatomic, assign) BOOL validatesDomainName;

+ (NSSet <NSData *> *)certificatesInBundle:(NSBundle *)bundle;

+ (instancetype)defaultPolicy;

+ (instancetype)policyWithPinningMode:(BeiZiSSLPinningMode)pinningMode;

+ (instancetype)policyWithPinningMode:(BeiZiSSLPinningMode)pinningMode withPinnedCertificates:(NSSet <NSData *> *)pinnedCertificates;

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(nullable NSString *)domain;


@end

NS_ASSUME_NONNULL_END
