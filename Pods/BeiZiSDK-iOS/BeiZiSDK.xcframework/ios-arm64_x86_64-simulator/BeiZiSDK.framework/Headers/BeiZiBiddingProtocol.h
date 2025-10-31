//
//  BeiZiBiddingProtocol.h
//  BeiZiSDK
//
//  Created by Cookie on 2024/8/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//  ADN列表
typedef NS_ENUM(NSInteger, BeiZiBiddingADNList) {
    kBeiZiBiddingADNListGDT           = 1012,
    kBeiZiBiddingADNListCSJ           = 1013,
    kBeiZiBiddingADNListBaiDu         = 1018,
    kBeiZiBiddingADNListKS            = 1019,
    kBeiZiBiddingADNListJD            = 1021,
    kBeiZiBiddingADNListGM            = 1022,
    kBeiZiBiddingADNListBeiZi         = 6666,
    kBeiZiBiddingADNListOther         = 9999,
};

//  竞价失败原因
typedef NS_ENUM(NSInteger, BeiZiBiddingLossReason) {
    kBeiZiBiddingLossReasonLowPrice          = 1,        // 价格低于其他渠道
    kBeiZiBiddingLossReasonLoadTimeout       = 2,        // 获取价格超时
    kBeiZiBiddingLossReasonOther             = 999       // 其他
};

#define BeiZi_WIN_PRICE @"winPrice"
#define BeiZi_ADNID @"adnId"
#define BeiZi_HIGHRST_LOSS_PRICE @"highestLossPrice"
#define BeiZi_LOSS_REASON @"lossReason"

@protocol BeiZiBiddingProtocol <NSObject>

@required
/**
 单位：人民币（分）
 */
@property (nonatomic, assign) NSInteger eCPM;

@optional

/**
 注意：必须为有效的字符串格式的键值对！！！！！
 @param winInfo 竞胜信息，字典类型
 BeiZi_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
 BeiZi_ADNID ：失败渠道中最高价格渠道ID，必填（value值使用字符串即可）
 BeiZi_HIGHRST_LOSS_PRICE ：失败渠道中最高价格，必填（value值使用字符串即可）
 */
- (void)sendWinNotificationWithInfo:(NSDictionary <NSString *, NSString *> *)winInfo;

/**
 注意：必须为有效的字符串格式的键值对！！！！！
 @param lossInfo 竞败信息，字典类型
 BeiZi_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
 BeiZi_ADNID ：竞胜渠道ID，必填（value值使用字符串即可）
 BeiZi_LOSS_REASON ：失败原因，必填（value值使用字符串即可）
 */
- (void)sendLossNotificationWithInfo:(NSDictionary <NSString *, NSString *> *)lossInfo;

@end

NS_ASSUME_NONNULL_END
