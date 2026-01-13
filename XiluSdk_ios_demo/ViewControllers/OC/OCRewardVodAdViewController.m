//
//  OCRewardVodAdViewController.m
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

#import "OCRewardVodAdViewController.h"
#import "ADXiluSdk/ADXiluSDK-Swift.h"
void appLog(NSString *format, ...) {
va_list args;
va_start(args, format);
NSString *logString = [[NSString alloc] initWithFormat:format arguments:args];
va_end(args);
NSLog(@"[DemoApp] %@", logString);
}
@interface OCRewardVodAdViewController () <ADXiluBaseAdDelegate, ADXiluRewardVodAdDelegate>

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *rewardLabel;

@property (nonatomic, strong) ADXiluRewardVodAd *rewardVodAd;
@property (nonatomic, assign) NSInteger totalReward;

@end

@implementation OCRewardVodAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = @"激励视频广告";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建奖励标签
    self.rewardLabel = [[UILabel alloc] init];
    self.rewardLabel.text = @"总奖励：0";
    self.rewardLabel.textAlignment = NSTextAlignmentCenter;
    self.rewardLabel.font = [UIFont boldSystemFontOfSize:18];
    self.rewardLabel.textColor = [UIColor systemOrangeColor];
    self.rewardLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.rewardLabel];
    
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
    [self.loadButton addTarget:self action:@selector(loadRewardVodAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadButton];
    
    // 创建展示按钮
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setTitle:@"观看视频获得奖励" forState:UIControlStateNormal];
    self.showButton.backgroundColor = [UIColor systemGreenColor];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.showButton.layer.cornerRadius = 8;
    self.showButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.showButton addTarget:self action:@selector(showAd) forControlEvents:UIControlEventTouchUpInside];
    // showButton.enabled = NO;
    [self.view addSubview:self.showButton];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.rewardLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [self.rewardLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.rewardLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.rewardLabel.bottomAnchor constant:30],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.loadButton.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:50],
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.loadButton.heightAnchor constraintEqualToConstant:50],
        
        [self.showButton.topAnchor constraintEqualToAnchor:self.loadButton.bottomAnchor constant:20],
        [self.showButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.showButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.showButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)loadRewardVodAd {
    if (![ADXiluSDKManager.shared isInitialized]) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    
    // 释放之前的广告
    [self.rewardVodAd p_release];
    
    // 创建激励视频广告
    self.rewardVodAd = [[ADXiluRewardVodAd alloc] initWithAdPosId:@"kumgm37j"];
    self.rewardVodAd.delegate = self;
    self.rewardVodAd.videoDelegate = self;
    self.rewardVodAd.isMuted = NO;
    
    self.statusLabel.text = @"状态：正在加载...";
    self.statusLabel.textColor = [UIColor systemOrangeColor];
    // loadButton.enabled = NO;
    
    [self.rewardVodAd loadAd];
}

- (void)showAd {
    if (!self.rewardVodAd) {
        [self showAlertWithTitle:@"错误" message:@"广告未加载"];
        return;
    }
    
    [self.rewardVodAd showAdFrom:self];
}

- (void)dealloc {
    [self.rewardVodAd p_release];
}

#pragma mark - ADXiluBaseAdDelegate

- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告加载成功:", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：加载成功 \n点击'观看视频'按钮查看效果";
        self.statusLabel.textColor = [UIColor systemGreenColor];
        self.loadButton.enabled = YES;
        self.showButton.hidden = NO;
    });
}

- (void)xilu_AdDidClick:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithTitle:@"广告点击"
                         message:[NSString stringWithFormat:@"激励视频广告被点击 - %ld", adInfo.platform]];
    });
}

- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告关闭: %@", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：已关闭";
        self.statusLabel.textColor = [UIColor systemBlueColor];
    });
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    appLog(@"广告加载失败", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：加载失败 - %@", error.message];
        self.statusLabel.textColor = [UIColor systemRedColor];
        self.loadButton.enabled = YES;
        
        if (error.message.length > 0) {
            [self showAlertWithTitle:@"错误" message:error.message];
        }
    });
}

- (void)xilu_AdDidExpose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告曝光: %@", adInfo);
}

- (void)xilu_AdDidSkip:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    appLog(@"广告跳过: %@", adInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：已跳过";
        self.statusLabel.textColor = [UIColor systemOrangeColor];
    });
}

