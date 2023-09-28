import SwiftUI

let PADDING_TOP = 24.0
let PADDING_TOP_IPAD = PADDING_TOP * 2

let PADDING_BOTTOM = 10.0
let PADDING_BOTTOM_IPAD = PADDING_BOTTOM * 2

let TEXT_SIZE_TITLE = 10.0
let TEXT_SIZE_TITLE_IPAD = TEXT_SIZE_TITLE * 2

let TEXT_SIZE_STAT_VALUE = 30.0
let TEXT_SIZE_STAT_VALUE_IPAD = (TEXT_SIZE_STAT_VALUE/3) * 4.4

let TEXT_SIZE_STAT_SECOND_VALUE = 14.0
let TEXT_SIZE_STAT_SECOND_VALUE_IPAD = (TEXT_SIZE_STAT_SECOND_VALUE/2) * 3

let TEXT_SIZE_BOTTOM = 11.0
let TEXT_SIZE_BOTTOM_IPAD = TEXT_SIZE_BOTTOM * 2

let MAX_WIDTH_FRAME = 120.0
let MAX_WIDTH_FRAME_IPAD = (MAX_WIDTH_FRAME / 2) * 4

let MAX_HEIGHT_FRAME = 120.0
let MAX_HEIGHT_FRAME_IPAD = (MAX_HEIGHT_FRAME / 2) * 4

let CORNER_RADIUS = 20.0
let CORNER_RADIUS_IPAD = CORNER_RADIUS * 1.3

class StatsItemViewConstants {
    static let PADDING_TOP = 24.0
    static let PADDING_TOP_IPAD = PADDING_TOP * 2

    static let PADDING_BOTTOM = 14.0
    static let PADDING_BOTTOM_IPAD = PADDING_BOTTOM * 2

    static let TEXT_SIZE_TITLE = 12.0
    static let TEXT_SIZE_TITLE_IPAD = TEXT_SIZE_TITLE * 2

    static let TEXT_SIZE_STAT_VALUE = 32.0
    static let TEXT_SIZE_STAT_VALUE_IPAD = (TEXT_SIZE_STAT_VALUE/3) * 4.4

    static let TEXT_SIZE_STAT_SECOND_VALUE = 14.0
    static let TEXT_SIZE_STAT_SECOND_VALUE_IPAD = (TEXT_SIZE_STAT_SECOND_VALUE/2) * 3

    static let TEXT_SIZE_BOTTOM = 14.0
    static let TEXT_SIZE_BOTTOM_IPAD = TEXT_SIZE_BOTTOM * 2

    static let MAX_WIDTH_FRAME = 120.0
    static let MAX_WIDTH_FRAME_IPAD = (MAX_WIDTH_FRAME / 2) * 4

    static let MAX_HEIGHT_FRAME = 120.0
    static let MAX_HEIGHT_FRAME_IPAD = (MAX_HEIGHT_FRAME / 2) * 4

    static let CORNER_RADIUS = AppConstants.cornerRadius
    static let CORNER_RADIUS_IPAD = CORNER_RADIUS * 1.3
    
    static func getCornerRadius() -> CGFloat {
        return UIScreen.iPad ? CORNER_RADIUS_IPAD : CORNER_RADIUS
    }
    
    static func getMaxHeight() -> CGFloat {
        return UIScreen.iPad ? MAX_HEIGHT_FRAME_IPAD : MAX_HEIGHT_FRAME
    }
    
    static func getMaxWidth() -> CGFloat {
        return UIScreen.iPad ? MAX_WIDTH_FRAME_IPAD : MAX_WIDTH_FRAME
    }
    
    static func getTopPadding() -> CGFloat {
        return UIScreen.iPad ? PADDING_TOP_IPAD : PADDING_TOP
    }
    
    static func getBottomPadding() -> CGFloat {
        return UIScreen.iPad ? PADDING_BOTTOM_IPAD : PADDING_BOTTOM
    }

    static func getTopTextFontSize() -> CGFloat {
        return UIScreen.iPad ? TEXT_SIZE_TITLE_IPAD : TEXT_SIZE_TITLE
    }
    
    static func getStatValueFontSize() -> CGFloat {
        return UIScreen.iPad ? TEXT_SIZE_STAT_VALUE_IPAD : TEXT_SIZE_STAT_VALUE
    }
    
    static func getSecondValueFontSize() -> CGFloat {
        return UIScreen.iPad ? TEXT_SIZE_STAT_SECOND_VALUE_IPAD : TEXT_SIZE_STAT_SECOND_VALUE
    }
    
