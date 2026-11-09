//
//  NativeAdViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK
import SnapKit
import MSAdSDK
#if canImport(GDTMobSDK)
import GDTMobSDK
#endif
#if canImport(KSAdSDK)
import KSAdSDK
#endif
#if canImport(BaiduMobAdSDK)
import BaiduMobAdSDK
#endif

class NativeRenderAdViewController: UIViewController {

    private lazy var datas: [Any] = []
    private lazy var nativeAds: [Any] = []

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension   // 保留自适应，实际高度由 heightForRowAt 决定
        table.estimatedRowHeight = 150
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
        guard ADXiluSDKManager.shared.isInitialized else {
            showAlert(title: "错误", message: "SDK未初始化")
            return
        }

        // 释放之前的广告
        nativeAd?.p_release()

        // 创建信息流广告
        let adSize = ADXiluAdSize(width: UIScreen.main.bounds.width, height: 150)
        nativeAd = ADXiluNativeAd(adPosId: AppConst.renderFeedPosId, adSize: adSize, count: 3)
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

    /// 将 nativeAds 插入到纯字符串数据里，基于纯字符串重建，避免重复累积
    func displayAd() {
        let strings = datas.compactMap { $0 as? String }
        var mockDatas: [Any] = []
        for (index, ad) in nativeAds.enumerated() {
            mockDatas.append(contentsOf: strings)
            let insertIndex = min(strings.count * index + 3, mockDatas.count)
            mockDatas.insert(ad, at: insertIndex)
        }
        datas = mockDatas
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NativeRenderAdViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = datas[indexPath.row]

        // 1. 纯文本
        if let text = rowData as? String {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = text + "\(indexPath.row + 1)"
            return cell
        }

        // 2. ms自渲染（图片）
        if let adView = rowData as? MSNativeSimpleCustomAdView {
            let cell = dequeueContainerCell(tableView, indexPath: indexPath)
            cell.configAd(adView)
            adView.showNativeAd(withClick: adView.customImageAdViewClickViews(), presentVC: self)
            adView.openInteraction()
            return cell
        }

        // 3. ms自渲染（视频）
        if let adView = rowData as? MSNativeSimpleCustomVideoAdView {
            let cell = dequeueContainerCell(tableView, indexPath: indexPath)
            cell.configAd(adView)
            adView.showNativeAd(withClick: adView.customVideoAdViewClickViews(), presentVC: self)
            adView.openInteraction()
            return cell
        }

        // 4. 快手自渲染
        if let ksNativeAd = rowData as? KSNativeAd {
            let cell: KSNativeFeedCell
            switch ksNativeAd.data?.materialType {
            case .video:
                if let c = tableView.dequeueReusableCell(withIdentifier: "cellVideo") as? KSNativeFeedVideoCell {
                    cell = c
                } else {
                    cell = KSNativeFeedVideoCell(style: .default, reuseIdentifier: "cellVideo")
                }
            case .single:
                if let c = tableView.dequeueReusableCell(withIdentifier: "cellSingle") as? KSNativeFeedSingleImageCell {
                    cell = c
                } else {
                    cell = KSNativeFeedSingleImageCell(style: .default, reuseIdentifier: "cellSingle")
                }
            case .atlas:
                if let c = tableView.dequeueReusableCell(withIdentifier: "cellAtlas") as? KSNativeFeedAtlasImageCell {
                    cell = c
                } else {
                    cell = KSNativeFeedAtlasImageCell(style: .default, reuseIdentifier: "cellAtlas")
                }
            default:
                if let c = tableView.dequeueReusableCell(withIdentifier: "cellBase") as? KSNativeFeedCell {
                    cell = c
                } else {
                    cell = KSNativeFeedCell(style: .default, reuseIdentifier: "cellBase")
                }
            }
            cell.refresh(with: ksNativeAd)
            return cell
        }

        // 5. 其他任意 UIView（广点通 GDTUnifiedNativeAdView / 百度 / nativeAdView）
        if let adView = rowData as? UIView {
            let cell = dequeueContainerCell(tableView, indexPath: indexPath)
            cell.configAd(adView)
            return cell
        }

        // 6. 兜底：避免崩溃
        return UITableViewCell(style: .default, reuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    private func dequeueContainerCell(_ tableView: UITableView, indexPath: IndexPath) -> AppNativeAdContainerCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AppNativeAdContainerCell", for: indexPath) as? AppNativeAdContainerCell {
            return cell
        }
        return AppNativeAdContainerCell(style: .default, reuseIdentifier: "AppNativeAdContainerCell")
    }
}

// MARK: - ADXiluBaseAdDelegate
extension NativeRenderAdViewController: ADXiluBaseAdDelegate {

