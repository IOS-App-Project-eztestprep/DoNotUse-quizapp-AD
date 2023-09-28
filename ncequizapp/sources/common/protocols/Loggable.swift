import FirebaseAnalytics
import FirebaseCrashlytics
import Foundation
import SwiftUI

protocol Loggable {
    // Crashlytics
    func setCustomValue(_ value: String, forKey key: String)
    func log(_ message: String, type: LogType, file: String, line: Int)
    func log(_ error: Error, file: String, line: Int)
    func logScreen(_ screen: any View)
    func setUserId(_ id: String)

    // Analytics
    func track(_ event: AnalyticsEvent)
}

// MARK: - Analytics

extension Loggable {
    private func trackEvent(
        _ eventName: String,
        _ parameters: [String: Any]? = nil
    ) {
        #if !targetEnvironment(simulator)
            Analytics.logEvent(eventName, parameters: parameters)
        #endif
        log("Event \(eventName) tracked", type: .analytics)
    }

    private func trackScreen(screen: String) {
        #if !targetEnvironment(simulator)
            Analytics.logEvent(screen, parameters: nil)
        #endif
    }

    func track(_ event: AnalyticsEvent) {
        trackEvent(event.key)
    }
}

// MARK: - Crashlytics

extension Loggable {
    func setCustomValue(_ value: String, forKey key: String) {
        #if !targetEnvironment(simulator)
            Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        #endif
    }

    func log(
        _ message: String,
        type: LogType = .none,
        file: String = #file,
        line: Int = #line
    ) {
        let output = enrichOutput(message, type: type, file: file, line: line)
        printToConsole(output, type: type)
        #if !targetEnvironment(simulator)
            Crashlytics.crashlytics().log(output)
        #endif
    }

    func log(_ error: Error, file: String = #file, line: Int = #line) {
        let output = enrichOutput(
            error.localizedDescription,
            type: .critical,
            file: file,
            line: line
        )
        printToConsole(output, type: .critical)
        #if !targetEnvironment(simulator)
            Crashlytics.crashlytics().record(error: error)
        #endif
    }

    func logScreen(_ screen: any View) {
        log("\(type(of: screen.self))", type: .screen)
    }

    func setUserId(_ id: String) {
        log("User id: \(id)", type: .user)
        #if !targetEnvironment(simulator)
            Crashlytics.crashlytics().setUserID(id)
            Analytics.setUserID(id)
        #endif
    }

    func logRealmPath(_ path: String) {
        printToConsole(enrichOutput(
            path,
            type: .databasePath,
            file: #file,
            line: #line
        ))
    }

    private func enrichOutput(
        _ output: String,
        type: LogType,
        file: String,
        line: Int
    ) -> String {
        var result = output
        if type == .screen {
            result += " appeared."
        } else {
            result =
                "\((file as NSString).lastPathComponent):\(line) -> \(result)"
        }

        return "\(type.rawValue) \(result)"
    }

    private func printToConsole(_ message: String, type _: LogType = .none) {
        print("[Loggable] - \(message)")
    }
}

// MARK: - Enums, helpers

enum LogType: String, CaseIterable {
    case none = "ℹ️"
    case success = "✅"
    case info = "⚠️"
    case databasePath = "💡"
    case critical = "🔴"
    case screen, scene = "📱"
    case analytics = "📣"
    case user = "👨‍💻"
}

enum AnalyticsEvent {
    case none

    var key: String {
        "TBI"
    }
}
