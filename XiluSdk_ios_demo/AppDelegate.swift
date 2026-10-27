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
import Photos

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // 初始化ADXiluSDK
        initializeADXiluSDK()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        window?.makeKeyAndVisible()

        requestIDFA()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.requestPhotoLibraryAuthorization()
        }

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

    // 申请相册权限
    private func requestPhotoLibraryAuthorization() {
        if #available(iOS 14.0, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                    DispatchQueue.main.async {
                        self.handlePhotoAuthorization(newStatus)
                    }
                }
            } else {
                handlePhotoAuthorization(status)
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()

            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        self.handlePhotoAuthorization(newStatus)
                    }
                }
            } else {
                handlePhotoAuthorization(status)
            }
        }
    }

    // 处理相册权限结果
    private func handlePhotoAuthorization(_ status: PHAuthorizationStatus) {
        if #available(iOS 14.0, *), status == .limited {
            print("相册权限：有限访问")
            return
        }

        switch status {
        case .authorized:
            print("相册权限：已授权")
        case .denied:
            print("相册权限：已拒绝")
        case .restricted:
            print("相册权限：受限")
        case .notDetermined:
            print("相册权限：未决定")
        default:
            break
        }
    }

    private func initializeADXiluSDK() {
        // 初始化SDK，使用测试AppID
        ADXiluSDKManager.shared.initialize(appId: AppConst.appId, debug: true) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("ADXiluSDK初始化成功，版本: \(ADXiluSDKManager.shared.getVersion())")
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
