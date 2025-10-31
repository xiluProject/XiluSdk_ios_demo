//
//  InterstitialAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK
//import ObjectMapper

class InterstitialAdViewController: UIViewController {
    
    private var loadButton: UIButton!
    private var showButton: UIButton!
    private var statusLabel: UILabel!
    
    private var interstitialAd: ADXiluInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "插屏广告"
        view.backgroundColor = .mainBackgroundColor
        
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
        showButton.setTitle("展示广告", for: .normal)
        showButton.backgroundColor = .systemGreen
        showButton.setTitleColor(.white, for: .normal)
        showButton.layer.cornerRadius = 8
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.addTarget(self, action: #selector(showAd), for: .touchUpInside)
        showButton.isHidden = true
        view.addSubview(showButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
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
        interstitialAd?.p_release()
        
        // 创建插屏广告
        // 创建开屏广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
        interstitialAd = ADXiluInterstitialAd(adPosId: "eb9m5gu5", adSize: adSize, rootVC: self)
        interstitialAd?.delegate = self
//        interstitialAd?.countdownDuration = 5.0
        
        statusLabel.text = "状态：正在加载..."
        statusLabel.textColor = .systemOrange
        
        interstitialAd?.loadAd()
//        showButton.isHidden = true
//        interstitialAd?.loadAd()
    }
    
    @objc private func showAd() {
        guard let interstitialAd = interstitialAd else {
            showAlert(title: "错误", message: "广告未加载")
            return
        }
        
        interstitialAd.showAd(from: self)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        interstitialAd?.p_release()
    }
}

// MARK: - ADXiluInterstitialAdDelegate
extension InterstitialAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
//        appLog("广告加载成功:", adInfo.toJSON())
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载成功 \n点击'展示广告'按钮查看效果"
            self.statusLabel.textColor = .systemGreen
            self.loadButton.isEnabled = true
            self.showButton.isHidden = false
        }
    }
    
    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "插屏广告被点击 - \(String(describing: adInfo.platform.name))")
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
