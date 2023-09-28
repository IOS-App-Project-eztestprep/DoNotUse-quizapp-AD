import SwiftUI

struct QuizView: View {
    @EnvironmentObject
    var quizManager: QuizManager
    @EnvironmentObject
    var storageManager: StorageManager
    @Environment(\.presentationMode)
    var presentationMode

    @State
    var showingLearnMode = false

    func getTextWidth() -> CGFloat {
        return  UIScreen.iPad ? UIScreen.screenWidth - 480 : UIScreen.screenWidth - 80
    }
    var body: some View {
        if quizManager.length < 1 {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image("ic_back")
                            Text("Back")
                                .foregroundColor(.buttonGray)
                                .font(Font.nunito(.regular, size:12))
                            Spacer()
                        }
                    }
                    Spacer()
                }
                Image(quizManager.quizType == .bookmarked ? "img_bookmarked": "img_missed_questions")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: UIScreen.iPad ? 400 : 200,
                        height: UIScreen.iPad ? 400 : 200
                    )
                Text(quizManager.quizType.emptyText)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.text)
                    .font(.nunito(.regular, size: 20))
                
                if (quizManager.quizType == .bookmarked){
                    Image("ic_bookmark")
                    .resizable()
                    .frame(
                        width: UIScreen.iPad ? 60 : 40,
                        height: UIScreen.iPad ? 60 : 40
                    )
                        
                    Text("Select this icon at the top of questions to save for later!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(.nunito(.regular, size: UIScreen.iPad ? 34 : 20))
                        .frame(width: getTextWidth())
                }
                
                Spacer()
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Text("10 Questions")
                            .font(.nunito(.regular, size: UIScreen.iPad ? 30 : 25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                        Spacer()
                        Image("ic_right_arrow")
                    }.padding()
                }.padding()
                    .frame(
                        width: UIScreen.iPad ? 340.0 : 280.0, height: 100.0, alignment: .center
                    )
                    .foregroundColor(Color.white)
                    .background(Color.purpleRegular)
                    .cornerRadius(20)
                    .shadow(color: .medGray, radius: 4, x: 0, y: 4)
                    .onTapGesture {
                        startQuiz(ofType: .random)
                    }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
            .background(Color.lightestBlue)
            .sheet(isPresented: $showingLearnMode, onDismiss: {
                showingLearnMode = false
            }) {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    BottomSheet {
                        if UIScreen.iPad {
                            QuizModeViewIpad { quizMode in
                                presentQuiz(learnMode: quizMode == .learn)
                            }
                        }else {
                            QuizModeView { quizMode in
                                presentQuiz(learnMode: quizMode == .learn)
                            }
                        }
                    }
                }
            }
        } else {
            if quizManager.reachedEnd {
                QuizCompletedView {
                    quizManager.startQuiz(learnMode: true)
                    Task.init {
                        await quizManager
                            .fetchNewQuestions(forQuizType: .missed)
                    }
                }
                .environmentObject(storageManager)
                .environmentObject(quizManager)
            } else {
                QuestionView()
                    .environmentObject(quizManager)
            }
        }
    }

    private func presentQuiz(learnMode: Bool) {
        quizManager.startQuiz(learnMode: learnMode)
        Task.init {
            await quizManager.fetchNewQuestions(forQuizType: .random)
        }
    }

    private func startQuiz(ofType _: QuizType) {
        showingLearnMode = true
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
    }
}
