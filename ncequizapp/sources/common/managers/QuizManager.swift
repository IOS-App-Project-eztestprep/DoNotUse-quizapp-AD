import Foundation
import RealmSwift
import SwiftUI

class QuizManager: ObservableObject, Loggable {
    private let quizDuration = 1800
    private let userDefaults = UserDefaults.standard
    // Variables to set questions and length of questions
    @Published
    private(set) var questions: [QuestionModel] = []
    @Published
    private(set) var length = 0

    // Variables to set question and answers
    @Published
    private(set) var index = 0
    @Published
    private(set) var question: AttributedString = .init("")
    @Published
    private(set) var explanation: AttributedString?
    @Published
    private(set) var answerChoices: [AnswerModel] = []

    // Variables for score and progress
    @Published
    private(set) var score = 0
    @Published
    private(set) var progress: CGFloat = 0

    // Variables to know if an answer has been selected and reached the end of
    // quiz
    @Published
    var answerSelected = false
    
    @Published
    private(set) var reachedEnd = false {
        didSet {
            if reachedEnd {
                let answeredQuestions = StorageManager.shared.allQuestions
                    .filter { $0.choosenAnswer != nil }.count
                let correctAnswered = StorageManager.shared.allQuestions
                    .filter { $0.choosenAnswer?.correct ?? false }.count
                let score = answeredQuestions != 0 ?
                    Int(
                        Float(correctAnswered) / Float(answeredQuestions) *
                            100
                    ) : 0
                StorageManager.shared.updateScore(score)
                log("Quiz finished with score: \(finalScorePercentage)")
            }
        }
    }

    @Published
    private(set) var previousQuestionAvailable = false
    @Published
    private(set) var currentAnswer: AnswerModel?
    @ObservedRealmObject
    private(set) var currentQuestion: QuestionModel =
        .init()
    @Published
    private(set) var currentQuestionBookmarked = false
    @Published
    private(set) var isCategoryQuiz: Bool = false
    @Published
    private(set) var quizType: QuizType = .daily
    @Published
    private(set) var categoryType: CategoryType = .professional

    @Published
    private(set) var learnMode: Bool = true

    @Published
    var timeRemaining = 0
    @Published
    var totalTimeSpent = 0
    @Published
    var timer: Timer?

    var finalScorePercentage: Int {
        let score = length != 0 ?
            Int((Float(score) / Float(length) * 100).rounded()) : 0
        return score
    }

    var isLastQuestions: Bool {
        index + 1 == length
    }

    func fetchNewQuestions(forQuizType quizType: QuizType = .daily) async {
        self.isCategoryQuiz = false
        self.quizType = quizType
        DispatchQueue.main.async {
            self.index = 0
            self.score = 0
            self.progress = 0
            self.reachedEnd = false

            switch quizType {
            case .bookmarked:
                self.questions =
                    StorageManager.shared.allQuestions.filter { $0.bookmarked }
                        .sorted(by: { $0.bookmarkedDate > $1.bookmarkedDate })
            case .daily:
                self
                    .fillQuestionsAlgorithm(
                        numberOfQuestions: StorageManager
                            .shared.userSettings.numberOfQuestions?
                            .numberOfQuestions ?? 20
                    )
            case .random:
                self.fillQuestionsAlgorithm(numberOfQuestions: 10)
            case .timed:
                self.fillQuestionsAlgorithm(numberOfQuestions: 40)
            case .missed:
                self.questions = StorageManager.shared.allQuestions
                    .filter { question in
                        guard let choosenAnswer = question.choosenAnswer
                        else {
                            return false
                        }
                        return !choosenAnswer.correct
                    }.sorted(by: { $0.answeredDate > $1.answeredDate })
            case .correct:
                self.questions = StorageManager.shared.allQuestions
                    .filter { question in
                        guard let choosenAnswer = question.choosenAnswer
                        else {
                            return false
                        }
                        return choosenAnswer.correct
                    }.sorted(by: { $0.answeredDate > $1.answeredDate })
                // TODO: - remove that when having final datasource
//            case .timed:
//                self.questions = Array(StorageManager.shared.allQuestions)
            case .category:
                print("Called Category")
            }
            self.length = self.questions.count

            if !self.questions.isEmpty {
                self.setNextQuestion()
            }
        }
    }

