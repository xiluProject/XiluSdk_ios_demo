//
//  OCBannerAdViewController.m
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

#import "OCBannerAdViewController.h"
#import "ADXiluSdk/ADXiluSDK-Swift.h"
@interface OCBannerAdViewController ()<ADXiluBaseAdDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong, nullable) ADXiluBannerAd *bannerAd;

@end

@implementation OCBannerAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"Banner广告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"状态：未加载";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    self.statusLabel.textColor = [UIColor systemBlueColor];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // 创建容器视图
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 8;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    
    // 创建加载按钮
    self.loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadButton setTitle:@"加载广告" forState:UIControlStateNormal];
    self.loadButton.backgroundColor = [UIColor systemBlueColor];
    [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loadButton.layer.cornerRadius = 8;
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadButton addTarget:self action:@selector(loadBannerAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadButton];
    
    // 创建关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"关闭广告" forState:UIControlStateNormal];
    self.closeButton.backgroundColor = [UIColor systemRedColor];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.layer.cornerRadius = 8;
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.closeButton addTarget:self action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    // 设置约束
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
        // 状态标签约束
        [self.statusLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:20],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        // 容器视图约束
        [self.containerView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:20],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.containerView.heightAnchor constraintEqualToConstant:200],
        
        // 加载按钮约束
        [self.loadButton.topAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:30],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.loadButton.heightAnchor constraintEqualToConstant:50],
        
        // 关闭按钮约束
        [self.closeButton.topAnchor constraintEqualToAnchor:self.loadButton.bottomAnchor constant:20],
        [self.closeButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.closeButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

#pragma mark - Actions

- (void)loadBannerAd {
    if (![ADXiluSDKManager shared].isInitialized) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    
    // 释放之前的广告
    self.bannerAd = nil;
    
    // 创建Banner广告
    ADXiluAdSize *adSize = [[ADXiluAdSize alloc] initWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) height:60];
    self.bannerAd = [[ADXiluBannerAd alloc] initWithAdPosId:@"ajebtp3k" adSize:adSize];
    self.bannerAd.showCloseBtn = YES;
    self.bannerAd.containerView = self.containerView;
    self.bannerAd.nativeViewController = self;
    self.bannerAd.delegate = self;
    self.bannerAd.autoRefreshInterval = 5;
    
    self.statusLabel.text = @"状态：正在加载...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    
    [self.bannerAd loadAd];
}

- (void)closeAd {
    [self.bannerAd dismissAd];
    self.statusLabel.text = @"状态：已关闭";
    self.statusLabel.textColor = [UIColor systemRedColor];
}

#pragma mark - ADXiluBaseAdDelegate

- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：加载成功 - %ld", adInfo.platform];
        self.statusLabel.textColor = [UIColor systemGreenColor];
    });
}

- (void)xilu_AdDidExpose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：已曝光 - %ld", adInfo.platform];
        self.statusLabel.textColor = [UIColor systemGreenColor];
    });
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：加载失败 - %ld", error.message];
        self.statusLabel.textColor = [UIColor systemRedColor];
        [self showAlertWithTitle:@"加载失败" message:error.message];
    });
}

- (void)xilu_AdDidClick:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithTitle:@"广告点击"
                        message:[NSString stringWithFormat:@"Banner广告被点击 - %ld", adInfo.platform]];
    });
}

- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：已关闭";
        self.statusLabel.textColor = [UIColor systemRedColor];
    });
}
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
@end
