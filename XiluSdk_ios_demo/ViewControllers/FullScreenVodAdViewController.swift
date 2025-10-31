//
//  FullScreenVodAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK

class FullScreenVodAdViewController: UIViewController {
    
    private var loadButton: UIButton!
    private var showButton: UIButton!
    private var statusLabel: UILabel!
    
    private var fullScreenVodAd: ADXiluFullScreenVodAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "全屏视频广告"
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
        showButton.isEnabled = false
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
        fullScreenVodAd?.p_release()
        
        // 创建全屏视频广告
        fullScreenVodAd = ADXiluFullScreenVodAd(adPosId: "fullscreen_vod_test_001")
        fullScreenVodAd?.delegate = self
        fullScreenVodAd?.extraDelegate = self
        fullScreenVodAd?.isMuted = false
        
        statusLabel.text = "状态：正在加载..."
        statusLabel.textColor = .systemOrange
        loadButton.isEnabled = false
        
        fullScreenVodAd?.loadAd()
    }
    
    @objc private func showAd() {
        guard let fullScreenVodAd = fullScreenVodAd else {
            showAlert(title: "错误", message: "广告未加载")
            return
        }
        
        fullScreenVodAd.showAd(from: self)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        fullScreenVodAd?.p_release()
    }
}

// MARK: - ADXiluFullScreenVodAdDelegate
extension FullScreenVodAdViewController: ADXiluFullScreenVodAdDelegate, ADXiluBaseAdDelegate {
    func fullScreenVodAdDidReceive(_ fullScreenVodAd: ADXiluFullScreenVodAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载成功 - \(String(describing: adInfo.platform.name))\n点击'展示广告'按钮查看效果"
            self.statusLabel.textColor = .systemGreen
            self.loadButton.isEnabled = true
            self.showButton.isEnabled = true
        }
    }
    
    func fullScreenVodAdDidExpose(_ fullScreenVodAd: ADXiluFullScreenVodAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已曝光 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func fullScreenVodAdDidClick(_ fullScreenVodAd: ADXiluFullScreenVodAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "全屏视频广告被点击 - \(String(describing: adInfo.platform.name))")
        }
    }
    
    func fullScreenVodAdDidClose(_ fullScreenVodAd: ADXiluFullScreenVodAd, adInfo: ADXiluAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已关闭"
            self.statusLabel.textColor = .systemBlue
            self.showButton.isEnabled = false
        }
    }
    
    func fullScreenVodAdDidFail(_ fullScreenVodAd: ADXiluFullScreenVodAd, error: ADXiluError) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载失败 - \(error.message)"
            self.statusLabel.textColor = .systemRed
            self.loadButton.isEnabled = true
            self.showButton.isEnabled = false
            self.showAlert(title: "加载失败", message: error.message)
        }
    }
}
