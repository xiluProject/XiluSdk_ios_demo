//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by Xilu on 2025/1/27.
//

import UIKit
import ADXiluSDK
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 初始化ADXiluSDK
        initializeADXiluSDK()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()
        requestIDFA()
        return true
    }

    // 请求idfa，此方法在iOS15上需要放到applicationDidBecomeActive内执行
    // 可能会被其他询问覆盖
    func requestIDFA() {
        if #available(iOS 14, *) {
            // 授权完成回调，block可能不在主线程，如果在此请求广告请先调用回到主线程
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    sdkDebug("idfa", UIDevice.idfa)
                    break
                case .denied:
                    break
                case .notDetermined:
                    break
                case .restricted:
                    break
                @unknown default:
                    break
                }
            }
        } else {
            // iOS 14 以下无需授权，直接获取
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("IDFA: \(idfa)")
        }
    }

    private func initializeADXiluSDK() {
        // 初始化SDK，使用测试AppID
        ADXiluSDK.shared.initialize(appId: "4cvmpqr2", debug: true) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("ADXiluSDK初始化成功，版本: \(ADXiluSDK.shared.getVersion())")
                    
                } else {
                    print("ADXiluSDK初始化失败: \(error ?? "未知错误")")
                }
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        requestIDFA()
    }
}
