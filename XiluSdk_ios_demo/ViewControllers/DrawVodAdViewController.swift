//
//  DrawVodAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK

class DrawVodAdViewController: UIViewController {
    
    private var containerView: UIView!
    private var loadButton: UIButton!
    private var statusLabel: UILabel!
    
    private var drawVodAd: ADXiluDrawVodAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Draw视频信息流"
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
        
        // 设置约束
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            loadButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30),
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func loadAd() {
        guard ADXiluSDK.shared.isInitialized else {
            showAlert(title: "错误", message: "SDK未初始化")
            return
        }
        
        // 释放之前的广告
        drawVodAd?.p_release()
        
        // 创建Draw视频信息流广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
        drawVodAd = ADXiluDrawVodAd(adPosId: "draw_vod_test_001", adSize: adSize, count: 1)
        drawVodAd?.delegate = self
        
        statusLabel.text = "状态：正在加载..."
        statusLabel.textColor = .systemOrange
        loadButton.isEnabled = false
        
        drawVodAd?.loadAd()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        drawVodAd?.p_release()
    }
}

// MARK: - ADXiluDrawVodAdDelegate
extension DrawVodAdViewController: ADXiluDrawVodAdDelegate {
    func drawVodAdDidReceive(_ drawVodAd: ADXiluDrawVodAd, adInfoList: [ADXiluDrawVodAdInfo]) {
        DispatchQueue.main.async {
            guard let adInfo = adInfoList.first else { return }
            self.statusLabel.text = "状态：加载成功 - \(String(describing: adInfo.platform.name))\n广告已显示在容器中"
            self.statusLabel.textColor = .systemGreen
            self.loadButton.isEnabled = true
            
            // 显示Draw视频广告内容
            self.showDrawVodAdContent(adInfo: adInfo)
        }
    }
    
    func drawVodAdDidExpose(_ drawVodAd: ADXiluDrawVodAd, adInfo: ADXiluDrawVodAdInfo) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：已曝光 - \(String(describing: adInfo.platform.name))"
            self.statusLabel.textColor = .systemGreen
        }
    }
    
    func drawVodAdDidClick(_ drawVodAd: ADXiluDrawVodAd, adInfo: ADXiluDrawVodAdInfo) {
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "Draw视频信息流广告被点击 - \(String(describing: adInfo.platform.name))")
        }
    }
    
    func drawVodAdDidFail(_ drawVodAd: ADXiluDrawVodAd, error: ADXiluError) {
        DispatchQueue.main.async {
            self.statusLabel.text = "状态：加载失败 - \(error.message)"
            self.statusLabel.textColor = .systemRed
            self.loadButton.isEnabled = true
            self.showAlert(title: "加载失败", message: error.message)
        }
    }
    
    private func showDrawVodAdContent(adInfo: ADXiluDrawVodAdInfo) {
        // 清除之前的广告内容
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // 获取广告视图并添加到容器中
        let adView = adInfo.getAdView()
        adView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(adView)
        
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            adView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(drawVodAdTapped))
        adView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func drawVodAdTapped() {
        guard let drawVodAd = drawVodAd,
              drawVodAd.getCurrentAdInfoList().first != nil else { return }
        // 这里应该调用广告的点击方法
        // drawVodAd.reportClick(adInfo: adInfo)
    }
}
