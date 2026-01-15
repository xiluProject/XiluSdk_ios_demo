//
//  OCInterstitialAdViewController.m
//  ADXiluSDK_Example
//
//  Created by sagan on 2025/11/11.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

#import "OCInterstitialAdViewController.h"
#import "ADXiluSDK/ADXiluSDK-Swift.h"
#import "ADXiluSDK/ADXiluSDK-Swift.h"
#import <BeiZiSDK/BeiZiInterstitial.h>
@interface OCInterstitialAdViewController ()<ADXiluBaseAdDelegate, BeiZiInterstitialDelegate>
@property (nonatomic, strong) ADXiluInterstitialAd *interstitialAd;
@end

@implementation OCInterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadInterstitialAd];
}
- (void)loadInterstitialAd {
    if (![ADXiluSDKManager shared].isInitialized) {
        [self showAlertWithTitle:@"错误" message:@"SDK未初始化"];
        return;
    }
    _interstitialAd = [[ADXiluInterstitialAd alloc] initWithAdPosId:@"eb9m5gu5"
                                                             adSize:[ADXiluAdSize screenSize]
                                                             rootVC:self];
    _interstitialAd.delegate = self;
    [self.interstitialAd loadAd];
}

- (void)xilu_AdDidReceive:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"插屏广告加载成功");
    [(ADXiluInterstitialAd *)xiluAd showAdFrom:self];
}

- (void)xilu_AdDidFail:(ADXiluBaseAd *)xiluAd error:(ADXiluError *)error {
    NSLog(@"插屏广告加载失败： %@", error);
}
- (void)xilu_AdDidClick:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"插屏广告被点击");
}
- (void)xilu_AdDidClose:(ADXiluBaseAd *)xiluAd adInfo:(ADXiluAdInfo *)adInfo {
    NSLog(@"插屏广告被关闭");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
