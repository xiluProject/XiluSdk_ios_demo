//
//  BeiZiURLResponseSerialization.h
//  BeiZiFoundation
//
//  Created by Arthur on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT id BeiZiJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions);

@protocol BeiZiURLResponseSerialization <NSObject, NSSecureCoding, NSCopying>

- (nullable id)responseObjectForResponse:(nullable NSURLResponse *)response
                           data:(nullable NSData *)data
                          error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

@end

#pragma mark -

@interface BeiZiHTTPResponseSerializer : NSObject <BeiZiURLResponseSerialization>

- (instancetype)init;

+ (instancetype)serializer;

@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;

@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;

- (BOOL)validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error;

@end

#pragma mark -

@interface BeiZiJSONResponseSerializer : BeiZiHTTPResponseSerializer

- (instancetype)init;

@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

@property (nonatomic, assign) BOOL removesKeysWithNullValues;

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end

#pragma mark -

@interface BeiZiXMLParserResponseSerializer : BeiZiHTTPResponseSerializer

@end

#pragma mark -

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

@interface BeiZiXMLDocumentResponseSerializer : BeiZiHTTPResponseSerializer

- (instancetype)init;

@property (nonatomic, assign) NSUInteger options;

+ (instancetype)serializerWithXMLDocumentOptions:(NSUInteger)mask;

@end

#endif

#pragma mark -

@interface BeiZiPropertyListResponseSerializer : BeiZiHTTPResponseSerializer

- (instancetype)init;

@property (nonatomic, assign) NSPropertyListFormat format;

@property (nonatomic, assign) NSPropertyListReadOptions readOptions;

+ (instancetype)serializerWithFormat:(NSPropertyListFormat)format
                         readOptions:(NSPropertyListReadOptions)readOptions;

@end

#pragma mark -

@interface BeiZiImageResponseSerializer : BeiZiHTTPResponseSerializer

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH

@property (nonatomic, assign) CGFloat imageScale;

@property (nonatomic, assign) BOOL automaticallyInflatesResponseImage;
#endif

@end

#pragma mark -

@interface BeiZiCompoundResponseSerializer : BeiZiHTTPResponseSerializer

@property (readonly, nonatomic, copy) NSArray <id<BeiZiURLResponseSerialization>> *responseSerializers;

+ (instancetype)compoundSerializerWithResponseSerializers:(NSArray <id<BeiZiURLResponseSerialization>> *)responseSerializers;

@end

FOUNDATION_EXPORT NSString * const BeiZiURLResponseSerializationErrorDomain;

FOUNDATION_EXPORT NSString * const BeiZiNetworkingOperationFailingURLResponseErrorKey;

FOUNDATION_EXPORT NSString * const BeiZiNetworkingOperationFailingURLResponseDataErrorKey;

NS_ASSUME_NONNULL_END
