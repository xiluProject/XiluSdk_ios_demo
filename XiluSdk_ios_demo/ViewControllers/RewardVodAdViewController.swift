//
//  RewardVodAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK
//import ObjectMapper

class RewardVodAdViewController: UIViewController {
    
    private var loadButton: UIButton!
    private var showButton: UIButton!
    private var statusLabel: UILabel!
    private var rewardLabel: UILabel!
    
    private var rewardVodAd: ADXiluRewardVodAd?
    private var totalReward: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "激励视频广告"
        view.backgroundColor = .mainBackgroundColor
        
        // 创建奖励标签
        rewardLabel = UILabel()
        rewardLabel.text = "总奖励：0"
        rewardLabel.textAlignment = .center
        rewardLabel.font = UIFont.boldSystemFont(ofSize: 18)
        rewardLabel.textColor = .systemOrange
        rewardLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rewardLabel)
        
        // 创建状态标签
        statusLabel = UILabel()
        statusLabel.text = "状态：未加载"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textColor = .systemBlue
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // 创建加载按钮
        loadButton = UIButton(type: .system)
        loadButton.setTitle("加载广告", for: .normal)
        loadButton.backgroundColor = .systemBlue
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 8
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.addTarget(self, action: #selector(loadAd), for: .touchUpInside)
        view.addSubview(loadButton)
        
        // 创建展示按钮
        showButton = UIButton(type: .system)
        showButton.setTitle("观看视频获得奖励", for: .normal)
        showButton.backgroundColor = .systemGreen
        showButton.setTitleColor(.white, for: .normal)
        showButton.layer.cornerRadius = 8
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.addTarget(self, action: #selector(showAd), for: .touchUpInside)
//        showButton.isEnabled = false
        view.addSubview(showButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            rewardLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            rewardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rewardLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: rewardLabel.bottomAnchor, constant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 50),
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            
            showButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 20),
            showButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func loadAd() {
        guard ADXiluSDK.shared.isInitialized else {
            showAlert(title: "错误", message: "SDK未初始化")
            return
        }
        
        // 释放之前的广告
        rewardVodAd?.p_release()
        
        // 创建激励视频广告
        rewardVodAd = ADXiluRewardVodAd(adPosId: "kumgm37j")
        rewardVodAd?.delegate = self
        rewardVodAd?.videoDelegate = self
        rewardVodAd?.isMuted = false
        
        statusLabel.text = "状态：正在加载..."
        statusLabel.textColor = .systemOrange
//        loadButton.isEnabled = false
        
        rewardVodAd?.loadAd()
    }
    
    @objc private func showAd() {
        guard let rewardVodAd = rewardVodAd else {
            showAlert(title: "错误", message: "广告未加载")
            return
        }
        
        rewardVodAd.showAd(from: self)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        rewardVodAd?.p_release()
    }
}

// MARK: - ADXiluInterstitialAdDelegate
extension RewardVodAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        //appLog("广告加载成功:", adInfo.toJSON())
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载成功 \n点击'观看视频'按钮查看效果"
            self.statusLabel.textColor = .systemGreen
            self.loadButton.isEnabled = true
            self.showButton.isHidden = false
        }
    }
    
    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "激励视频广告被点击 - \(String(describing: adInfo.platform.name))")
        }
    }
    
    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告关闭: \(adInfo)")
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已关闭"
            self.statusLabel.textColor = .systemBlue
        }
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        appLog("广告加载失败", error)
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载失败 - \(error.message)"
            self.statusLabel.textColor = .systemRed
            self.loadButton.isEnabled = true
            
            if !error.message.isEmpty {
                self.showAlert(title: "错误", message: error.message)
            }
        }
    }
    
    func xilu_AdDidExpose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告曝光: \(adInfo)")
    }
    
    func xilu_AdDidSkip(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告跳过: \(adInfo)")
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已跳过"
            self.statusLabel.textColor = .systemOrange
        }
    }
    
    func xilu_AdTick(_ xiluAd: ADXiluBaseAd, remainingTime: TimeInterval) {
        appLog("广告倒计时: \(remainingTime)")
    }
}

