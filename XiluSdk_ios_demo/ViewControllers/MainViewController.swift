//
//  MainViewController.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK
import CoreLocation

class MainViewController: UIViewController {
    private var locationManager: CLLocationManager!
    
    private var tableView: UITableView!
    
    private let menuItems: [(String, () -> UIViewController)] = [
        ("开屏广告", { SplashAdViewController() }),
        ("插屏广告", { InterstitialAdViewController() }),
        ("激励视频广告", { RewardVodAdViewController() }),
        ("信息流模板广告", { NativeTemplateAdViewController() }),
        ("信息流自渲染模板广告", { NativeRenderAdViewController() }),
//        ("信息流模板广告", {
//            let vc = NativeExpressAdViewController()
//            vc.pid = "1077016"
//            return vc
//        }),
//        ("信息流自渲染广告", {
//            let vc = NativeExpressAd2ViewController()
//            vc.pid = "73646b1099911991"
//            return vc
//        }),
        ("Banner广告", { BannerAdViewController() }),
//        ("全屏视频广告", { FullScreenVodAdViewController() }),
//        ("Draw视频信息流", { DrawVodAdViewController() }),
        ("重新初始化(仅在初始化失败时重试使用)", {
            // 初始化SDK，使用测试AppID
            ADXiluSDK.shared.initialize(appId: "4cvmpqr2", debug: true) { success, error in
                DispatchQueue.main.async {
                    if success {
                        print("ADXiluSDK初始化成功，版本: \(ADXiluSDK.shared.getVersion())")
                        XLToastView.show("初始化成功")
                    } else {
                        print("ADXiluSDK初始化失败: \(error ?? "未知错误")")
                        XLToastView.show("初始化失败:\(error ?? "")")
                    }
                }
            }
            return UIViewController()
        }),
        ("获取定位权限", {
            XLToastView.show("请求定位")
            CLLocationManager().requestWhenInUseAuthorization()
            return UIViewController()
        })
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "ADXilu SDK Demo"
        
        // 创建TableView
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        // 设置约束
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].0
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row >= menuItems.count - 2 {
            cell.textLabel?.textColor = .red
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = menuItems[indexPath.row]
        let viewController = item.1()
        
        if indexPath.row >= menuItems.count - 2 {
            return
        }
        viewController.title = item.0
        navigationController?.pushViewController(viewController, animated: true)
    }
}