    static func getBottomMessageFontSize() -> CGFloat {
        return UIScreen.iPad ? TEXT_SIZE_BOTTOM_IPAD : TEXT_SIZE_BOTTOM
    }
}

struct StatsItemView: View {
    enum StatType {
        case streak(dayStreak: Int),
             longestStreak(dayStreak: Int),
             badges(badgesEarned: Int),
             goal(goal: Int, percentage: Int),
             score(correct: Int, all: Int),
             completed(numberOfQuizzes: Int),
             correct(correctAnswers: Int)

        var icon: String {
            switch self {
            case .streak: return UIScreen.iPad ? "img_streak_ipad" : "img_streak"
            case .longestStreak: return UIScreen.iPad ? "img_fire" : "img_fire"
            case .badges: return  UIScreen.iPad ? "star_one_ipad" : "star_one"
            case .goal: return  UIScreen.iPad ? "img_leaf_ipad" : "img_leaf"
            case .score: return  UIScreen.iPad ? "img_leaf_ipad" : "img_leaf"
            case .completed: return  UIScreen.iPad ? "ic_book_ipad" : "ic_book"
            case .correct: return  UIScreen.iPad ? "img_rocket" : "img_rocket"
            }
        }

        var title: String {
            switch self {
            case .streak, .longestStreak: return "Consecutive days"
            case .badges: return "You've earned"
            case let .goal(goal, _): return "Your goal is \(goal)%."
            case .score: return "How you did."
            case .completed: return "You’ve Completed"
            case .correct: return "You've Answered"
            }
        }

        var value: String {
            switch self {
            case let .streak(dayStreak): return "\(dayStreak)"
            case let .longestStreak(dayStreak): return "\(dayStreak)"
            case let .badges(badgesEarned): return "\(badgesEarned)"
            case let .goal(_, percentage): return "\(percentage)"
            case let .score(correct, _): return "\(correct)"
            case let .completed(numberOfQuizzes): return "\(numberOfQuizzes)"
            case let .correct(correctAnswers): return "\(correctAnswers)"
            }
        }

        var secondValue: String? {
            switch self {
            case let .score(_, all): return "/\(all)"
            case .goal: return "%"
            default: return nil
            }
        }

        var bottomMessage: String {
            switch self {
            case .streak: return "Current Streak"
            case .longestStreak: return "Longest Streak"
            case .badges: return "Badges"
            case .score: return "Average Score"
            case .goal: return "Current score"
            case .completed: return "Quizzes"
            case .correct: return "Correct"
            }
        }

        var mainTextColor: Color {
            switch self {
            case let .goal(goal, percentage): return goal > percentage ?
                .errorRed : .successGreen
            default: return .text
            }
        }
    }

    var statItemType: StatType
    
    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: StatsItemViewConstants.getCornerRadius(),
                style: .continuous
            )
            .fill(.white)
            .frame(
                maxWidth: StatsItemViewConstants.getMaxWidth(),
                maxHeight: StatsItemViewConstants.getMaxHeight()
            )
            .padding(.top, StatsItemViewConstants.getTopPadding())
            VStack {
                Image(statItemType.icon)
                    .resizable()
                    .frame(width: UIScreen.iPad ? 120 : 70, height: UIScreen.iPad ? 120 : 70)
                    .padding(.bottom, UIScreen.iPad ? 44.0 : 0.0)
                Text(statItemType.title)
                    .foregroundColor(.lightTeal)
                    .font(Font.nunito(.bold, size: StatsItemViewConstants.getTopTextFontSize()))
                    .padding(.top, UIScreen.iPad ? -30.0 : 0)
                HStack(spacing: 3) {
                    Text(statItemType.value)
                        .font(Font.nunito(.bold, size: StatsItemViewConstants.getStatValueFontSize()))
                        .fontWeight(.bold)
                        .foregroundColor(statItemType.mainTextColor)
                    if let secondValue = statItemType.secondValue {
                        Text(secondValue)
                            .font(Font.nunito(.bold, size: StatsItemViewConstants.getSecondValueFontSize()))
                            .foregroundColor(.medGray)
                    }
                }
                Text(statItemType.bottomMessage)
                    .font(Font.nunito(.medium, size: StatsItemViewConstants.getBottomMessageFontSize()))
                    .padding(.bottom, StatsItemViewConstants.getBottomPadding())
                    .foregroundColor(.text)
            }
        }
    }
}

