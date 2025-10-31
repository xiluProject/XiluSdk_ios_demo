//
//  BeiZiNativeDataObject.h
//  BeiZiSDK
//
//  Created by Cookie on 2022/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeiZiNativeDataObject : NSObject

/**
 广告标题
 */
@property (nonatomic, copy) NSString *title;

/**
 广告描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 应用类广告App 图标Url
 */
@property (nonatomic, copy) NSString *iconUrl;

/**
 广告对应的按钮展示文案，可能为图片
 此字段可能为空
 */
@property (nonatomic, copy) NSString *buttonText;

/**
 广告大图Url
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 多图地址
 */
@property (nonatomic, strong) NSArray *imageUrls;

/**
 广告logoUrl
 */
@property (nonatomic, copy) NSString *adLogoUrl;

/**
 是否为视频广告
 */
@property (nonatomic, assign) BOOL isVideoAd;

@end

NS_ASSUME_NONNULL_END
