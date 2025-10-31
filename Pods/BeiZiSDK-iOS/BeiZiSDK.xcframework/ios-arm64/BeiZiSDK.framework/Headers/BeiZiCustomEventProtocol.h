//
//  BeiZiCustomEventProtocol.h
//  BeiZiSDK
//
//  Created by Cookie on 2025/5/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BeiZiCustomEventProtocol <NSObject>

@optional

/**
 自定义参数
 */
@property (nonatomic, strong) NSDictionary *extInfo;

/**
 广告信息
 */
@property (nonatomic, strong) NSDictionary *materialInfo;

@end