    func xilu_AdDidReceiveMuti(_ xiluAd: ADXiluBaseAd, adInfos: [ADXiluAdInfo]) {
        appLog("广告加载成功:", adInfos)

        for adInfo in adInfos {
            // 1) SDK 已经生成的 nativeAdView
            if let adView = adInfo.extraData["nativeAdView"] as? UIView {
                nativeAds.append(adView)
            }
            // 2) ms自渲染
            else if let model = adInfo.extraData["nativeAdData"] as? MSNativeFeedAdModel {
                if model.adMaterialMeta?.metaCreativeType() != MSCreativeType.video {
                    let adView = MSNativeSimpleCustomAdView()
                    adView.delegate = self
                    adView.presentVc = self
                    adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    adView.frame = CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                    nativeAds.append(adView)
                } else {
                    let adView = MSNativeSimpleCustomVideoAdView()
                    adView.delegate = self
                    adView.presentVc = self
                    adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    adView.frame = CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                    nativeAds.append(adView)
                }
            }
            // 3) 广点通自渲染
            else if let dataObject = adInfo.extraData["nativeAdData"] as? GDTUnifiedNativeAdDataObject {
                let adView = GDTUnifiedNativeAdView()
                guard let adSize = self.nativeAd?.adSize else { continue }
                let frame = CGRect(x: 0, y: 0, width: adSize.width, height: adSize.height)
                adView.viewController = self
                adView.frame = frame
                adView.mediaView.frame = adView.bounds
                if dataObject.isAdValid {
                    adView.registerDataObject(dataObject, clickableViews: [])
                    nativeAds.append(adView)
                }
            }
            // 4) 百度自渲染
            else if let dataObject = adInfo.extraData["nativeAdData"] as? BaiduMobAdNativeAdObject {
                guard let adSize = self.nativeAd?.adSize else { continue }
                let frame = CGRect(x: 0, y: 0, width: adSize.width, height: adSize.height)
                if let videoView = BaiduMobAdVideoView(frame: frame, andObject: dataObject) {
                    nativeAds.append(videoView)
                }
            }
            // 5) 快手自渲染
            else if let ksNativeAd = adInfo.extraData["nativeAdData"] as? KSNativeAd {
                ksNativeAd.delegate = self
                ksNativeAd.rootViewController = self
                nativeAds.append(ksNativeAd)
            }
            // 6) 兜底日志
            else {
                appLog("未匹配的 adInfo.extraData:", adInfo.extraData)
            }
        }
        displayAd()
    }

    func xilu_AdDidReceive(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告加载成功:", adInfo.toJSONString())

        if let adView = adInfo.extraData["nativeAdView"] as? UIView {
            nativeAds.append(adView)
        }

        if let model = adInfo.extraData["nativeAdData"] as? MSNativeFeedAdModel {
            if model.adMaterialMeta?.metaCreativeType() != MSCreativeType.video {
                let adView = MSNativeSimpleCustomAdView()
                adView.delegate = self
                adView.presentVc = self
                adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                adView.frame = CGRect(x: 0, y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                nativeAds.append(adView)
            } else {
                let adView = MSNativeSimpleCustomVideoAdView()
                adView.delegate = self
                adView.presentVc = self
                adView.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                adView.frame = CGRect(x: 0, y: 0,
                                      width: UIScreen.main.bounds.width,
                                      height: adView.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                nativeAds.append(adView)
            }
        }
        else if let ksNativeAd = adInfo.extraData["nativeAdData"] as? KSNativeAd {
            ksNativeAd.delegate = self
            ksNativeAd.rootViewController = self
            nativeAds.append(ksNativeAd)
        }

        displayAd()
    }

    func xilu_AdDidClick(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告点击: \(adInfo)")
    }

    func xilu_AdDidClose(_ xiluAd: ADXiluBaseAd, adInfo: ADXiluAdInfo) {
        appLog("广告关闭: \(adInfo)")
        datas = datas.filter { $0 is String }
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

// MARK: - ms代理
extension NativeRenderAdViewController: MSNativeSimpleCustomAdViewDelegate {
    func nativeSimpleImageAdViewClosed(adView: MSNativeCustomAdView) { }
    func nativeSimpleVideoAdViewClosed(adView: MSNativeCustomVideoAdView) { }
}

extension NativeRenderAdViewController: MSNativeSimpleCustomVideoAdViewDelegate {
}

// MARK: - 快手代理
#if canImport(KSAdSDK)
extension NativeRenderAdViewController: KSNativeAdDelegate {
    func nativeAdDidLoad(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdDidLoad")
    }
    func nativeAd(_ nativeAd: KSNativeAd, didFailWithError error: Error?) {
        appLog("快手 nativeAd fail:", error ?? "")
    }
    func nativeAdDidBecomeVisible(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdDidBecomeVisible")
    }
    func nativeAdDidClick(_ nativeAd: KSNativeAd, with view: UIView?) {
        appLog("快手 nativeAdDidClick")
    }
    func nativeAdDidShow(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdDidShow")
    }
    func nativeAdDidCloseOtherController(_ nativeAd: KSNativeAd, interactionType: KSAdInteractionType) {
        appLog("快手 nativeAdDidCloseOtherController")
    }
    func nativeAdVideoReady(toPlay nativeAd: KSNativeAd) {
        appLog("快手 nativeAdVideoReadyToPlay")
    }
    func nativeAdVideoStartPlay(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdVideoStartPlay")
    }
    func nativeAdVideoPlayFinished(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdVideoPlayFinished")
    }
    func nativeAdVideoPlayError(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdVideoPlayError")
    }
    func nativeAdVideoPause(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdVideoPause")
    }
    func nativeAdVideoResume(_ nativeAd: KSNativeAd) {
        appLog("快手 nativeAdVideoResume")
    }
}
extension NativeRenderAdViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowData = datas[indexPath.row]

        // 纯文本
        if rowData is String {
            return 44
        }

        // 快手：照 OC demo 固定 256
        if rowData is KSNativeAd {
            return 256
        }

        // ms / 广点通 / 百度 / nativeAdView：按 adView 实际高度 + 上下各 4 inset
        if let adView = rowData as? UIView {
            return max(adView.frame.size.height + 8, 100)
        }

        // 兜底
        return 256
    }
}
#endif
