import SwiftUI

struct QuizCompletedView: View, Loggable {
    @EnvironmentObject
    private var delegate: AppDelegate
    
    @EnvironmentObject
    var quizManager: QuizManager
    
    @EnvironmentObject
    var storageManager: StorageManager
    
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @State
    var subscriptionScreenPresented: Bool = false
    
    var reviewMissedQuestionsAction: (() -> Void)?
    
    @State
    var streakViewPresented: Bool = false
    
    let userDefaults = UserDefaults.standard
    
    func getAccessToAllFeaturesText() -> String {
        return "Get access to all of the features!"
    }
    
    func getVStack() -> some View {
        return VStack {
            if !subscriptionManager.isSubscribed {
                Text(getAccessToAllFeaturesText())
                    .font(.nunito(.regular, size: 16))
            }
            Button {
                if subscriptionManager.isSubscribed {
                    reviewMissedQuestionsAction?()
                } else {
                    subscriptionScreenPresented = true
                }
            } label: {
                RoundedButtonWithoutShadow(
                    text: subscriptionManager.isSubscribed ? "Review all missed questions" : "Unlock to review missed questions", isSelectable: false,
                    clearBackground: true
                )
            }
        }.padding(.top, 16)
    }
    
    func getFinishButton() -> some View {
        return Button {
            presentationMode.wrappedValue.dismiss()
            delegate.initiateBadgeNotifications = true
        } label: {
            RoundedButtonWithoutShadow(text: "Finish", isSelectable: false, clearBackground: true)
        }
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                if (quizManager.quizType == .daily){
                    Image(UIScreen.iPad ? "img_daily_quiz_finish" : "img_daily_quiz_finish")
                    Text("Daily Quiz Complete!\nKeep the streak going!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 38 : 20))
                        .fixedSize(horizontal: false, vertical: true)
                }else if (quizManager.quizType == .timed){
                    Image(UIScreen.iPad ? "ic_quiz_complete_ipad" : "ic_quiz_complete")
                    Text("Quiz complete.\nNice job!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 38 : 20))
                        .fixedSize(horizontal: false, vertical: true)
                }else if (quizManager.quizType == .bookmarked){
                    Image(UIScreen.iPad ? "ic_bookmarked_finish" : "ic_bookmarked_finish")
                    Text("You’ve finished all of your\nbookmarked questions.\n\nAdd more to keep studying!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 38 : 20))
                        .fixedSize(horizontal: false, vertical: true)
                }else if (quizManager.quizType == .missed){
                    Image(UIScreen.iPad ? "img_missed_question_finish" : "img_missed_question_finish")
                    Text("That’s all of your missed\nquestions.\n\nRemove questions by\nanswering them correctly!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 38 : 20))
                        .fixedSize(horizontal: false, vertical: true)
                }
                else {
                    Image(UIScreen.iPad ? "ic_quiz_complete_ipad" : "ic_quiz_complete")
                    Text("Quiz complete.\nNice job!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 38 : 20))
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                
                
                if !subscriptionManager.isSubscribed {
                    Text("Want more?")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 40 : 20))
                    UnlockView(
                        icon: "ic_crown",
                        text: "Unlock all questions".uppercased(),
                        fillColor: .goalGreen
                    ) {
                        subscriptionScreenPresented = true
                    }
                } else {
                    Spacer()
                }
                Text("This is how you did.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.text)
                    .font(Font.nunito(.regular, size: UIScreen.iPad ? 30 : 20))
                    .padding(.top, UIScreen.iPad ? 20 : 0)
                
                HStack(spacing: UIScreen.iPad ? 20 : 10) {
                    StatsItemViewQuizComplete(statItemType: .goal(
                        goal: storageManager.userSettings.score?
                            .scorePercentage ?? 80,
                        percentage: quizManager.finalScorePercentage
                    ))
                    StatsItemViewQuizComplete(statItemType: .score(
                        correct: quizManager.score,
                        all: quizManager.length
                    ))
                }.frame(width: UIScreen.screenWidth)
                
                // Footer view
                if UIScreen.iPad {
                    HStack(alignment: .bottom, spacing: 16.0) {
                        getVStack()
                        getFinishButton()
                    }.frame(width: UIScreen.screenWidth - UIScreen.screenWidth / 6)
                } else {
                    VStack() {
                        getVStack()
                        getFinishButton()
                    }.frame(width: UIScreen.screenWidth - UIScreen.screenWidth / 6)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(EdgeInsets(
                top: 0,
                leading: UIScreen.iPad ? 100 : 20,
                bottom: 60,
                trailing: UIScreen.iPad ? 100 : 20
            ))}
        .background(Color.lightestBlue)
        .fullScreenCover(isPresented: $streakViewPresented, onDismiss: {
            streakViewPresented = false
        }) {
            StreakNotificationView(
                streakLevel: StreakNotificationView
                    .StreakLevel(number: storageManager.dailyStreak) ?? StreakNotificationView.StreakLevel.three
            )
        }
        .sheet(isPresented: $subscriptionScreenPresented, onDismiss: {
            subscriptionScreenPresented = false
        }) {
            if StorageManager.shared.shouldShowPromotionalOffer() {
                IntroductoryOfferView()
            } else {
                SubscriptionViewv2()
            }
        }
        .onAppear {
            logScreen(self)
            let streaklevel = StreakNotificationView.StreakLevel(number: storageManager.dailyStreak)
            if  quizManager.quizType == .daily, streaklevel != nil {//,
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    streakViewPresented = true
                }
            } else if quizManager.finalScorePercentage >= 80 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIApplication.requestReview()
                    self.log("Review requested")
                }
            }
            
            let scorePercentage = quizManager.questions.count != 0 ?
                Int((Float(quizManager.score) / Float(quizManager.questions.count) * 100).rounded()) : 0
            
            if(scorePercentage == 100) {
                var timesScored100Percent = userDefaults.integer(forKey: UserDefaultsKeys.scored100Percent.rawValue)
                timesScored100Percent += 1
                
                userDefaults.setValue(timesScored100Percent, forKey: UserDefaultsKeys.scored100Percent.rawValue)
                
                if(timesScored100Percent == 1) {
                    userDefaults.setValue(true, forKey: UserDefaultsKeys.badge21.rawValue)
                } else if(timesScored100Percent == 3) {
                    userDefaults.setValue(true, forKey: UserDefaultsKeys.badge22.rawValue)
                } else if(timesScored100Percent == 10) {
                    userDefaults.setValue(true, forKey: UserDefaultsKeys.badge23.rawValue)
                } else if(timesScored100Percent == 20) {
                    userDefaults.setValue(true, forKey: UserDefaultsKeys.badge24.rawValue)
                }
                
                // Exam simulator
                if quizManager.quizType == .timed {
                    let timesScored100Percent = userDefaults.integer(forKey: UserDefaultsKeys.scored100PercentOnExamSimulator.rawValue)
                    userDefaults.setValue(true, forKey: UserDefaultsKeys.badge33.rawValue)
                    userDefaults.setValue(timesScored100Percent + 1, forKey: UserDefaultsKeys.scored100PercentOnExamSimulator.rawValue)
                }
            }
            
            if quizManager.quizType == .timed && (scorePercentage > 90 && scorePercentage < 100) {
                let timesScored100Percent = userDefaults.integer(forKey: UserDefaultsKeys.scored90PercentOnExamSimulator.rawValue)
                userDefaults.setValue(true, forKey: UserDefaultsKeys.badge32.rawValue)
                userDefaults.setValue(timesScored100Percent + 1, forKey: UserDefaultsKeys.scored90PercentOnExamSimulator.rawValue)
            }
            
            // Quiz completion time
            
            let currentDateTime = Date().localDate
            let midnight = Calendar.current.startOfDay(for: currentDateTime).localDate
            
            let _startDateTimePreviousDay = midnight.addHours(hours: -1)
            let _endDateTimePreviousDay = midnight.addHours(hours: 2)
            
            let _startDateSameDay = midnight.addHours(hours: 23)
            let _endDateTimeSameDay = midnight.addHours(hours: 26)
            
            let hour = Calendar.current.component(.hour, from: Date())
            
            if currentDateTime.isBetween(_startDateTimePreviousDay, _endDateTimePreviousDay) || currentDateTime.isBetween(_startDateSameDay, _endDateTimeSameDay) {
                userDefaults.setValue(true, forKey: UserDefaultsKeys.badge38.rawValue)
            } else if (hour >= 4 && hour <= 7) {
                userDefaults.setValue(true, forKey: UserDefaultsKeys.badge37.rawValue)
            }
        }
    }
    
    func formatMinuteSeconds(_ totalSeconds: Float) -> String {
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60).rounded(.toNearestOrAwayFromZero)
        let minutes = (totalSeconds/60).truncatingRemainder(dividingBy: 60).rounded(.toNearestOrAwayFromZero)
        
        return String(format:"%02.f:%02.f", minutes, seconds );
        
    }
}

struct QuizCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        QuizCompletedView()
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}
