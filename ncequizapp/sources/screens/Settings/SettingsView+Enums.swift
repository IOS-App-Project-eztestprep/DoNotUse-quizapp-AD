import Foundation

extension SettingsView {
    enum ActiveBottomSheet: Identifiable {
        case difficulty, dailyGoal, scoreGoal
        var id: Int {
            hashValue
        }
    }

    enum ActiveSafaryView: Identifiable {
        case contactUs, terms, privacy, subscribe, mail
        var id: Int {
            hashValue
        }

        var url: URL {
            switch self {
            case .contactUs:
                return URL(string: "https://www.eztestprep.com/contact-us")!
            case .terms:
                return URL(
                    string: "https://www.eztestprep.com/terms-of-use"
                )!
            case .privacy:
                return URL(
                    string: "https://www.eztestprep.com/privacy-policy"
                )!
            case .subscribe, .mail:
                return URL(string: "https://www.eztestprep.com")!
            }
        }
    }
}
