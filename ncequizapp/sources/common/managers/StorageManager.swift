import Foundation
import RealmSwift
import SwiftUI

class StorageManager: ObservableObject, Loggable {
    private let databaseSchemaVersion: UInt64 = 4
    private let questionSourceVersion: Int = 21

    private let userDefaults = UserDefaults.standard
    private(set) var realm: Realm?

    // MARK: - Singleton

    private static var _shared: StorageManager?

    public static var shared: StorageManager {
        guard let shared = _shared else {
            fatalError(
                "StorageManager not initialized. Please call StorageManager.initialize() on app start to initialize it before using."
            )
        }
        
        return shared
    }

    public static func initialize() {
        NotificationsManager.initialize()
        _shared = StorageManager()
    }

    init() {
        SubscriptionManager.initialize()
        openRealm()
        updateDatasourceIfNeeded()
        publishData()
    }

    // variables
    @ObservedResults(QuestionModel.self)
    var allQuestions

    // userDefaults variables
    @Published
    private(set) var dailyStreak: Int = 0
    @Published
    private(set) var actualScore: Int = 0
    @Published
    private(set) var quizzesCompleted: Int = 0
    @Published
    private(set) var dailyQuizAvailable: Bool = true
    @Published
    private(set) var longestStreak: Int = 0
    @Published
    private(set) var subscriberId: String = ""
    // quizCounters
    @Published
    private(set) var dailyQuizzesCompleted: Int = 0
    @Published
    private(set) var randomQuizzesCompleted: Int = 0
    @Published
    private(set) var timedQuizzesCompleted: Int = 0

    @Published
    private(set) public var notificationsEnabled: Bool = false
    @Published
    private(set) public var promotionalOfferCheckedOnDate: Date? = nil
    @Published
    public var promotionalOfferScheduled: Bool = false
    @Published
    private(set) public var promotionalOfferScheduledAt: Date? = nil
    @Published
    private(set) public var promotionalOfferShown: Bool = false
    @Published
    public var presentSubscriptionScreen: Bool = false
    
    @Published
    var badgesUnlocked: Int = 0
    
    @Published
    var answeredQuestions: Int = 0
    @Published
    var correctAnswered: Int = 0
    
    @ObservedObject
    var userSettings = UserSettings()

    var freeLimitReached: Bool {
        allQuestions.filter { $0.answered }.count >= 40
    }

    private func openRealm() {
        do {
            let configuration = Realm.Configuration(
                schemaVersion: databaseSchemaVersion,
                migrationBlock: { _, oldSchemaVersion in
                    if oldSchemaVersion > self.databaseSchemaVersion {
                        // Migrate if needed
                    }
                }
            )

            realm = try Realm(configuration: configuration)
//            logRealmPath(
//                "Realm path: \(configuration.fileURL?.absoluteString ?? "n/a")"
//            )
        } catch {
//            log(error)
        }
    }

    private func updateDatasourceIfNeeded() {
        guard let url = Bundle.main.url(
            forResource: "datasource",
            withExtension: "json"
        ), let data = try? Data(contentsOf: url),
        let decodedData = try? JSONDecoder().decode(QuestionDatasource.self, from: data),
        userDefaults.integer(forKey: UserDefaultsKeys.questionSourceVersion.rawValue) <
        questionSourceVersion else {
            return
        }
//        log("Updating datasources...")
        // try? wipeDatabase()
        decodedData.quizQuestions.forEach { question in
            let questionModel = QuestionModel()
            questionModel.id = question.id
            questionModel.content = question.content
            questionModel.difficulty = question.difficulty
            questionModel.category = question.category
            questionModel.answers
                .append(
                    objectsIn: question.answers
                        .compactMap { AnswerModel(answer: $0) }
                )
            if let existingQuestion = allQuestions
                .first(where: { $0.id == question.id }) {
                questionModel.bookmarked = existingQuestion.bookmarked
                questionModel.bookmarketAt = existingQuestion.bookmarketAt
                questionModel.answeredAt = existingQuestion.answeredAt
                questionModel.choosenAnswer = questionModel.answers
                    .first(where: {
                        $0.correct == existingQuestion.choosenAnswer?.correct
                    })
            }

            try? add(questionModel, updatePolicy: .all)
        }
        log("Datasources updated successfully!", type: .success)
        userDefaults.set(
            questionSourceVersion,
            forKey: UserDefaultsKeys.questionSourceVersion.rawValue
        )
    }

