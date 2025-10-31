//
//  BannerAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK

class BannerAdViewController: UIViewController {
    
    private var containerView: UIView!
    private var loadButton: UIButton!
    private var closeButton: UIButton!
    private var statusLabel: UILabel!
    
    private var bannerAd: ADXiluBannerAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Banner广告"
        view.backgroundColor = .mainBackgroundColor
        
        // 创建状态标签
        statusLabel = UILabel()
        statusLabel.text = "状态：未加载"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textColor = .systemBlue
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // 创建容器视图
        containerView = UIView()
        containerView.backgroundColor = .dividingColor
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // 创建加载按钮
        loadButton = UIButton(type: .system)
        loadButton.setTitle("加载广告", for: .normal)
        loadButton.backgroundColor = .systemBlue
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.layer.cornerRadius = 8
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.addTarget(self, action: #selector(loadAd), for: .touchUpInside)
        view.addSubview(loadButton)
        
        // 创建关闭按钮
        closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭广告", for: .normal)
        closeButton.backgroundColor = .systemRed
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 8
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeAd), for: .touchUpInside)
        view.addSubview(closeButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            loadButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30),
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func loadAd() {
        guard ADXiluSDK.shared.isInitialized else {
            showAlert(title: "错误", message: "SDK未初始化")
            return
        }
        
        // 释放之前的广告
        // 创建Banner广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 60)
        bannerAd = ADXiluBannerAd(adPosId: "ajebtp3k", adSize: adSize)
        bannerAd?.showCloseBtn = true
        bannerAd?.containerView = containerView
        bannerAd?.nativeViewController = self
        bannerAd?.delegate = self
        bannerAd?.autoRefreshInterval = 5
        
        statusLabel.text = "状态：正在加载..."
        statusLabel.textColor = .systemOrange
        
        bannerAd?.loadAd()
    }
    
    @objc private func closeAd() {
        bannerAd?.dismissAd()
        statusLabel.text = "状态：已关闭"
        statusLabel.textColor = .systemRed
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    deinit {

    }
}

// MARK: - ADXiluBaseAdDelegate
extension BannerAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载成功 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func xilu_AdDidExpose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已曝光 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载失败 - \(error.message)"
            self.statusLabel.textColor = .systemRed
            self.showAlert(title: "加载失败", message: error.message)
        }
    }
    
    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "Banner广告被点击 - \(String(describing: adInfo.platform.name))")
        }
    }
    
    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已关闭"
            self.statusLabel.textColor = .systemRed
        }
    }
}
