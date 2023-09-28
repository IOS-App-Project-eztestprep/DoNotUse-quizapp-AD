import SwiftUI

struct AnswerRow: View {
    @EnvironmentObject
    var quizManager: QuizManager
    @State
    var answer: AnswerModel
    @State
    var isSelected = false
    var body: some View {
        HStack {
            Text(answer.content)
                .font(Font.nunito(.bold, size: 12))
                .fontWeight(.bold)
                .foregroundColor(.buttonGray)
            Spacer()
            if isSelected && answer.id == quizManager.currentAnswer?.id {
                if !quizManager.learnMode {
                    Image("ic_check_black")
                } else {
                    Image(answer.correct ? "ic_check_black" : "ic_close_black")
                }
            } else if quizManager.answerSelected && answer.correct && quizManager.learnMode {
                Image("ic_check_black")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .style(
                    withStroke: borderColor(),
                    lineWidth: 1,
                    fill: backgroundColor()
                )
        )
        .onTapGesture {
            if !quizManager.answerSelected || !quizManager.learnMode {
                quizManager.selectAnswer(answer: answer)
                isSelected = true
            }
        }
    }

    func backgroundColor() -> Color {
//        print("-----------------------")
//        print("Answer: ", answer)
//        print("isSelected: ", isSelected)
//        print("answer.correct: ", answer.correct)
        
        if !quizManager.learnMode {
            return isSelected && answer.id == quizManager.currentAnswer?.id ? .answerBackgroundBlue : .white
        } else {
            // return isSelected && answer.id == quizManager.currentAnswer?.id ? (answer.correct ? .successGreenBackground : .errorRedBackground) : .white
            if isSelected {
                return answer.id == quizManager.currentAnswer?.id ? (answer.correct ? .successGreenBackground : .errorRedBackground) : .white
            } else if quizManager.answerSelected {
                return answer.correct ? .successGreenBackground : .white
            } else {
                return .white
            }
        }
    }

    func borderColor() -> Color {
        if !quizManager.learnMode {
            return Color.lightTeal
        } else {
            return isSelected && answer.content == quizManager.currentAnswer?
                .content ?
                (answer.correct ? Color.successGreen : Color.errorRed) : Color
                .lightTeal
        }
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        AnswerRow(answer: AnswerModel(answer: Answer(
            content: "Dummy Text",
            correct: true
        )))
        .environmentObject(QuizManager())
    }
}
