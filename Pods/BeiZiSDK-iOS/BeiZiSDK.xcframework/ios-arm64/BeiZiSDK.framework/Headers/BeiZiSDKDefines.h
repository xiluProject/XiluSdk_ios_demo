//
//  BeiZiSDKDefines.h
//  Pods
//
//  Created by Cookie on 2021/7/5.
//

#import <Foundation/Foundation.h>

#if defined(__has_attribute)
#if __has_attribute(deprecated)
#define BeiZi_DEPRECATED_MSG_ATTRIBUTE(s) __attribute__((deprecated(s)))
#define BeiZi_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#else
#define BeiZi_DEPRECATED_MSG_ATTRIBUTE(s)
#define BeiZi_DEPRECATED_ATTRIBUTE
#endif
#else
#define BeiZi_DEPRECATED_MSG_ATTRIBUTE(s)
#define BeiZi_DEPRECATED_ATTRIBUTE
#endif
