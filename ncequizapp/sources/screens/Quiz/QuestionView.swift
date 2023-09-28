import SwiftUI

struct QuestionView: View {
    @EnvironmentObject
    var quizManager: QuizManager
    
    @Environment(\.presentationMode)
    var presentationMode

    var body: some View {
        VStack {
            HStack {
                Button {
                    quizManager.timer?.invalidate()
                    quizManager.timer = nil
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("ic_close")
                }
                Spacer()
                HStack {
                    Text("\(quizManager.index + 1) / \(quizManager.length)")
                        .foregroundColor(.buttonGray)
                        .fontWeight(.bold)
                    if quizManager.timer != nil {
                        Text(" | ")
                            .foregroundColor(.medGray)
                            .font(Font.nunito(.regular, size: 20))
                        Text(quizManager.timeRemaining.timeString)
                            .foregroundColor(
                                quizManager
                                    .timeRemaining > 10 ? Color
                                    .buttonGray :
                                    Color
                                    .errorRed
                            )
                    }
                }
                Spacer()
                Button {
                    quizManager.bookmarkCurrentQuestion()
                } label: {
                    if quizManager.currentQuestion.bookmarked {
                        Image("ic_bookmark")//.renderingMode(.template)
                            .foregroundColor(
                                quizManager
                                    .currentQuestionBookmarked ? .lightTeal :
                                    .medGray
                            )
                    } else {
                        Image("ic_bookmark_unselected")//.renderingMode(.template)
                            .foregroundColor(
                                quizManager
                                    .currentQuestionBookmarked ? .lightTeal :
                                    .medGray
                            )
                    }
                }

            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))

            ProgressBar(progress: quizManager.progress)

            ScrollView(.vertical, showsIndicators: true) {
                ScrollViewReader { value in
                    Text(quizManager.question)
                        .foregroundColor(.buttonGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(
                            top: 16,
                            leading: 20,
                            bottom: 40,
                            trailing: 20
                        ))
                        .id("question")
                        .onChange(of: quizManager.index) { _ in
                            value.scrollTo("question", anchor: .top)
                        }
                    if let selectedAnswer = quizManager.currentAnswer,
                       quizManager.learnMode {

                        ExplanationView(
                            correct: selectedAnswer.correct,
                            correctAnswer: "",
                            explanation: quizManager.explanation ?? ""
                        )
                        .padding(EdgeInsets(
                            top: 0,
                            leading: 20,
                            bottom: 40,
                            trailing: 20
                        ))
                        .id("explanation")
                        .onAppear {
                            withAnimation {
                                value.scrollTo(
                                    "explanation",
                                    anchor: .bottom
                                )
                            }
                        }
                    }
                }
            }
            .mask(
                VStack(spacing: 0) {
                    Rectangle().fill(Color.black)

                    // Bottom gradient
                    LinearGradient(
                        gradient:
                        Gradient(
                            colors: [Color.black, Color.black.opacity(0)]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 40)
                }
            )

            VStack(alignment: .leading, spacing: UIScreen.iPad ? 20 : 10) {
                ForEach(quizManager.answerChoices, id: \.id) { answer in
                    AnswerRow(
                        answer: answer,
                        isSelected: quizManager.currentAnswer?.content == answer
                            .content
                    )
                    .environmentObject(quizManager)
                }

            }.padding(EdgeInsets(
                top: 5,
                leading: UIScreen.iPad ? 100 : 15,
                bottom: 5,
                trailing: UIScreen.iPad ? 100 : 15
            ))
            .layoutPriority(1)
            HStack(spacing: 20) {
                if quizManager.previousQuestionAvailable {
                    Button {
                        quizManager.goToPreviousQuestion()
                    } label: {
                        Image("ic_back_gray")
                            .frame(width: 50, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.text, lineWidth: 1)
                            )
                    }
                }
                Button {
                    quizManager.answerSelected = false
                    quizManager.goToNextQuestion()
                } label: {
                    RoundedButtonWithoutShadow(
                        text: quizManager
                            .isLastQuestions ? "Finish" : "Next Question",
                        isSelectable: quizManager.answerSelected,
                        clearBackground: true
                    )
                }.disabled(!quizManager.answerSelected)
            }.padding(.horizontal, UIScreen.iPad ? 200 : 40)
        }
        .navigationBarHidden(true)
        .background(Color.lightestBlue)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
            .environmentObject(QuizManager())
    }
}

extension Int {
    fileprivate var timeString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter.string(from: TimeInterval(self))!
    }
}