- (void)xilu_AdTick:(ADXiluBaseAd *)xiluAd remainingTime:(NSTimeInterval)remainingTime {
    appLog(@"广告倒计时: %f", remainingTime);
}

#pragma mark - ADXiluRewardVodAdDelegate

- (void)xilu_AdVideoDidCache:(ADXiluBaseAd *)rewardVodAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：加载成功 - %ld\nid：%@%@\n点击'观看视频获得奖励'按钮",
                                 adInfo.platform, rewardVodAd.adPosId, adInfo.isReady ? @"已准备" : @"未准备"];
        self.statusLabel.textColor = [UIColor systemGreenColor];
        // self.loadButton.enabled = YES;
        // self.showButton.enabled = YES;
    });
}

- (void)xilu_AdVideoDidComplete:(ADXiluBaseAd *)rewardVodAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：视频播放完成 - %ld", adInfo.platform];
        self.statusLabel.textColor = [UIColor systemGreenColor];
    });
}

- (void)xilu_AdVideoDidError:(ADXiluBaseAd *)rewardVodAd adInfo:(ADXiluAdInfo *)adInfo error:(ADXiluError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：视频播放错误 - %@", error.message];
        self.statusLabel.textColor = [UIColor systemRedColor];
        [self showAlertWithTitle:@"播放错误" message:error.message];
    });
}

- (void)xilu_AdDidReward:(ADXiluBaseAd *)rewardVodAd adInfo:(ADXiluAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalReward += adInfo.rewardAmount;
        self.rewardLabel.text = [NSString stringWithFormat:@"总奖励：%ld ", (long)self.totalReward];
        [self showAlertWithTitle:@"获得奖励"
                         message:[NSString stringWithFormat:@"恭喜获得 %ld %@！", (long)adInfo.rewardAmount, adInfo.rewardName]];
    });
}

- (void)rewardVodAdDidReceive:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：加载成功 - %ld\n奖励：%ld %@\n点击'观看视频获得奖励'按钮",
                                 adInfo.platform, (long)adInfo.rewardAmount, adInfo.rewardName];
        self.statusLabel.textColor = [UIColor systemGreenColor];
        // self.loadButton.enabled = YES;
        // self.showButton.enabled = YES;
    });
}

- (void)rewardVodAdVideoDidComplete:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：视频播放完成 - %ld", adInfo.platform];
        self.statusLabel.textColor = [UIColor systemGreenColor];
    });
}

- (void)rewardVodAdVideoDidError:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo error:(ADXiluError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：视频播放错误 - %@", error.message];
        self.statusLabel.textColor = [UIColor systemRedColor];
        [self showAlertWithTitle:@"播放错误" message:error.message];
    });
}

- (void)rewardVodAdDidReward:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalReward += adInfo.rewardAmount;
        self.rewardLabel.text = [NSString stringWithFormat:@"总奖励：%ld", (long)self.totalReward];
        [self showAlertWithTitle:@"获得奖励"
                         message:[NSString stringWithFormat:@"恭喜获得 %ld %@！", (long)adInfo.rewardAmount, adInfo.rewardName]];
    });
}

- (void)rewardVodAdDidExpose:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：已曝光 - %ld", adInfo.platform];
        self.statusLabel.textColor = [UIColor systemGreenColor];
    });
}

- (void)rewardVodAdDidClick:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertWithTitle:@"广告点击"
                         message:[NSString stringWithFormat:@"激励视频广告被点击 - %ld", adInfo.platform]];
    });
}

- (void)rewardVodAdDidClose:(ADXiluRewardVodAd *)rewardVodAd adInfo:(ADXiluRewardVodAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = @"状态：已关闭";
        self.statusLabel.textColor = [UIColor systemBlueColor];
        // self.showButton.enabled = NO;
    });
}

- (void)rewardVodAdDidFail:(ADXiluRewardVodAd *)rewardVodAd error:(ADXiluError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = [NSString stringWithFormat:@"状态：加载失败 - %@", error.message];
        self.statusLabel.textColor = [UIColor systemRedColor];
        // self.loadButton.enabled = YES;
        // self.showButton.enabled = NO;
        [self showAlertWithTitle:@"加载失败" message:error.message];
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