    func add(_ object: Object, updatePolicy: Realm.UpdatePolicy = .all) throws {
        guard let realm = realm else {
            throw NSError()
        }
        try realm.write {
            realm.add(object, update: updatePolicy)
        }
    }

    func wipeDatabase() throws {
        guard let realm = realm else {
            throw NSError()
        }
        try realm.write {
            realm.deleteAll()
        }
        log("Database wiped clean!", type: .info)
    }

    func publishData() {
        // Check daily streak
        if let data = userDefaults.object(forKey: UserDefaultsKeys.userSettings.rawValue) as? Data,
            let userSettings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            self.userSettings.score = userSettings.score
            self.userSettings.numberOfQuestions = userSettings.numberOfQuestions
            self.userSettings.level = userSettings.level
            self.userSettings.isCompleted = userSettings.isCompleted
        }
        
        if let date = userDefaults.object(forKey: UserDefaultsKeys.dailyStreakDate.rawValue) as? Date {
            if date.daysBetween(date: Date().localDate) > 1 {
                userDefaults.set(0, forKey: UserDefaultsKeys.dailyStreak.rawValue)
            }
        }
        
        if let date = userDefaults.object(forKey: UserDefaultsKeys.dailyStreakDate.rawValue) as? Date {
            if date.isPastMidnight() {
                dailyQuizAvailable = true
            } else {
                dailyQuizAvailable = false
            }
        } else {
            dailyQuizAvailable = true
        }
        
        dailyStreak = userDefaults.integer(forKey: UserDefaultsKeys.dailyStreak.rawValue)

        // Check score
        answeredQuestions = allQuestions.filter { $0.choosenAnswer != nil }.count
        correctAnswered = allQuestions.filter { $0.choosenAnswer?.correct ?? false }.count
        let score = answeredQuestions != 0 ?
            Int((Float(correctAnswered) / Float(answeredQuestions) * 100).rounded()) : 0
        badgesUnlocked = userDefaults.integer(forKey: UserDefaultsKeys.badgesUnlocked.rawValue)
        
        updateScore(score)
        updateBadgesAndTheirCount()
        
        
        // Check quizzessCompleted
        quizzesCompleted = userDefaults.integer(forKey: UserDefaultsKeys.completedQuizzes.rawValue)
        dailyQuizzesCompleted = userDefaults.integer(forKey: UserDefaultsKeys.completedDailyQuizzes.rawValue)
        randomQuizzesCompleted = userDefaults.integer(forKey: UserDefaultsKeys.completedRandomQuizzes.rawValue)
        timedQuizzesCompleted = userDefaults.integer(forKey: UserDefaultsKeys.completedTimedQuizzes.rawValue)
        longestStreak = userDefaults.integer(forKey: UserDefaultsKeys.longestStreak.rawValue)
        

        // Check subscriberId
        if let subscriberId = userDefaults.string(forKey: UserDefaultsKeys.subscriberId.rawValue) {
            self.subscriberId = subscriberId
        }

        notificationsEnabled = userDefaults.bool(forKey: UserDefaultsKeys.notificationsEnabled.rawValue)
        promotionalOfferScheduled = userDefaults.bool(forKey: UserDefaultsKeys.promotionalOfferScheduled.rawValue)
        
        // Check promotional first checked date
        if let _promotionalOfferCheckedOnDate = userDefaults.object(forKey:
        UserDefaultsKeys.promotionalOfferCheckedOnDate.rawValue) as? Date {
            self.promotionalOfferCheckedOnDate = _promotionalOfferCheckedOnDate
        }
        
        // Check promotional offer scheduled date permission
        if let _promotionalOfferScheduledDate = userDefaults.object(forKey:
        UserDefaultsKeys.promotionalOfferScheduledDate.rawValue) as? Date {
            self.promotionalOfferScheduledAt = _promotionalOfferScheduledDate
        }
        