    func fetchNewCategoryQuestions(forCategoryType categoryType: CategoryType) async {
        self.isCategoryQuiz = true
        self.categoryType = categoryType
        DispatchQueue.main.async {
            self.index = 0
            self.score = 0
            self.progress = 0
            self.reachedEnd = false

            switch categoryType {
            case .humanGrowth:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 1)
                break;
            case .socialCultural:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 2)
                break;
            case .helping:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 3)
                break;
            case .groupWork:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 4)
                break;
            case .career:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 5)
                break;
            case .assessment:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 6)
                break;
            case .research:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 7)
                break;
            case .professional:
                self.fillQuestionsAlgorithmForCategory(numberOfQuestions: 10, categoryId: 8)
                break;
            }
        
            self.length = self.questions.count
            if !self.questions.isEmpty {
                self.setNextQuestion()
            }
        }
    }
    
    func startQuiz(learnMode: Bool) {
        self.learnMode = learnMode
        let duration = quizType == .timed ? 1800 : 600
        if !learnMode {
            timeRemaining = duration
            timer?.invalidate()
            timer = nil
            timer = Timer
                .scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                        self.totalTimeSpent = (self.userDefaults.value(forKey: UserDefaultsKeys.totalTimeQuiz.rawValue) as? Int ?? 0) + 1
                        self.userDefaults.set(self.totalTimeSpent, forKey: UserDefaultsKeys.totalTimeQuiz.rawValue)
                    } else {
                        self.reachedEnd = true
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                }
        }
    }
    
    func startCategoryQuiz(learnMode: Bool) {
        self.learnMode = learnMode
        let duration = quizType == .timed ? 1800 : 600

        if !learnMode {
            timeRemaining = duration
            timer?.invalidate()
            timer = nil
            timer = Timer
                .scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                        self.totalTimeSpent = (self.userDefaults.value(forKey: UserDefaultsKeys.totalTimeQuiz.rawValue) as? Int ?? 0) + 1
                        self.userDefaults.set(self.totalTimeSpent, forKey: UserDefaultsKeys.totalTimeQuiz.rawValue)
                    } else {
                        self.reachedEnd = true
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                }
        }
    }

    func goToNextQuestion() {
        if index + 1 < length {
            index += 1
            setNextQuestion()
            previousQuestionAvailable = true
            log("Next question with id \(currentQuestion.id) tapped.")
        } else {
            StorageManager.shared.incrementQuizComplete(quizType: quizType)
            if quizType == .daily && !isCategoryQuiz {
                StorageManager.shared.incrementDailyStreakIfNeeded()
            }
            reachedEnd = true
            timer?.invalidate()
            timer = nil
        }
    }

    func setNextQuestion() {
        progress = CGFloat(Double(index + 1) / Double(length) * UIScreen.screenWidth)
        currentQuestion = questions[index]
        previousQuestionAvailable = index != 0
        if index < length {
            let currentQuestion = questions[index]
            question = currentQuestion.content.attributedQuestion
            answerChoices = Array(currentQuestion.answers)
            currentQuestionBookmarked = currentQuestion.bookmarked
            currentAnswer = questions[index].quizAnswer
            answerSelected = currentAnswer != nil
            explanation = answerChoices.first(where: { $0.correct })?
                .explanation?.attributedExplanation
        }
    }

    func goToPreviousQuestion() {
        if index > 0 {
            index -= 1
            setPreviousQuestion()
            log("Previous question with id: \(currentQuestion.id) tapped")
        }
        previousQuestionAvailable = index != 0
    }

    func setPreviousQuestion() {
        progress = CGFloat(
            Double(index + 1) / Double(length) * UIScreen
                .screenWidth
        )
        currentQuestion = questions[index]
        question = currentQuestion.content.attributedQuestion
        answerChoices = Array(currentQuestion.answers)
        currentAnswer = questions[index].quizAnswer
        currentQuestionBookmarked = currentQuestion.bookmarked
        answerSelected = true
        explanation = answerChoices.first(where: { $0.correct })?.explanation?
            .attributedExplanation
    }

    func selectAnswer(answer: AnswerModel) {
        questions[index].quizAnswer = answer
        currentAnswer = questions[index].quizAnswer
        answerSelected = true
        do {
            try StorageManager.shared.updateChoosenAnswer(
                answer,
                onQuestion: currentQuestion.thaw()
            )
        } catch {
            log(error)
        }
        if answer.correct {
            score += 1
        }
        StorageManager.shared.publishData()
    }

    func bookmarkCurrentQuestion() {
        do {
            try StorageManager.shared.bookmarkQuestion(currentQuestion.thaw())
            currentQuestionBookmarked = currentQuestion.bookmarked
            StorageManager.shared.publishData()
        } catch {
            log(error)
        }
    }

    private func fillQuestionsAlgorithm(numberOfQuestions: Int) {
        var questions = [QuestionModel]()
        var numberOfQuestions = numberOfQuestions
        var difficulty = StorageManager.shared.userSettings.level ?? .easy
        while numberOfQuestions > 0 {
            if StorageManager.shared.allQuestions.allSatisfy({ $0.answered }),
               let question = StorageManager.shared.allQuestions.shuffled()
               .first(where: { !questions.contains($0) }) {
                questions.append(question)
                numberOfQuestions -= 1
            } else {
                if let question = StorageManager.shared.allQuestions.shuffled()
                    .first(where: {
                        !$0.answered && $0.difficulty == difficulty
                            .dataModelId && !questions.contains($0)
                    }) {
                    questions.append(question)
                    numberOfQuestions -= 1
                } else if let question = StorageManager.shared.allQuestions
                    .shuffled()
                    .first(where: {
                        !$0.answered && $0.difficulty == difficulty.next
                            .dataModelId && !questions.contains($0)
                    }) {
                    questions.append(question)
                    numberOfQuestions -= 1
                } else {
                    if StorageManager.shared.allQuestions
                        .contains(where: {
                            !$0
                                .answered &&
                                (
                                    $0.difficulty == difficulty.next
                                        .dataModelId || $0
                                        .difficulty == difficulty.next.next
                                        .dataModelId
                                )
                        }) {
                        difficulty = difficulty.next
                    } else {
                        if let question = StorageManager.shared.allQuestions
                            .shuffled()
                            .first(where: { !questions.contains($0) }) {
                            questions.append(question)
                            numberOfQuestions -= 1
                        }
                    }
                }
            }
        }
        self.questions = questions
    }
        
    private func fillQuestionsAlgorithmForCategory(numberOfQuestions: Int, categoryId: Int) {
        var questions = [QuestionModel]()
        var numberOfQuestions = numberOfQuestions
        var difficulty = StorageManager.shared.userSettings.level ?? .easy
        
        while numberOfQuestions > 0 {
            if StorageManager.shared.allQuestions.allSatisfy({ $0.category == categoryId && $0.answered }),
                let question = StorageManager.shared.allQuestions.shuffled().first(where: { $0.category == categoryId && !questions.contains($0) }){
                questions.append(question)
                numberOfQuestions -= 1
            } else {
                if let question = StorageManager.shared.allQuestions.shuffled()
                    .first(where: {
                        !$0.answered && $0.difficulty == difficulty
                            .dataModelId && !questions.contains($0) && $0.category == categoryId
                    }) {
                    questions.append(question)
                    numberOfQuestions -= 1
                } else if let question = StorageManager.shared.allQuestions
                    .shuffled()
                    .first(where: {
                        !$0.answered && $0.difficulty == difficulty.next
                            .dataModelId && !questions.contains($0) && $0.category == categoryId
                    }) {
                    questions.append(question)
                    numberOfQuestions -= 1
                } else {
                    if StorageManager.shared.allQuestions
                        .contains(where: {!$0.answered && $0.category == categoryId && ($0.difficulty == difficulty.next.dataModelId || $0.difficulty == difficulty.next.next.dataModelId)}) {
                        difficulty = difficulty.next
                    } else {
                        if let question = StorageManager.shared.allQuestions
                            .shuffled()
                            .first(where: { !questions.contains($0) && $0.category == categoryId }) {
                            questions.append(question)
                            numberOfQuestions -= 1
                        }
                    }
                }
            }
        }
        self.questions = questions
    }
    deinit{
        timer?.invalidate()
        timer = nil
    }
}

struct QuizManager_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
