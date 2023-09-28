import Foundation

enum OnboardingLevel: Codable {
    case easy, medium, hard

    var title: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }

    var dataModelId: Int {
        switch self {
        case .easy:
            return 1
        case .medium:
            return 2
        case .hard:
            return 3
        }
    }

    var next: OnboardingLevel {
        switch self {
        case .easy:
            return .medium
        case .medium:
            return .hard
        case .hard:
            return .easy
        }
    }
}

enum OnboardingNumberOfQuestions: Codable {
    case casual, regular, serious, insane

    var numberOfQuestions: Int {
        switch self {
        case .casual:
            return 3
        case .regular:
            return 5
        case .serious:
            return 10
        case .insane:
            return 15
        }
    }

    var title: String {
        switch self {
        case .casual:
            return "Casual"
        case .regular:
            return "Regular"
        case .serious:
            return "Serious"
        case .insane:
            return "Extreme"
        }
    }
}

enum OnboardingScore: Codable {
    case easy, difficult, hard, insane

    var scorePercentage: Int {
        switch self {
        case .easy:
            return 70
        case .difficult:
            return 80
        case .hard:
            return 90
        case .insane:
            return 100
        }
    }

    var title: String {
        switch self {
        case .easy:
            return "Easy"
        case .difficult:
            return "Difficult"
        case .hard:
            return "Hard"
        case .insane:
            return "Extreme"
        }
    }
}

class UserSettings: ObservableObject, Codable {
    @Published
    var level: OnboardingLevel?
    
    @Published
    var numberOfQuestions: OnboardingNumberOfQuestions?
    
    @Published
    var score: OnboardingScore?
    
    @Published
    var readyToAce: Bool = false
    
    @Published
    var isPremium: Bool = false

    @Published
    var isCompleted: Bool = false
    
    @Published
    var onboardingComplete: Bool = false

    public init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level = try container.decodeIfPresent(
            OnboardingLevel.self,
            forKey: .level
        )
        numberOfQuestions = try container.decodeIfPresent(
            OnboardingNumberOfQuestions.self,
            forKey: .numberOfQuestions
        )
        score = try container.decodeIfPresent(
            OnboardingScore.self,
            forKey: .score
        )
        isPremium = try container.decode(Bool.self, forKey: .isPremium)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        onboardingComplete = try container.decode(Bool.self, forKey: .onboardingComplete)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(level, forKey: .level)
        try container.encodeIfPresent(
            numberOfQuestions,
            forKey: .numberOfQuestions
        )
        try container.encodeIfPresent(score, forKey: .score)
        try container.encode(isPremium, forKey: .isPremium)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(onboardingComplete, forKey: .onboardingComplete)
    }

    enum CodingKeys: String, CodingKey {
        case level
        case numberOfQuestions
        case score
        case isPremium
        case isCompleted
        case onboardingComplete
    }

    func checkIfCompleted() {
        guard let _ = level, let _ = numberOfQuestions, let _ = score else {
            isCompleted = false
            return
        }
        isCompleted = true
    }

    func storeToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(
                encoded,
                forKey: UserDefaultsKeys.userSettings.rawValue
            )
        }
    }
}