        // Check subscription permission
        if let expirationDate = userDefaults.object(forKey:
        UserDefaultsKeys.subscriptionExpirationDate.rawValue) as? Date {
            SubscriptionManager.shared.isSubscribed = expirationDate > Date()
        }
    }

    // MARK: - UserDefaults updates

    public func incrementDailyStreakIfNeeded() {
        dailyStreak = dailyStreak + 1
        userDefaults.set(dailyStreak, forKey: UserDefaultsKeys.dailyStreak.rawValue)
        
        if userDefaults.integer(forKey: UserDefaultsKeys.longestStreak.rawValue) < userDefaults.integer(forKey: UserDefaultsKeys.dailyStreak.rawValue) {
            userDefaults.set(dailyStreak, forKey: UserDefaultsKeys.longestStreak.rawValue)
            longestStreak = dailyStreak
        }
        
        //========================
        userDefaults.set(Date().localDate, forKey: UserDefaultsKeys.dailyStreakDate.rawValue)
        dailyQuizAvailable = false
        if dailyStreak == 3 {
            DispatchQueue.main.async {
                UIApplication.requestReview()
                self.log("Review requested!")
            }
        }
    }
    
    public func updateBadgesAndTheirCount() {
        // Populate the badges
        // ====================
        // Daily Streak
        userDefaults.setValue((dailyStreak >= 2), forKey: UserDefaultsKeys.badge1.rawValue)
        userDefaults.setValue((dailyStreak >= 3), forKey: UserDefaultsKeys.badge2.rawValue)
        userDefaults.setValue((dailyStreak >= 5), forKey: UserDefaultsKeys.badge3.rawValue)
        userDefaults.setValue((dailyStreak >= 10), forKey: UserDefaultsKeys.badge4.rawValue)
        userDefaults.setValue((dailyStreak >= 20), forKey: UserDefaultsKeys.badge5.rawValue)
        userDefaults.setValue((dailyStreak >= 30), forKey: UserDefaultsKeys.badge6.rawValue)
        
        // Daily Quiz
        userDefaults.setValue((dailyQuizzesCompleted >= 1), forKey: UserDefaultsKeys.badge7.rawValue)
        userDefaults.setValue((dailyQuizzesCompleted >= 2), forKey: UserDefaultsKeys.badge8.rawValue)
        userDefaults.setValue((dailyQuizzesCompleted >= 5), forKey: UserDefaultsKeys.badge9.rawValue)
        userDefaults.setValue((dailyQuizzesCompleted >= 10), forKey: UserDefaultsKeys.badge10.rawValue)
        userDefaults.setValue((dailyQuizzesCompleted >= 20), forKey: UserDefaultsKeys.badge11.rawValue)
        userDefaults.setValue((dailyQuizzesCompleted >= 30), forKey: UserDefaultsKeys.badge12.rawValue)
        userDefaults.setValue((dailyQuizzesCompleted >= 50), forKey: UserDefaultsKeys.badge13.rawValue)
        
        // Questions
        userDefaults.setValue((answeredQuestions >= 20), forKey: UserDefaultsKeys.badge14.rawValue)
        userDefaults.setValue((answeredQuestions >= 50), forKey: UserDefaultsKeys.badge15.rawValue)
        userDefaults.setValue((answeredQuestions >= 100), forKey: UserDefaultsKeys.badge16.rawValue)
        userDefaults.setValue((answeredQuestions >= 250), forKey: UserDefaultsKeys.badge17.rawValue)
        userDefaults.setValue((answeredQuestions >= 500), forKey: UserDefaultsKeys.badge18.rawValue)
        userDefaults.setValue((answeredQuestions >= 750), forKey: UserDefaultsKeys.badge19.rawValue)
        userDefaults.setValue((answeredQuestions >= 1000), forKey: UserDefaultsKeys.badge20.rawValue)
        
        // Score of 100%
        let timesScored100Percent = UserDefaults.standard.integer(forKey: UserDefaultsKeys.scored100Percent.rawValue)
        userDefaults.setValue((timesScored100Percent >= 1), forKey: UserDefaultsKeys.badge21.rawValue)
        userDefaults.setValue((timesScored100Percent >= 3), forKey: UserDefaultsKeys.badge22.rawValue)
        userDefaults.setValue((timesScored100Percent >= 10), forKey: UserDefaultsKeys.badge23.rawValue)
        userDefaults.setValue((timesScored100Percent >= 20), forKey: UserDefaultsKeys.badge24.rawValue)
        
        // Minutes Spent
        let totalSecondsSpent: Int = userDefaults.object(forKey: UserDefaultsKeys.totalTimeQuiz.rawValue) as? Int ?? 0
        
        userDefaults.setValue((totalSecondsSpent / 60) >= 30, forKey: UserDefaultsKeys.badge25.rawValue)
        userDefaults.setValue((totalSecondsSpent / 60) >= 60, forKey: UserDefaultsKeys.badge26.rawValue)
        userDefaults.setValue((totalSecondsSpent / 60) >= 120, forKey: UserDefaultsKeys.badge27.rawValue)
        userDefaults.setValue((totalSecondsSpent / 60) >= 300, forKey: UserDefaultsKeys.badge28.rawValue)

        // Bookmarks
        let totalBookmarks = allQuestions.filter { $0.bookmarked }.count
        userDefaults.setValue((totalBookmarks >= 3), forKey: UserDefaultsKeys.badge29.rawValue)
        userDefaults.setValue((totalBookmarks >= 10), forKey: UserDefaultsKeys.badge30.rawValue)
        userDefaults.setValue((totalBookmarks >= 20), forKey: UserDefaultsKeys.badge31.rawValue)
        
        // Badges
        userDefaults.setValue((badgesUnlocked >= 5), forKey: UserDefaultsKeys.badge34.rawValue)
        userDefaults.setValue((badgesUnlocked >= 10), forKey: UserDefaultsKeys.badge35.rawValue)
        userDefaults.setValue((badgesUnlocked >= 20), forKey: UserDefaultsKeys.badge36.rawValue)
        
        // Update Badge Count
        var unlockedBadges = 0
        
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge1.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge2.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge3.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge4.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge5.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge6.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge7.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge8.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge9.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge10.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge11.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge12.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge13.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge14.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge15.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge16.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge17.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge18.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge19.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge20.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge21.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge22.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge23.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge24.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge25.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge26.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge27.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge28.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge29.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge30.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge31.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge32.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge33.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge34.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge35.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge36.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge37.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge38.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge39.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge40.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge41.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        unlockedBadges = (userDefaults.bool(forKey: UserDefaultsKeys.badge42.rawValue)) ? unlockedBadges + 1 : unlockedBadges
        
        userDefaults.setValue(unlockedBadges, forKey: UserDefaultsKeys.badgesUnlocked.rawValue)
        badgesUnlocked = unlockedBadges
    }

    public func updateGoalScore(_ score: OnboardingScore) {
        userSettings.score = score
        userSettings.storeToUserDefaults()
        log("Goal score updated to: \(score.scorePercentage)%")
    }

    public func updateLevel(_ level: OnboardingLevel) {
        userSettings.level = level
        userSettings.storeToUserDefaults()
        log("Level updated to: \(level.title)")
    }

    public func updateNumberOfQuestions(_ number: OnboardingNumberOfQuestions) {
        userSettings.numberOfQuestions = number
        userSettings.storeToUserDefaults()
        log("Number of daily questions updated to: \(number.numberOfQuestions)")
    }

    public func updateScore(_ number: Int) {
        userDefaults.set(number, forKey: UserDefaultsKeys.actualScore.rawValue)
        actualScore = number
    }

    public func incrementQuizComplete(quizType: QuizType) {
        userDefaults.set(
            quizzesCompleted + 1,
            forKey: UserDefaultsKeys.completedQuizzes.rawValue
        )
        quizzesCompleted = userDefaults
            .integer(forKey: UserDefaultsKeys.completedQuizzes.rawValue)

        switch quizType {
        case .daily:
            userDefaults.set(
                dailyQuizzesCompleted + 1,
                forKey: UserDefaultsKeys.completedDailyQuizzes.rawValue
            )
            dailyQuizzesCompleted = userDefaults
                .integer(
                    forKey: UserDefaultsKeys.completedDailyQuizzes
                        .rawValue
                )
        case .random:
            userDefaults.set(
                randomQuizzesCompleted + 1,
                forKey: UserDefaultsKeys.completedRandomQuizzes.rawValue
            )
            randomQuizzesCompleted = userDefaults
                .integer(
                    forKey: UserDefaultsKeys.completedRandomQuizzes
                        .rawValue
                )
        case .timed:
            userDefaults.set(
                timedQuizzesCompleted + 1,
                forKey: UserDefaultsKeys.completedTimedQuizzes.rawValue
            )
            timedQuizzesCompleted = userDefaults
                .integer(
                    forKey: UserDefaultsKeys.completedTimedQuizzes
                        .rawValue
                )
        default: break
        }
    }

    public func resetProgress() {
        userDefaults.set(0, forKey: UserDefaultsKeys.completedQuizzes.rawValue)
        userDefaults.set(
            0,
            forKey: UserDefaultsKeys.completedDailyQuizzes.rawValue
        )
        userDefaults.set(
            0,
            forKey: UserDefaultsKeys.completedTimedQuizzes.rawValue
        )
        userDefaults.set(
            0,
            forKey: UserDefaultsKeys.completedRandomQuizzes.rawValue
        )
        userDefaults.set(0, forKey: UserDefaultsKeys.dailyStreak.rawValue)
        userDefaults.set(0, forKey: UserDefaultsKeys.longestStreak.rawValue)
        userDefaults.set(0, forKey: UserDefaultsKeys.actualScore.rawValue)
        userDefaults
            .removeObject(forKey: UserDefaultsKeys.dailyStreakDate.rawValue)

        quizzesCompleted = 0
        dailyQuizzesCompleted = 0
        timedQuizzesCompleted = 0
        randomQuizzesCompleted = 0
        dailyStreak = 0
        longestStreak = 0
        actualScore = 0
        dailyQuizAvailable = true
        guard let realm = realm else {
            return
        }
        let questions = realm.objects(QuestionModel.self)
        for question in questions {
            try! realm.write {
                question.choosenAnswer = nil
                question.bookmarked = false
                question.bookmarketAt = nil
                question.answeredAt = nil
            }
        }
        log("Progress reset.", type: .success)
    }

    public func saveUserSettings(_ userSettings: UserSettings) {
        userSettings.storeToUserDefaults()
        self.userSettings.level = userSettings.level
        self.userSettings.numberOfQuestions = userSettings.numberOfQuestions
        self.userSettings.score = userSettings.score
        self.userSettings.isCompleted = userSettings.isCompleted
    }

    public func saveSubscriberId(_ subscriberId: String) {
        userDefaults.set(
            subscriberId,
            forKey: UserDefaultsKeys.subscriberId.rawValue
        )
        self.subscriberId = subscriberId
        setUserId(subscriberId)
    }

    public func saveSubscriptionExpirationDate(_ date: Date) {
        userDefaults.set(
            date,
            forKey: UserDefaultsKeys.subscriptionExpirationDate.rawValue
        )
    }
        
    public func saveNotificationsFlag(enabled: Bool) {
        userDefaults.set(
            enabled,
            forKey: UserDefaultsKeys.notificationsEnabled.rawValue
        )
        Task {
            await MainActor.run {
                notificationsEnabled = enabled
            }
        }
    }
    
    public func savePromotionalOfferScheduled(_ scheduled: Bool, on date: Date?) {
        userDefaults.set(
            scheduled,
            forKey: UserDefaultsKeys.promotionalOfferScheduled.rawValue
        )
        userDefaults.set(
            date,
            forKey: UserDefaultsKeys.promotionalOfferScheduledDate.rawValue
        )
        Task {
            await MainActor.run {
                promotionalOfferScheduled = scheduled
                promotionalOfferScheduledAt = date
            }
        }
    }
    
    public func savePromotionalOfferCheckedOnDate(on date: Date?) {
        userDefaults.set(
            date,
            forKey: UserDefaultsKeys.promotionalOfferCheckedOnDate.rawValue
        )
        Task {
            await MainActor.run {
                promotionalOfferCheckedOnDate = date
            }
        }
    }
    
    public func shouldShowPromotionalOffer() -> Bool {
        if let _promotionalOfferCheckedOnDate = StorageManager.shared.promotionalOfferCheckedOnDate {
            let now = Date().localDate
            if(now > _promotionalOfferCheckedOnDate.addDays(days: 5)
               && now < _promotionalOfferCheckedOnDate.addDays(days: 6)) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK: - Realm updates

    public func updateChoosenAnswer(
        _ answer: AnswerModel,
        onQuestion question: QuestionModel?
    ) throws {
        guard let realm = realm,
              let question = question else {
            throw NSError()
        }
        try realm.write {
            question.choosenAnswer = answer.thaw()
            question.answeredAt = Date()
        }
    }

    public func bookmarkQuestion(_ question: QuestionModel?) throws {
        guard let realm = realm,
              let question = question else {
            throw NSError()
        }
        try realm.write {
            question.bookmarked.toggle()
            question.bookmarketAt = question.bookmarked ? Date() : nil
        }
        log("Question \(question.bookmarked ? "bookmarked." : "unbookmarked.")")
    }

    public func getQuestion(_ question: QuestionModel?) -> QuestionModel? {
        guard let realm = realm, let question = question else {
            return nil
        }
        return realm.object(
            ofType: QuestionModel.self,
            forPrimaryKey: question.id
        )
    }
}

struct StoreManager_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
