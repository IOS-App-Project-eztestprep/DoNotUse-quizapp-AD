import Foundation
import RealmSwift
import SwiftUI

class QuestionModel: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true)
    var id: Int = 0
    @Persisted
    var difficulty: Int = 0
    @Persisted
    var category: Int = 0
    @Persisted
    var content: String = ""
    @Persisted
    var answers: RealmSwift.List<AnswerModel>
    @Persisted
    var bookmarked: Bool = false
    @Persisted
    var choosenAnswer: AnswerModel?
    @Persisted
    var bookmarketAt: Date?
    @Persisted
    var answeredAt: Date?

    // Quiz variables
    var quizAnswer: AnswerModel?
    var bookmarkedDate: Date {
        bookmarketAt ?? Date()
    }

    var answeredDate: Date {
        answeredAt ?? Date()
    }

    var answered: Bool {
        choosenAnswer != nil
    }

    @Published
    var formattedContent: AttributedString = ""

    func formatContent() {
        DispatchQueue.main.async { [self] in
            formattedContent = content.attributedQuestion
        }
        answers.forEach { answer in
            answer.formatContent()
        }
    }
}

class AnswerModel: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true)
    var id: UUID = .init()
    @Persisted
    var content: String
    @Persisted
    var correct: Bool
    @Persisted
    var explanation: String?

    @Persisted
    var selected: Bool = false
    @Persisted(originProperty: "answers")
    var question: LinkingObjects<QuestionModel>

    convenience init(answer: Answer) {
        self.init()
        content = answer.content
        correct = answer.correct
        explanation = answer.explanation
    }

    // Quiz variables
    @Published
    var formattedContent: AttributedString = ""
    @Published
    var formattedExplanation: AttributedString?

    func formatContent() {
        DispatchQueue.main.async { [self] in
            formattedContent = content.attributedAnswer
            formattedExplanation = explanation?.attributedExplanation
        }
    }
}

struct QuestionDatasource: Decodable {
    var quizQuestions: [Question]

    struct Question: Decodable, Identifiable {
        var id: Int
        var difficulty: Int
        var category: Int
        var content: String
        var answers: [Answer]

        var shuffledAnswers: [Answer] {
            answers.shuffled()
        }
    }
}

struct Answer: Decodable, Identifiable {
    var id: UUID {
        UUID()
    }

    var content: String
    var correct: Bool
    var explanation: String?
}

enum QuizType: Equatable {
    case bookmarked, daily, missed, random, timed, correct, category

    var title: String {
        switch self {
        case .bookmarked:
            return "Bookmarked\nQuestions"
        case .daily:
            return "Daily\nQuiz"
        case .missed:
            return "Missed\nQuestions"
        case .random:
            return "10 Quick\nQuestions"
        case .timed:
            return "Exam\nSimulator"
        case .correct:
            return "Correct\nAnswered"
        case .category:
            return "Category"
        }
    }

    var icon: Image? {
        if !SubscriptionManager.shared.isSubscribed, [
            .bookmarked,
            .correct,
            .missed,
            .timed
        ].contains(self) {
            return Image("ic_lock")
        }
        
        return nil
    }

    var emptyText: String {
        switch self {
        case .bookmarked:
//            return "Looks like you haven't bookmarked any questions yet.\nWould you like to try a 10 question set?"
            return "You haven’t bookmarked any\nquestions yet."
        case .missed:
            return "It looks like you haven’t missed\nany questions  yet. Amazing!\n\nKeep going\nand try a new quiz!"
        case .correct:
            return "Looks like you haven't answered any questions correctly yet!\nWould you like to try a 10 question set?"
        default: return ""
        }
    }
}
