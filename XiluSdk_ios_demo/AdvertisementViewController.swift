//
//  AdvertisementViewController.swift
//  XiluSdk_ios_demo
//
//  Created by Rohoninfo Sh on 2026/6/15.
//

import UIKit
import ADXiluSDK

class AdvertisementViewController: UIViewController {
    private var splashAd: ADXiluSplashAd?
    private var showButton: UIButton!
    lazy var adverImage: UIImageView = {
        let imgView = UIImageView()
        imgView.isUserInteractionEnabled = false // 禁止图片拦截点击
        return imgView
    }()
    var notifyObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        
     
        // 全屏启动图背景
        adverImage.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        view.addSubview(adverImage)
        
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let launchView = storyboard.instantiateInitialViewController()?.view else { return }
        launchView.frame = UIScreen.main.bounds
        launchView.layoutIfNeeded()
        
        let renderer = UIGraphicsImageRenderer(size: launchView.bounds.size)
        let launchImage = renderer.image { ctx in
            launchView.layer.render(in: ctx.cgContext)
        }
        adverImage.image = launchImage
        setupShowButton()
        // 通知监听
        notifyObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name("testNotify"),
            object: nil,
            queue: .main
        ) { _ in
//            self.loadAd()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
                    self?.loadAd()
                }
        }
    }
    
    // 抽离按钮创建逻辑
    private func setupShowButton() {
        showButton = UIButton(type: .system)
        showButton.setTitle("展示广告", for: .normal)
        showButton.backgroundColor = .systemGreen
        showButton.setTitleColor(.white, for: .normal)
        showButton.layer.cornerRadius = 8
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.addTarget(self, action: #selector(showAd), for: .touchUpInside)
        view.addSubview(showButton)
        showButton.isHidden = true
        NSLayoutConstraint.activate([
            showButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            showButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// 按钮点击入口
    @objc private func showAd() {
        print("点击展示广告按钮")
      
    }
    
    /// 加载开屏广告
    @objc private func loadAd() {
        guard ADXiluSDKManager.shared.isInitialized else {
            print("SDK未初始化")
            return
        }
        // 复用实例，避免重复创建
        if splashAd == nil {
            let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
            splashAd = ADXiluSplashAd(adPosId: AppConst.splashPosId, style: .halfScreen, adSize: adSize)
            splashAd?.countdownDuration = 5.0
        }
        splashAd?.delegate = self
        splashAd?.loadAd()
        print("开始请求广告")
    }
    
    
}

extension AdvertisementViewController: ADXiluBaseAdDelegate {
    // 广告加载成功 【关键：这里执行展示】
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("广告加载成功，准备展示")
        DispatchQueue.main.async {
            guard let splash = self.splashAd else { return }
            splash.showAd(in: self.view)
        }
    }
    
    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("广告点击: \(adInfo)")
    }
    
    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("广告关闭: \(adInfo)")
        DispatchQueue.main.async {
            // 广告关闭后清空，下次重新拉取
            self.splashAd?.delegate = nil
            self.splashAd = nil
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        print("广告加载失败: \(error.code) \(error.message)")
    }
    
    func xilu_AdDidExpose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("广告曝光: \(adInfo)")
    }
    
    func xilu_AdDidSkip(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        print("广告跳过: \(adInfo)")
    }
    
    func xilu_AdTick(_ xiluAd: ADXiluBaseAd, remainingTime: TimeInterval) {
        print("广告倒计时剩余: \(remainingTime)s")
    }
}
