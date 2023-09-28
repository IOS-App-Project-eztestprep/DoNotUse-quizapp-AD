import Foundation
import StoreKit
import UIKit

extension UIApplication {
    static var version: String {
        Bundle.main
            .infoDictionary?["CFBundleShortVersionString"] as? String ?? "n/a"
    }

    static var buildNumber: Int {
        guard let buildNumberString = Bundle.main
            .infoDictionary?["CFBundleVersion"] as? String else {
            return -1
        }

        return Int((buildNumberString as NSString).intValue)
    }

    static func requestReview() {
        guard let currentScene = UIApplication.shared.connectedScenes
            .first as? UIWindowScene else {
            print(
                "[Settings] - Unable to get current scene while rating the app!"
            )
            return
        }
        SKStoreReviewController.requestReview(in: currentScene)
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.badge41.rawValue)
    }
}
