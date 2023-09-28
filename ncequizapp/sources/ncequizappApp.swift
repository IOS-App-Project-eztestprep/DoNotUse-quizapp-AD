//
//  ncequizappApp.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 31/12/22.
//

import Firebase
import SwiftUI

class AppConstants {
    static let shadowRadius = 6.0
    static let shadowX = 0.0
    static let shadowY = 4.0
    static let cornerRadius = 16.0
}

@main
struct ncequizappApp: App, Loggable {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @SwiftUI.Environment(\.scenePhase)
    var scenePhase

    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .environmentObject(appDelegate)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                log("App became active.", type: .scene)
                
                #if !(DEBUG)
                    Task {
                        await SubscriptionManager.shared.restorePurchase()
                    }
                #endif
                
                NotificationsManager.shared.requestPermission()
                
                // Check if we already have a promotional offer scheduled and the user has completed 5th day
                Task {
                    await MainActor.run {
                        if StorageManager.shared.promotionalOfferScheduled {
                            if Date().localDate > (StorageManager.shared.promotionalOfferScheduledAt?.addDays(days: 1))! {
                                StorageManager.shared.promotionalOfferScheduled = false
                                NotificationsManager.shared.removePendingNotifications(for: .afterFiveDaysToNonSubscribedUsers) {
                                    print("Promotional offer notification removed.")
                                }
                            }
                        } else {
                            if StorageManager.shared.promotionalOfferCheckedOnDate == nil {
                                print("Saving promotional offer checked date")
                                StorageManager.shared.savePromotionalOfferCheckedOnDate(on: Date().localDate)
                            }
                        }
                    }
                }
                
            case .background:
                log("App went to background.", type: .scene)
                NotificationsManager.shared.scheduleLocalNotification(type: .twoDayInactivity)
                NotificationsManager.shared.scheduleLocalNotification(type: .fourDayInactivity)
                
                if SubscriptionManager.shared.hasNeverSubscribed && !StorageManager.shared.promotionalOfferScheduled {
                    NotificationsManager.shared.schedulePromotionalNotification()
                }
            default:
                break
            }
        }
    }

    init() {
        FirebaseApp.configure()
        StorageManager.initialize()
    }    
}

// MARK: - NotificationsDelegate
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, Loggable, ObservableObject {
    @Published
    var openedFromNotification: Bool = false
    
    @Published
    var showBadgeNotification: Bool = false
    
    @Published
    var badgesToShow: Array<BadgeNumber> = Array()
    
    @Published
    var initiateBadgeNotifications: Bool = false
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [
            UIApplication.LaunchOptionsKey: Any
        ]? =
            nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        log("Application did finish launching! 🚀")
        return true
    }
    
    func userNotificationCenter( _: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard let notificationTypeKey = response.notification.request.content.userInfo["notification_type"] as? String,
            let notification = NotificationsManager.NotificationType(rawValue: notificationTypeKey) else {
            return
        }
        log(
            "Received notification of type: \(notification.rawValue)"
        )
                
        switch notification {
        case .afterFiveDaysToNonSubscribedUsers:
            log("Promotional offer tapped!")
            openedFromNotification = true
            break;
            
        case .twoDayInactivity:
            NotificationsManager.shared.removePendingNotifications(for: .twoDayInactivity) {
                print("Two Days notification removed")
            }
            break
            
        case .fourDayInactivity:
            NotificationsManager.shared.removePendingNotifications(for: .twoDayInactivity) {
                print("Four Days notification removed")
            }
            break;
        }
    }
}
