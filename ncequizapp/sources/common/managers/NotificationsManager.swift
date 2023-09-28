import Foundation
import UserNotifications

public class NotificationsManager: Loggable {
    private static var _shared: NotificationsManager?

    public static var shared: NotificationsManager {
        guard let shared = _shared else {
            fatalError(
                "NotificationsManager not initialized. Please call NotificationsManager.initialize() on app start to initialize it before using."
            )
        }
        return shared
    }

    public static func initialize() {
        _shared = NotificationsManager()
    }

    private let userNotificationCenter = UNUserNotificationCenter.current()

    public func schedulePromotionalNotification() {
        if !StorageManager.shared.promotionalOfferScheduled {
            scheduleLocalNotification(type: .afterFiveDaysToNonSubscribedUsers)
            log("Promotional notification scheduled! 📣")
            StorageManager.shared.savePromotionalOfferScheduled(true, on: Date().localDate.addDays(days: 5))
        }
    }
    
    public func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [
                .alert,
                .badge,
                .sound
            ]) { success, error in
                StorageManager.shared.saveNotificationsFlag(enabled: success)
                self.log("User notification permission \(success ? "granted! ✅" : "denied ⛔️")")
            }
    }

    public func scheduleLocalNotification(type: NotificationType) {
        if StorageManager.shared.notificationsEnabled {
            removePendingNotifications(for: type) { [weak self] in
                self?.userNotificationCenter.add(type.request)
            }

        } else {
            userNotificationCenter.removeAllPendingNotificationRequests()
        }
    }

    public func removePendingNotifications(
        for type: NotificationType,
        completion: @escaping () -> Void
    ) {
        userNotificationCenter
            .getPendingNotificationRequests { [weak self] requests in
                let identifiers = requests
                    .filter {
                        $0.content
                            .userInfo["notification_type"] as? String ?? "" ==
                            type
                            .rawValue
                    }.map { $0.identifier }
                
                self?.userNotificationCenter
                    .removePendingNotificationRequests(
                        withIdentifiers: identifiers
                    )
                self?.log(
                    "Removed \(identifiers.count) pending notifications requests of type \(type.rawValue)",
                    type: .success
                )
                completion()
            }
    }
}

extension NotificationsManager {
    public enum NotificationType: String {
        
        case twoDayInactivity
        case fourDayInactivity
        case afterFiveDaysToNonSubscribedUsers
        
        var content: UNMutableNotificationContent {
            let content = UNMutableNotificationContent()
            content.sound = .default
            content.userInfo = ["notification_type": rawValue]
            switch self {
            case .twoDayInactivity, .fourDayInactivity:
                content.title = "Time to study 🤓"
                content.subtitle = "Short daily sessions improve retention!"
                
            case .afterFiveDaysToNonSubscribedUsers:
                content.title = "Limited time offer!"
                content.subtitle = "Take 50% off your first month! 💸"
            }
            return content
        }

        var trigger: UNCalendarNotificationTrigger {
            switch self {
            case .twoDayInactivity:
                return UNCalendarNotificationTrigger(
                    dateMatching: Date().addDays(days: 2).getDateComponents(),
                    repeats: false
                )
            case .fourDayInactivity:
                return UNCalendarNotificationTrigger(
                    dateMatching: Date().addDays(days: 4).getDateComponents(),
                    repeats: false
                )
                
            case .afterFiveDaysToNonSubscribedUsers:
                return UNCalendarNotificationTrigger(
                    dateMatching: Date().addDays(days: 5).getDateComponents(),
                    repeats: false
                )
            }
        }
        
        var request: UNNotificationRequest {
            UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )
        }
    }
}

fileprivate extension DateComponents {
    var dateFromComponents: Date? {
        Calendar.current.date(from: self)
    }
}
