//
//  SceneDelegate.swift
//  SwiftDemo
//
//  Created by PublicJoker on 2025/10/16.
//

import UIKit
import ADXiluSDK
import AppTrackingTransparency
import AdSupport

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow? // 窗口实例
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        let rootNavi = UINavigationController(rootViewController: MainViewController())
        rootNavi.navigationBar.tintColor = .mainColor
        window?.rootViewController = rootNavi
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        requestIDFA()
    }
}

@available(iOS 13.0, *)
extension SceneDelegate {
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
}