// MARK: - ADXiluRewardVodAdDelegate
extension RewardVodAdViewController: ADXiluRewardVodAdDelegate {
    func xilu_AdVideoDidCache(_ rewardVodAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载成功 - \(String(describing: adInfo.platform.name))\nid：\(rewardVodAd.adPosId) \(adInfo.isReady)\n点击'观看视频获得奖励'按钮"
            self.statusLabel.textColor = .systemGreen
//            self.loadButton.isEnabled = true
//            self.showButton.isEnabled = true
        }
        
//        DispatchQueue.main.async {
//            self.statusLabel.text = "状态：视频缓存完成 - \(String(describing: adInfo.platform.name))"
//            self.statusLabel.textColor = .systemGreen
//        }
    }
    
    func xilu_AdVideoDidComplete(_ rewardVodAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：视频播放完成 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func xilu_AdVideoDidError(_ rewardVodAd: ADXiluBaseAd, adInfo: ADXiluAdInfo, error: ADXiluError) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：视频播放错误 - \(error.message)"
            self.statusLabel.textColor = .systemRed
            self.showAlert(title: "播放错误", message: error.message)
        }
    }
    
    func xilu_AdDidReward(_ rewardVodAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.totalReward += adInfo.rewardAmount
            self.rewardLabel.text = "总奖励：\(self.totalReward) "
            self.showAlert(title: "获得奖励", message: "恭喜获得 \(adInfo.rewardAmount) \(adInfo.rewardName)！")
        }
    }
    
    func rewardVodAdDidReceive(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载成功 - \(String(describing: adInfo.platform.name))\n奖励：\(adInfo.rewardAmount) \(adInfo.rewardName)\n点击'观看视频获得奖励'按钮"
            self.statusLabel.textColor = .systemGreen
//            self.loadButton.isEnabled = true
//            self.showButton.isEnabled = true
        }
    }
    
//    func rewardVodAdVideoDidCache(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
//        DispatchQueue.main.async {
//            self.statusLabel.text = "状态：视频缓存完成 - \(String(describing: adInfo.platform.name))"
//            self.statusLabel.textColor = .systemGreen
//        }
//    }
    
    func rewardVodAdVideoDidComplete(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：视频播放完成 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func rewardVodAdVideoDidError(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo, error: ADXiluError) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：视频播放错误 - \(error.message)"
            self.statusLabel.textColor = .systemRed
            self.showAlert(title: "播放错误", message: error.message)
        }
    }
    
    func rewardVodAdDidReward(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
        DispatchQueue.main.async {
            self.totalReward += adInfo.rewardAmount
            self.rewardLabel.text = "总奖励：\(self.totalReward)"
            self.showAlert(title: "获得奖励", message: "恭喜获得 \(adInfo.rewardAmount) \(adInfo.rewardName)！")
        }
    }
    
    func rewardVodAdDidExpose(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已曝光 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func rewardVodAdDidClick(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "激励视频广告被点击 - \(String(describing: adInfo.platform.name))")
        }
    }
    
    func rewardVodAdDidClose(_ rewardVodAd: ADXiluRewardVodAd, adInfo: ADXiluRewardVodAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已关闭"
            self.statusLabel.textColor = .systemBlue
//            self.showButton.isEnabled = false
        }
    }
    
    func rewardVodAdDidFail(_ rewardVodAd: ADXiluRewardVodAd, error: ADXiluError) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载失败 - \(error.message)"
            self.statusLabel.textColor = .systemRed
//            self.loadButton.isEnabled = true
//            self.showButton.isEnabled = false
            self.showAlert(title: "加载失败", message: error.message)
        }
    }
}
