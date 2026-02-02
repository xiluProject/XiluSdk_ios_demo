//
//  OCNativeRenderAdViewController.m
//  ADXiluSDK_Example
//
//  Created by sagan on 2025/11/11.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

#import "OCNativeRenderAdViewController.h"
#import "ADXiluSDK/ADXiluSDK-Swift.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <MSAdSDK/MSNativeFeedAdModel.h>
#import <MSAdSDK/MSFeedAdMeta.h>
#import <GDTMobSDK/GDTUnifiedNativeAdDataObject.h>
#import <GDTMobSDK/GDTUnifiedNativeAdView.h>
@interface OCNativeRenderAdViewController ()<ADXiluBaseAdDelegate>
@property (nonatomic, strong) ADXiluNativeAd *nativeAd;
@property (nonatomic, strong) UIStackView *adContainerView;
@end

@implementation OCNativeRenderAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.adContainerView];
    [self.adContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    [self loadNativeAd];
}


- (UIStackView *)adContainerView {
    if (!_adContainerView) {
        _adContainerView = [UIStackView new];
        _adContainerView.alignment = UIStackViewAlignmentFill;
        _adContainerView.distribution = UIStackViewDistributionFill;
        _adContainerView.axis = UILayoutConstraintAxisVertical;
        _adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        _adContainerView.spacing = 20;
    }
    return _adContainerView;
}

- (void)loadNativeAd {
    _nativeAd = [[ADXiluNativeAd alloc] initWithAdPosId:@"59jmkybj" adSize:[ADXiluAdSize screenSize] count:3];
    _nativeAd.delegate = self;
    _nativeAd.containerView = nil;
    _nativeAd.isTemplate = false;
    [self.nativeAd loadAd];
}


- (void)xilu_AdDidReceiveMuti:(ADXiluBaseAd *)xiluAd adInfos:(NSArray<ADXiluAdInfo *> *)adInfos {
    NSLog(@"广告加载成功：%@", adInfos);
    for (ADXiluAdInfo *adInfo in adInfos) {
        UIView *adTemplateView = adInfo.extraData[@"nativeAdView"];
       
        id  nativeAdData = adInfo.extraData[@"nativeAdData"];
        //模板广告
        if (adTemplateView) {
            [self.adContainerView addArrangedSubview:adTemplateView];//替换成广告容器视图
        } else if ([nativeAdData isKindOfClass:[MSNativeFeedAdModel class]]) {
            MSNativeFeedAdModel *adModel = adInfo.extraData[@"nativeAdData"];
            //自渲染广告，取nativeAdData自行展示，字段说明如下：
//            MSCreativeTypeImage      = 1, // 图片
//            MSCreativeTypeVideo      = 2, // 视频 用metaVideoUrl播放视频
//            MSCreativeTypeSmallImage = 11, // 小图
//            MSCreativeTypeLargeImage = 12, // 大图
//            MSCreativeTypeThreeImage = 13, // 三图
//            MSCreativeTypePrerender  = 100000, // 预渲染
            NSLog(@"广告类型：%ld", (long)adModel.adMaterialMeta.metaCreativeType);
            NSLog(@"标题:%@", adModel.adMaterialMeta.metaTitle);
            NSLog(@"内容:%@", adModel.adMaterialMeta.metaContent);
            NSLog(@"图标:%@", adModel.adMaterialMeta.metaIcon);
            NSLog(@"来源:%@", adModel.adMaterialMeta.metaSource);
            NSLog(@"视频url:%@", adModel.adMaterialMeta.metaVideoUrl);
            NSLog(@"图片素材:%@", adModel.adMaterialMeta.metaImageUrls);
            UIView *adView = [self createAdView:adModel];
            [adView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAdDetail)]];
            [self.adContainerView addArrangedSubview:adView];
        }
        else if ([nativeAdData isKindOfClass:[GDTUnifiedNativeAdDataObject class]]) {
            GDTUnifiedNativeAdDataObject *adModel = (GDTUnifiedNativeAdDataObject *) adInfo.extraData[@"nativeAdData"];
            GDTUnifiedNativeAdView *adView = [[GDTUnifiedNativeAdView alloc]init];
        
            adView.viewController = self;
            adView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 145);
            adView.mediaView.frame = adView.bounds;
            if (adModel.isAdValid) {
                [adView registerDataObject:adModel clickableViews:nil];
                [self.adContainerView addArrangedSubview:adView];
            }
        }
    }
}

- (void)showAdDetail {
    UIViewController *adDetailVC = [UIViewController new];
    adDetailVC.view.backgroundColor = [UIColor cyanColor];
    adDetailVC.modalPresentationStyle = UIModalPresentationPopover;
    [self.navigationController presentViewController:adDetailVC animated:YES completion:nil];
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"广告加载失败：%@", error.message);
}

- (UIView *)createAdView:(MSNativeFeedAdModel *)adModel {
    //广告视图
    UIView *adView = [UIView new];
    //标题标签
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.text = adModel.adMaterialMeta.metaTitle;
    [adView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    //这里以单图广告为例，多图需自行处理展示规则
    UIImageView *mainImg = [UIImageView new];
    [mainImg sd_setImageWithURL:[NSURL URLWithString:adModel.adMaterialMeta.metaImageUrls[0]]];
    [adView addSubview:mainImg];
    [mainImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(6);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(-10);
    }];
    
    //内容标签
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor lightGrayColor];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contentLabel.text = adModel.adMaterialMeta.metaContent;
    [adView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainImg);
        make.left.mas_equalTo(mainImg.mas_right).offset(6);
        make.right.mas_equalTo(-10);
    }];
    
    //背景色（便于调试）
    adView.backgroundColor = [UIColor cyanColor];
    return adView;
}

@end
