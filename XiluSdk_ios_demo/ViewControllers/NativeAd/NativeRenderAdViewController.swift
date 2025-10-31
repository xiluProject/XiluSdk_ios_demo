//
//  NativeAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK
//import ObjectMapper
import SnapKit
import MSAdSDK

class NativeRenderAdViewController: UIViewController {
    private lazy var datas: [Any] = []
    private lazy var nativeAds: [UIView] = []
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.rowHeight = UITableView.automaticDimension
        table.register(AppNativeAdContainerCell.self, forCellReuseIdentifier: "AppNativeAdContainerCell")
        return table
    }()
    
    private var nativeAd: ADXiluNativeAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAd()
    }
    
    private func setupUI() {
        title = "信息流广告"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        datas = ["模拟数据", "模拟数据", "模拟数据", "模拟数据", "模拟数据", "模拟数据", "模拟数据", "模拟数据"]
        tableView.reloadData()
    }
    
    @objc private func loadAd() {
        guard ADXiluSDK.shared.isInitialized else {
            showAlert(title: "错误", message: "SDK未初始化")
            return
        }
        
        // 释放之前的广告
        nativeAd?.p_release()
        
        // 创建信息流广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 300)
        nativeAd = ADXiluNativeAd(adPosId: "kuytugnw", adSize: adSize, count: 3)
        nativeAd?.isTemplate = false
        nativeAd?.nativeViewController = self
        nativeAd?.delegate = self
        
        nativeAd?.loadAd()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        nativeAd?.p_release()
    }
    
    func displayAd() {
        var mockDatas: [Any] = []
        for (index, adView) in nativeAds.enumerated() {
            mockDatas.append(contentsOf: datas)
            mockDatas.insert(adView, at: datas.count * index + 3)
        }
        datas = mockDatas
        tableView.reloadData()
    }
}

extension NativeRenderAdViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = datas[indexPath.row]
        var cell: UITableViewCell!
        
        if rowData is String {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.textLabel?.text = rowData as! String + "\(indexPath.row + 1)"
        } else if let adView = rowData as? MSNativeSimpleCustomAdView {
            cell = tableView.dequeueReusableCell(withIdentifier: "AppNativeAdContainerCell", for: indexPath) as? AppNativeAdContainerCell
            if nil == cell {
                cell = AppNativeAdContainerCell.init(style: .default, reuseIdentifier: "AppNativeAdContainerCell")
            }
            (cell as! AppNativeAdContainerCell).configAd(adView)
            adView.showNativeAd(withClick: adView.customImageAdViewClickViews(), presentVC: self)
            adView.openInteraction()
        } else if let adView = rowData as? MSNativeSimpleCustomVideoAdView {
            cell = tableView.dequeueReusableCell(withIdentifier: "AppNativeAdContainerCell", for: indexPath) as? AppNativeAdContainerCell
            if nil == cell {
                cell = AppNativeAdContainerCell.init(style: .default, reuseIdentifier: "AppNativeAdContainerCell")
            }
            (cell as! AppNativeAdContainerCell).configAd(adView)
            adView.showNativeAd(withClick: adView.customVideoAdViewClickViews(), presentVC: self)
            adView.openInteraction()
        } else if let adView = rowData as? UIView {
            cell = tableView.dequeueReusableCell(withIdentifier: "AppNativeAdContainerCell", for: indexPath) as? AppNativeAdContainerCell
            if nil == cell {
                cell = AppNativeAdContainerCell.init(style: .default, reuseIdentifier: "AppNativeAdContainerCell")
            }
            (cell as! AppNativeAdContainerCell).configAd(adView)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
}
// MARK: - ADXiluNativeAdDelegate
extension NativeRenderAdViewController: ADXiluBaseAdDelegate {
    func xilu_AdDidReceiveMuti(_ xiluAd: ADXiluBaseAd, adInfos: [ADXiluAdInfo]) {
//        appLog("广告加载成功:", adInfos.toJSON())
        
        for adInfo in adInfos {
            if let adView = adInfo.extraData["nativeAdView"] as? UIView {
                nativeAds.append(adView)
            }
            if let model = adInfo.extraData["nativeAdData"] as? MSNativeFeedAdModel {
                //非视频类型自渲染广告
                if model.adMaterialMeta?.metaCreativeType() != MSCreativeType.video {
                    let adView:MSNativeSimpleCustomAdView = MSNativeSimpleCustomAdView()
                    adView.delegate = self
                    adView.presentVc = self
                    adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    adView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                    nativeAds.append(adView)
                } else {
                    let adView: MSNativeSimpleCustomVideoAdView = MSNativeSimpleCustomVideoAdView()
                    adView.delegate = self
                    adView.presentVc = self
                    adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    adView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                    nativeAds.append(adView)
                }
            }
        }
        displayAd()
    }
    
    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        //appLog("广告加载成功:", adInfo.toJSON())
        if let adView = adInfo.extraData["nativeAdView"] as? UIView {
            nativeAds.append(adView)
        }
        if let model = adInfo.extraData["nativeAdData"] as? MSNativeFeedAdModel {
            //非视频类型自渲染广告
            if model.adMaterialMeta?.metaCreativeType() != MSCreativeType.video {
                let adView:MSNativeSimpleCustomAdView = MSNativeSimpleCustomAdView()
                adView.delegate = self
                adView.presentVc = self
                adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                adView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                nativeAds.append(adView)
            } else {
                let adView: MSNativeSimpleCustomVideoAdView = MSNativeSimpleCustomVideoAdView()
                adView.delegate = self
                adView.presentVc = self
                adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                adView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                nativeAds.append(adView)
            }
        }
        displayAd()
    }
    
    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告点击: \(adInfo)")
        DispatchQueue.main.async {
            self.showAlert(title: "广告点击", message: "原生自渲染广告被点击 - \(String(describing: adInfo.platform.name))")
        }
    }
    
    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告关闭: \(adInfo)")
        datas = datas.filter({ $0 is String })
        tableView.reloadData()
    }
    
    func xilu_AdDidFail(_ xiluAd: ADXiluBaseAd, error: ADXiluError) {
        appLog("广告加载失败:", error)        
        DispatchQueue.main.async {
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
    }
    
    func xilu_AdTick(_ xiluAd: ADXiluBaseAd, remainingTime: TimeInterval) {
        appLog("广告倒计时: \(remainingTime)")
    }
}

extension NativeRenderAdViewController: MSNativeSimpleCustomAdViewDelegate {
    
    func nativeSimpleImageAdViewClosed(adView: MSNativeCustomAdView) {
        
    }
    
    func nativeSimpleVideoAdViewClosed(adView: MSNativeCustomVideoAdView) {
        
    }
}

extension NativeRenderAdViewController: MSNativeSimpleCustomVideoAdViewDelegate {
    
}

//    func nativeSimpleImageAdViewClosed(adView: MSNativeCustomAdView) {
//        logAdInfo(string: #function)
//        container.removeFromSuperview()
//    }
//    func nativeSimpleVideoAdViewClosed(adView: MSNativeCustomVideoAdView) {
//        logAdInfo(string: #function)
//        container.removeFromSuperview()
//    }
