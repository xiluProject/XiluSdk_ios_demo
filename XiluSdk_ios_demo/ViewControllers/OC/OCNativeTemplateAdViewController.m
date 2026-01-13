//
//  OCNativeTemplateAdViewController.m
//  ADXiluSDK_Example
//
//  Created by sagan on 2025/11/11.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

#import "OCNativeTemplateAdViewController.h"
#import "ADXiluSdk/ADXiluSDK-Swift.h"
//#import <Masonry/Masonry.h>

@interface OCNativeTemplateAdViewController () <UITableViewDelegate, UITableViewDataSource, ADXiluBaseAdDelegate>
// 标记广告插入位置（每5条内容插1条广告）
#define kAdInsertInterval 5

@property (nonatomic, strong) UITableView *contentTableView;
// 普通内容数据源
@property (nonatomic, strong) NSMutableArray *normalDataArray;
// 广告视图数组（存储已加载的广告视图）
@property (nonatomic, strong) NSMutableArray *adViewArray;

// 广告位ID（替换为自己的）
@property (nonatomic, copy) NSString *adSlotID;

@property (nonatomic, strong) ADXiluNativeAd *nativeAd;
@property (nonatomic, strong) UIStackView *adContainerView;
@end

@implementation OCNativeTemplateAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [UIColor whiteColor];
    // 1. 初始化基础数据
    [self initBaseData];
    // 2. 创建列表
    [self setupTableView];
    // 3. 初始化广告并加载
    [self initAdAndLoad];
}

#pragma mark - 初始化基础数据
- (void)initBaseData {
    // 模拟普通内容数据源
    self.normalDataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 20; i++) {
        [self.normalDataArray addObject:[NSString stringWithFormat:@"普通内容-%ld", i+1]];
    }
    
    self.adViewArray = [NSMutableArray array];
    // 替换为自己的广告位ID
    self.adSlotID = @"mp58pydr";
}

#pragma mark - 初始化广告加载器并加载广告
- (void)initAdAndLoad {
    // 1. 配置广告位信息
    [self.nativeAd loadAd];
}

- (ADXiluNativeAd *)nativeAd {
    if (!_nativeAd) {
        _nativeAd = [[ADXiluNativeAd alloc] initWithAdPosId:self.adSlotID adSize:[[ADXiluAdSize alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width height:200] count:3];
        _nativeAd.delegate = self;
        _nativeAd.nativeViewController = self;
    }
    return _nativeAd;
}

#pragma mark - 创建列表
- (void)setupTableView {
    self.contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // 注册普通Cell
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"NormalCellID"];
    [self.view addSubview:self.contentTableView];
}

#pragma mark - UITableView 代理 & 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 计算总行数 = 普通内容数 + 广告数
    NSInteger normalCount = self.normalDataArray.count;
    NSInteger adCount = self.adViewArray.count;
    // 按间隔计算可插入的广告数（避免广告超出列表）
    NSInteger maxAdCount = normalCount / kAdInsertInterval;
    adCount = MIN(adCount, maxAdCount);
    return normalCount + adCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 判断当前行是否为广告行
    if ([self isAdRow:indexPath.row]) {
        // 获取对应广告视图的高度
        UIView *adView = [self getAdViewForRow:indexPath.row];
        NSLog(@"模板广告视图:%@", adView);
        if (adView.frame.size.height > 0) {
            return adView.frame.size.height;
        } else {
            return 110;
        }
    }
    // 普通内容行高
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    // 广告行
    if ([self isAdRow:row]) {
        static NSString *adCellID = @"AdCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        // 移除cell内已有广告视图（避免复用冲突）
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        // 添加广告视图到cell
        UIView *adView = [self getAdViewForRow:row];
//        adView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:adView];
        return cell;
    }
    
    // 普通内容行
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCellID" forIndexPath:indexPath];
    // 计算普通内容的真实索引（扣除广告行数）
    NSInteger normalIndex = row - [self adCountBeforeRow:row];
    cell.textLabel.text = self.normalDataArray[normalIndex];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 辅助方法：判断行类型/获取广告视图
// 判断当前行是否为广告行
- (BOOL)isAdRow:(NSInteger)row {
    // 每kAdInsertInterval+1行是广告（如第5、11、17行...）
    if (self.adViewArray.count == 0) {
        return false;
    }
    BOOL isAd = (row + 1) % (kAdInsertInterval + 1) == 0 && (row + 1) / (kAdInsertInterval + 1) <= self.adViewArray.count;
//    NSLog(@"行号 - %ld, 是否广告: %d", row, isAd);
    return isAd;
}

// 获取指定行对应的广告视图
- (UIView *)getAdViewForRow:(NSInteger)row {
    NSInteger adIndex = (row + 1) / (kAdInsertInterval + 1) - 1;
    if (adIndex >= 0 && adIndex < self.adViewArray.count) {
        return self.adViewArray[adIndex];
    }
    return nil;
}

// 计算当前行之前的广告数量
- (NSInteger)adCountBeforeRow:(NSInteger)row {
    NSInteger adCount = 0;
    for (NSInteger i = kAdInsertInterval; i < row + 1; i += (kAdInsertInterval + 1)) {
        adCount++;
    }
    return MIN(adCount, self.adViewArray.count);
}

#pragma mark - 广告加载回调方法
- (void)xilu_AdDidReceiveMuti:(ADXiluBaseAd *)xiluAd adInfos:(NSArray<ADXiluAdInfo *> *)adInfos {
    NSLog(@"广告加载成功：%@", adInfos);
    for (ADXiluAdInfo *adInfo in adInfos) {
        UIView *adTemplateView = adInfo.extraData[@"nativeAdView"];
        [self.adViewArray addObject:adTemplateView];
    }
    NSLog(@"广告数量:%ld", self.adViewArray.count);
    [self.contentTableView reloadData];
}

- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    UIView *adTemplateView = adInfo.extraData[@"nativeAdView"];
    // 移除关闭的广告视图
    [self.adViewArray removeObject:adTemplateView];
    [self.contentTableView reloadData];
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    
}
@end
