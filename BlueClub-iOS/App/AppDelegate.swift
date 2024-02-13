//
//  AppDelegate.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/3/24.
//

import UIKit
import DesignSystem
import KakaoSDKCommon
import FirebaseCore
import FirebaseMessaging
import Utility
import DataSource
import DependencyContainer
import Domain

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var firebaseToken: String?
    private var authApi: AuthNetworkable { Container.live.resolve() }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [.alert, .sound, .badge, .providesAppNotificationSettings],
                completionHandler: { didAllow,Error in }
            )
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        KakaoSDK.initSDK(appKey: PrivateKey.kakao.rawValue)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        guard !isPreview else { return }
        
        Self.firebaseToken = fcmToken
        printLog(message: "FCM Token: \(fcmToken ?? "null")")
        guard let fcmToken else { return }
        Task {
            try await authApi.fcmToken(token: fcmToken)
        }
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .banner, .list, .sound])
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
