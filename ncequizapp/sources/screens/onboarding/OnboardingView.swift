import SwiftUI

struct OnboardingView: View,Loggable {
    @EnvironmentObject
    var storageManager: StorageManager
    
    @StateObject
    var userSettings: UserSettings = .init()
    
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    
    @State
    private var selectedTab: Int = 0
    
    @Binding
    var onboardingPresented: Bool
    
    @State
    var subscriptionPresented: Bool = false
    
    var colors: [Color] = [.red, .blue, .pink, .yellow]
    
    func getHeroImage(selectedTab: Int) -> String {
        if selectedTab == 0 {
            if UIScreen.iPad {
                return "img_ob_level_ipad"
            } else {
                return "img_ob_level"
            }
        } else if selectedTab == 1 {
            if UIScreen.iPad {
                return "img_ob_goal_ipad"
            } else {
                return "img_ob_goal"
            }
        } else if selectedTab == 2 {
            if UIScreen.iPad {
                return "img_ob_score_ipad"
            } else {
                return "img_ob_score"
            }
        } else if selectedTab == 3 {
            if UIScreen.iPad {
                return "pass_guarantee"
            } else {
                return "pass_guarantee"
            }
        } else {
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            Color.lightestBlue
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HStack {
                    Button {
                        if selectedTab > 0 {
                            withAnimation {
                                selectedTab -= 1
                            }
                        } else if selectedTab == 0 {
                            onboardingPresented = false
                        }
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
                
                /*
                 
                 */
                Image(getHeroImage(selectedTab: selectedTab))
                    .resizable()
                    .scaledToFit()
                    .scaleEffect((UIScreen.isSmallScreenIphone && selectedTab == 3) || (selectedTab == 3) ? 0.4 : UIScreen.isSmallScreenIphone ? 0.6 : 1)
                    .padding(.top, (UIScreen.isSmallScreenIphone || selectedTab == 3) ? -50 : 0)
                    .padding(.bottom, (UIScreen.isSmallScreenIphone || selectedTab == 3) ? -50 : 0)
                    
                TabView(selection: $selectedTab) {
                    VStack(alignment: .leading, spacing: 8) {
                        ScrollView(.vertical, showsIndicators: false){
                            Text(
                                "**What level are you?** \nThe questions will progressively get harder as you go. You can adjust this later in settings."
                            )
                            .font(Font.nunito(.regular, size:18))
                            .foregroundColor(.buttonGray)
                            .padding(.bottom, 10)
                            .minimumScaleFactor(0.01)
                            OnboardingRow(
                                title: "Easy",
                                isSelected: userSettings.level == .easy
                            ) {
                                userSettings.level = .easy
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Medium",
                                isSelected: userSettings.level == .medium
                            ) {
                                userSettings.level = .medium
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Hard",
                                isSelected: userSettings.level == .hard
                            ) {
                                userSettings.level = .hard
                                userSettings.checkIfCompleted()
                            }
                            
                        }.modifier(DisableScrollingModifier(direction: .horizontal))
                    }.padding(.horizontal, UIScreen.iPad ? 100 : 5)
                        .padding(.bottom, 10)
                        .tag(0)
                    VStack(alignment: .leading, spacing: 10) {
                        ScrollView(.vertical, showsIndicators: false){
                            Text(
                                "**Pick a Goal.** \nHow many questions would you like for your daily study goal?"
                            )
                            .font(Font.nunito(.regular, size:18))
                            .foregroundColor(.buttonGray)
                            .padding(.bottom, 10)
                            .minimumScaleFactor(0.01)
                            
                            OnboardingRow(
                                title: "Casual  ",
                                subtitle: "\(OnboardingNumberOfQuestions.casual.numberOfQuestions) questions a day",
                                isSelected: userSettings
                                    .numberOfQuestions == .casual
                            ) {
                                userSettings.numberOfQuestions = .casual
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Regular ",
                                subtitle: "\(OnboardingNumberOfQuestions.regular.numberOfQuestions) questions a day",
                                isSelected: userSettings
                                    .numberOfQuestions == .regular
                            ) {
                                userSettings.numberOfQuestions = .regular
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Serious ",
                                subtitle: "\(OnboardingNumberOfQuestions.serious.numberOfQuestions) questions a day",
                                isSelected: userSettings
                                    .numberOfQuestions == .serious
                            ) {
                                userSettings.numberOfQuestions = .serious
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Extreme",
                                subtitle: "\(OnboardingNumberOfQuestions.insane.numberOfQuestions) questions a day",
                                isSelected: userSettings
                                    .numberOfQuestions == .insane
                            ) {
                                userSettings.numberOfQuestions = .insane
                                userSettings.checkIfCompleted()
                            }
                        }
                        .modifier(DisableScrollingModifier(direction: .horizontal))
                    }.padding(.horizontal, UIScreen.iPad ? 100 : 5)
                        .padding(.bottom, 10)
                        .tag(1)
                    VStack(alignment: .leading) {
                        ScrollView(.vertical, showsIndicators: false){
                            Text("**Monitor how you are doing.** \nThis is your overall average score from all questions you answer.")
                                .font(Font.nunito(.regular, size:18))
                                .foregroundColor(.buttonGray)
                                .padding(.bottom, 10)
                                .minimumScaleFactor(0.01)
                            
                            OnboardingRow(
                                title: "Easy      ",
                                subtitle: "\(OnboardingScore.easy.scorePercentage)% score",
                                isSelected: userSettings.score == .easy
                            ) {
                                userSettings.score = .easy
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Difficult",
                                subtitle: "\(OnboardingScore.difficult.scorePercentage)% score",
                                isSelected: userSettings.score == .difficult
                            ) {
                                userSettings.score = .difficult
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Hard      ",
                                subtitle: "\(OnboardingScore.hard.scorePercentage)% score",
                                isSelected: userSettings.score == .hard
                            ) {
                                userSettings.score = .hard
                                userSettings.checkIfCompleted()
                            }
                            OnboardingRow(
                                title: "Extreme",
                                subtitle: "\(OnboardingScore.insane.scorePercentage)% score",
                                isSelected: userSettings.score == .insane
                            ) {
                                userSettings.score = .insane
                                userSettings.checkIfCompleted()
                            }
                        }
                        .modifier(DisableScrollingModifier(direction: .horizontal))
                    }.padding(.horizontal, UIScreen.iPad ? 100 : 5)
                        .padding(.bottom, 10)
                        .tag(2)
                    VStack(alignment: .leading, spacing: 8) {
                        ScrollView(.vertical, showsIndicators: false){
                            Text("Pass Guarantee")
                                .font(Font.nunito(.bold, size: UIScreen.isSmallScreenIphone ? 34 : UIScreen.iPad ? 56 : 40))
                                .foregroundColor(.lightTeal)
                                .minimumScaleFactor(0.01)
                            
                            Text("Try it Risk Free Today")
                                .font(Font.nunito(.bold, size:UIScreen.iPad ? 26 : 18))
                                .foregroundColor(.buttonGray)
                                .padding(.top, UIScreen.iPad ? -46 : -36)
                            
                            Text("100% Money-Back + a Free \nSubscription Until You Pass")
                                .font(Font.nunito(.bold, size:UIScreen.iPad ? 26 : 18))
                                .foregroundColor(.buttonGray)
                                .padding(.top, UIScreen.isSmallScreenIphone ? -20 : 0)
                            
                            Text("Eligibility: 80% cumulative score & 500+ questions attempted*")
                                .font(Font.nunito(.medium, size:9))
                                .foregroundColor(.buttonGray)
                            
                            ReviewRow(reviewText: "\"I felt so much more confident on exam day.\"", reviewer: "Stella, LPCC")
                                .padding(.top, UIScreen.isSmallScreenIphone ? 4 : 20)
                            
                            Text("**Are you ready to ace your exam?**")
                                .font(Font.nunito(.medium, size: UIScreen.iPad ? 28 :  UIScreen.isSmallScreenIphone ? 16 : 18))
                                .foregroundColor(.buttonGray)
                                .padding(.top, UIScreen.isSmallScreenIphone ? -10 : 12)
                            
                            OnboardingRow(
                                title: "YES!",
                                isSelected: userSettings.readyToAce == true
                            ) {
                                userSettings.readyToAce = true
                                userSettings.checkIfCompleted()
                            }
                            
                            Spacer()
                        }
                        .modifier(DisableScrollingModifier(direction: .horizontal))
                        .padding(.top, UIScreen.iPad ? -10 : 20)
                    }.padding(.horizontal, UIScreen.iPad ? 100 : 5)
                        .padding(.bottom, 10)
                        .tag(3)
                }
                .modifier(DisableScrollingModifier(direction: .horizontal))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.top, selectedTab == 3 ? -50 : UIScreen.iPad ? 40 : 0)
                HStack(spacing: 8) {
                    ForEach(colors.indices, id: \.self) { index in
                        Capsule()
                            .fill(selectedTab == index ? Color.textSubtitle : Color.lightPurple)
                            .frame(width: selectedTab == index ? 20 : 7, height: 7 )
                            .scaleEffect(selectedTab == index ? 1.1 : 1)
                            .animation(.spring(), value: selectedTab == index)
                    }
                }
                Button {
                    if selectedTab < 3 {
                        withAnimation {
                            selectedTab += 1
                        }
                    } else if selectedTab == 3 {
                        if subscriptionManager.isSubscribed {
                            storageManager.saveUserSettings(userSettings)
                        } else {
                            subscriptionPresented = true
                        }
                    }
                    userSettings.onboardingComplete = true
                } label: {
                    RoundedButton(
                        text: selectedTab == 3 ? "Let's go!" : "Next",
                        isSelectable: !shouldDisableNextButton(selectedTabIndex: selectedTab)
                    )
                    .frame(
                        width: UIScreen
                            .screenWidth - (UIScreen.iPad ? 300 : 60)
                    )
                }
                .disabled(shouldDisableNextButton(selectedTabIndex: selectedTab))
            }.padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
                .fullScreenCover(
                    isPresented: $subscriptionPresented,
                    onDismiss: {
                        subscriptionPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            storageManager.saveUserSettings(userSettings)
                        }
                    }
                ) {
                    if StorageManager.shared.shouldShowPromotionalOffer() {
                        IntroductoryOfferView()
                    } else {
                        SubscriptionViewv2(isOnboarding: true)
                    }
                }
        }.onAppear {
            logScreen(self)
            UIScrollView.appearance().isScrollEnabled = false
        }
        .onDisappear(perform: {
            UIScrollView.appearance().isScrollEnabled = true
        })
    }
    
    func shouldDisableNextButton(selectedTabIndex: Int) -> Bool {
        // selectedTab != 3 ? true : (userSettings.isCompleted)
        // isSelectable ==> selectedTab != 3 ? true : (userSettings.isCompleted)
        if(selectedTabIndex == 0 && (userSettings.level == .easy || userSettings.level == .medium || userSettings.level == .hard)) {
            return false
        }
        
        if(selectedTabIndex == 1 && (userSettings.numberOfQuestions == .casual || userSettings.numberOfQuestions == .regular || userSettings.numberOfQuestions == .serious || userSettings.numberOfQuestions == .insane)) {
            return false
        }
        
        if(selectedTabIndex == 2 && (userSettings.score == .easy || userSettings.score == .difficult || userSettings.score == .hard || userSettings.score == .insane)) {
            return false
        }
        
        if(selectedTabIndex == 3 && userSettings.readyToAce) {
            return false
        }
        
        return true
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboardingPresented: .constant(true))
            .frame(width: nil)
    }
}
