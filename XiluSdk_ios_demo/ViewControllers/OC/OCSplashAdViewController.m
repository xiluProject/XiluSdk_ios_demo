//
//  OCSplashAdViewController.m
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

#import "OCSplashAdViewController.h"
#import "ADXiluSdk/ADXiluSDK-Swift.h"
#import <Masonry/Masonry.h>
@interface OCSplashAdViewController () <ADXiluBaseAdDelegate>
void appLog(NSString *format, ...) {
va_list args;
va_start(args, format);
NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
va_end(args);
NSLog(@"[DemoApp] %@", logString);
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) ADXiluSplashAd *splashAd;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation OCSplashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppLogo"]];
        [_bottomView addSubview:logo];
        logo.layer.cornerRadius = 20;
        logo.layer.borderWidth = 5;
        logo.layer.borderColor = [UIColor whiteColor].CGColor;
        logo.layer.masksToBounds = YES;
        
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bottomView);
            make.width.height.equalTo(@80);
        }];
    }
    return _bottomView;
}

- (void)setupUI {
    self.title = @"开屏广告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"状态：未加载";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:16];
    self.statusLabel.textColor = [UIColor systemBlueColor];
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // 创建加载按钮
    self.loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadButton setTitle:@"加载广告" forState:UIControlStateNormal];
    self.loadButton.backgroundColor = [UIColor systemBlueColor];
    [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loadButton.layer.cornerRadius = 8;
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadButton addTarget:self action:@selector(loadSplashAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadButton];
    
    // 创建展示按钮
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setTitle:@"展示广告" forState:UIControlStateNormal];
    self.showButton.backgroundColor = [UIColor systemGreenColor];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showButton.layer.cornerRadius = 8;
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.showButton addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    self.showButton.hidden = YES;
    [self.view addSubview:self.showButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.loadButton.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:30],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.loadButton.heightAnchor constraintEqualToConstant:50],
        
        [self.showButton.topAnchor constraintEqualToAnchor:self.loadButton.bottomAnchor constant:20],
        [self.showButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.showButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.showButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)loadSplashAd {
    if (![ADXiluSDKManager.shared isInitialized]) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    
    // 释放之前的广告
    [self.splashAd p_release];
    
    // 创建开屏广告
    ADXiluAdSize *adSize = [[ADXiluAdSize alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width height:300];
    self.splashAd = [[ADXiluSplashAd alloc] initWithAdPosId:@"6m35dgjn" style:ADXiluSplashAdStyleHalfScreen adSize:adSize];
    self.splashAd.bottomView = self.bottomView;
    self.splashAd.delegate = self;
    self.splashAd.countdownDuration = 5.0;
    
    self.statusLabel.text = @"状态：正在加载...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    self.loadButton.enabled = NO;
    
    [self.splashAd loadAd];
    self.showButton.hidden = YES;
}

- (void)showAd {
    if (!self.splashAd) {
        [self showAlertWithTitle:@"错误" message:@"广告未加载"];
        return;
    }
    
    [self.splashAd showAdIn:self.containerView];
}

- (void)dealloc {
    [self.splashAd p_release];
}

#pragma mark - ADXiluBaseAdDelegate

- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告加载成功:", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：加载成功 \n点击'展示广告'按钮查看效果";
        self.statusLabel.textColor = [UIColor systemGreenColor];
        self.loadButton.enabled = YES;
        self.showButton.hidden = NO;
    });
}

- (void)xilu_AdDidClick:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告点击: %@", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"广告点击");
//        [self showAlertWithTitle:@"广告点击"
//                         message:[NSString stringWithFormat:@"开屏广告被点击 - %ld", adInfo.platform]];
    });
}

- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告关闭: %@", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：已关闭";
        self.statusLabel.textColor = [UIColor systemBlueColor];
        self.countdownLabel.text = @"倒计时：--";
        // self.showButton.enabled = YES;
    });
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    appLog(@"广告加载失败: %@", error);
    [self showAlertWithTitle:@"失败" message:error.message];
}

- (void)xilu_AdDidExpose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告曝光: %@", adInfo);
}

- (void)xilu_AdDidSkip:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告跳过: %@", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：已跳过";
        self.statusLabel.textColor = [UIColor systemOrangeColor];
        self.countdownLabel.text = @"倒计时：--";
    });
}

- (void)xilu_AdTick:(ADXiluBaseAd *)xiluAd remainingTime:(NSTimeInterval)remainingTime {
    appLog(@"广告倒计时: %f", remainingTime);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.countdownLabel.text = [NSString stringWithFormat:@"倒计时：%ds", (int)remainingTime];
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
