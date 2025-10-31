//
//  BeiZiNetworking.h
//  BeiZiFoundation
//
//  Created by Arthur on 2021/7/5.
//

#import <Foundation/Foundation.h>
#import <Availability.h>
#import <TargetConditionals.h>

#ifndef _BeiZiNETWORKING_
    #define _BeiZiNETWORKING_

    #import <BeiZiFoundation/BeiZiURLRequestSerialization.h>
    #import <BeiZiFoundation/BeiZiURLResponseSerialization.h>
    #import <BeiZiFoundation/BeiZiSecurityPolicy.h>

#if !TARGET_OS_WATCH
    #import <BeiZiFoundation/BeiZiNetworkReachabilityManager.h>
#endif

    #import <BeiZiFoundation/BeiZiURLSessionManager.h>
    #import <BeiZiFoundation/BeiZiHTTPSessionManager.h>

#endif /* _BeiZiNETWORKING_ */