struct StatsItemViewQuizComplete: View {
    enum StatType {
        case totalTimeSpent(timeSpent: String),
             streak(dayStreak: Int),
             longestStreak(dayStreak: Int),
             badges(badgesEarned: Int),
             goal(goal: Int, percentage: Int),
             score(correct: Int, all: Int),
             completed(numberOfQuizzes: Int)

        var icon: String {
            switch self {
            case .totalTimeSpent: return "ic_hour_glass"
            case .streak, .longestStreak: return UIScreen.iPad ? "ic_hour_glass_ipad" : "ic_hour_glass"
            case .badges: return UIScreen.iPad ? "star_one_ipad" : "star_one"
            case .goal: return "ic_star_quiz_complete"
            case .score: return "ic_heart"
            case .completed: return "ic_heart"
            }
        }

        var title: String {
            switch self {
            case .totalTimeSpent: return "You completed it in"
            case .streak, .longestStreak: return "Consecutive days"
            case .badges: return "You've earned"
            case let .goal(goal, _): return "Your goal is \(goal)%."
            case .score: return "How you did."
            case .completed: return "You’ve Completed"
            }
        }

        var value: String {
            switch self {
            case let .totalTimeSpent(timeSpent): return "\(timeSpent)"
            case let .streak(dayStreak): return "\(dayStreak)"
            case let .longestStreak(dayStreak): return "\(dayStreak)"
            case let .badges(badgesEarned): return "\(badgesEarned)"
            case let .goal(_, percentage): return "\(percentage)"
            case let .score(correct, _): return "\(correct)"
            case let .completed(numberOfQuizzes): return "\(numberOfQuizzes)"
            }
        }

        var secondValue: String? {
            switch self {
            case let .score(_, all): return "/\(all)"
            case .goal: return "%"
            default: return nil
            }
        }

        var bottomMessage: String {
            switch self {
            case .totalTimeSpent: return "Minutes"
            case .streak: return "Current Streak"
            case .longestStreak: return "Longest Streak"
            case .badges: return "Badges"
            case .score: return "Average Score"
            case .goal: return "Current score"
            case .completed: return "Quizzes"
            }
        }

        var mainTextColor: Color {
            switch self {
            case let .goal(goal, percentage): return goal > percentage ?
                .errorRed : .successGreen
            default: return .text
            }
        }
    }

    var statItemType: StatType

    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: StatsItemViewConstants.getCornerRadius(),
                style: .continuous
            )
            .fill(.white)
            .padding(.top, StatsItemViewConstants.getTopPadding())
            VStack {
                Image(statItemType.icon)
                    .resizable()
                    .frame(width: UIScreen.iPad ? 120 : 70, height: UIScreen.iPad ? 120 : 70)
                    .padding(.top, UIScreen.iPad ? 18.0 : 0.0)
                Text(statItemType.title)
                    .foregroundColor(.lightTeal)
                    .font(Font.nunito(.bold, size: StatsItemViewConstants.getTopTextFontSize()))
                HStack(spacing: 3) {
                    Text(statItemType.value)
                        .font(Font.nunito(.bold, size: StatsItemViewConstants.getStatValueFontSize()))
                        .fontWeight(.bold)
                        .foregroundColor(statItemType.mainTextColor)
                    if let secondValue = statItemType.secondValue {
                        Text(secondValue)
                            .font(Font.nunito(.bold, size: StatsItemViewConstants.getSecondValueFontSize()))
                            .foregroundColor(.medGray)
                    }
                }
                Text(statItemType.bottomMessage)
                    .font(Font.nunito(.medium, size: StatsItemViewConstants.getBottomMessageFontSize()))
                    .padding(.bottom, StatsItemViewConstants.getBottomPadding())
                    .foregroundColor(.text)
            }
        }
        .frame(
            maxWidth: StatsItemViewConstants.getMaxWidth(),
            maxHeight: StatsItemViewConstants.getMaxHeight()
        )
    }
}


struct StatsItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                StatsItemView(statItemType: .longestStreak(dayStreak: 20))
                StatsItemView(statItemType: .badges(badgesEarned: 6))
                StatsItemView(statItemType: .completed(numberOfQuizzes: 6))
            }.padding(.bottom, 16)
            
            HStack {
                StatsItemViewQuizComplete(statItemType: .streak(dayStreak: 20))
                StatsItemViewQuizComplete(statItemType: .badges(badgesEarned: 6))
                StatsItemViewQuizComplete(statItemType: .completed(numberOfQuizzes: 6))
            }
        }
    }
}
