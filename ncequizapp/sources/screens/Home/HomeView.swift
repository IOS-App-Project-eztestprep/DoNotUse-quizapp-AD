import SwiftUI

struct HomeView: View, Loggable {
    @EnvironmentObject
    private var delegate: AppDelegate
    
    @EnvironmentObject
    var quizManager: QuizManager
    
    @EnvironmentObject
    var storageManager: StorageManager
    
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    
    @State
    var activeFullScreen: ActiveFullScreen?
    
    @State
    var showingLearnMode = false
    
    @Binding
    var tabSelection: Int
    
    @State
    var cardState: UIStateModel
    
    @State
    var categoryCardState: UIStateModel
    
    @State
    var isCategorySelection = false
    
    @State
    var badgeNotificationViewPresented: Bool = false
    
    let userDefaults = UserDefaults.standard
    @State private var badgesToShow: Array<BadgeNumber> = Array()
    
    func getHeroImageHeightWidth() -> CGFloat {
        return UIScreen.iPad ? 400 : 200
    }
    
    var body: some View {
        Group {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                    .sheet(isPresented: $showingLearnMode, onDismiss: {
                        showingLearnMode = false
                    }) {
                        BottomSheet {
                            if UIScreen.iPad {
                                QuizModeViewIpad { quizMode in
                                    if isCategorySelection{
                                        isCategorySelection = false
                                        presentCategoryQuiz(learnMode: quizMode == .learn)
                                    }else {
                                        presentQuiz(learnMode: quizMode == .learn)
                                    }
                                    
                                }
                            }else {
                                QuizModeView { quizMode in
                                    if isCategorySelection{
                                        isCategorySelection = false
                                        presentCategoryQuiz(learnMode: quizMode == .learn)
                                    } else {
                                        presentQuiz(learnMode: quizMode == .learn)
                                    }
                                }
                            }
                        }
                        
                    }
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: UIScreen.iPad ? 50 : 10) {
                        // TOP SECTION
                        ZStack {
                            HStack(alignment: .center){
                                Spacer()
                                ZStack{
                                    Image(UIScreen.iPad ? "img_home_ipad" : "img_home")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: getHeroImageHeightWidth(), height: getHeroImageHeightWidth())
                                        .padding(EdgeInsets.init(top: 48, leading: 0, bottom: 20, trailing: UIScreen.iPad ? 350 : 150))
                                    VStack(alignment: .trailing) {
                                        HStack {
                                            if subscriptionManager.isSubscribed {
                                                TagView(
                                                    icon: "img_home_badge_count",
                                                    text: "\(storageManager.badgesUnlocked)",
                                                    fillColor: .lightestBlue
                                                ) {
                                                    tabSelection = 2
                                                }.padding(EdgeInsets(top: 16.0, leading: 0.0, bottom: 0.0, trailing: 16.0))
                                            } else {
                                                UnlockView(
                                                    icon: "ic_crown",
                                                    text: "UNLOCK",
                                                    fillColor: .goalGreen
                                                ) {
                                                    activeFullScreen =
                                                        .subscribe(limitReached: false)
                                                }.padding(EdgeInsets.init(top: 38, leading: 0, bottom: 0, trailing: 16.0))
                                            }
                                            
                                        }.padding(EdgeInsets.init(top: 0, leading: 150, bottom: 0, trailing: 16))
                                        
                                        VStack(alignment: .trailing) {
                                            VStack(alignment: .leading){
                                                Text(
                                                    storageManager.dailyQuizAvailable ? "**Welcome!**" : "**Nice Job!**"
                                                )
                                                .font(.nunito(.light, size: UIScreen.iPad ? 26 : 20))
                                                .foregroundColor(.lightTeal)
                                                .padding(EdgeInsets(top: 20.0, leading: 0.0, bottom: 0.0, trailing: UIScreen.iPad ? 120.0 : 10.0))
                                                
                                                Text(
                                                    storageManager.dailyQuizAvailable ? "Let’s Study." : "Keep it going!"
                                                )
                                                .font(.nunito(.medium, size: UIScreen.iPad ? 32  : 20))
                                                .foregroundColor(.textSubtitle)
                                                .lineLimit(nil)
                                                .multilineTextAlignment(.leading)
                                                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 8.0, trailing: UIScreen.iPad ? 10.0 : (storageManager.dailyQuizAvailable ? 54.0 : 38.0)))
                                                
                                            }
                                            HomeDailyButton {
                                                startQuiz(ofType: .daily)
                                            }
                                            .padding(EdgeInsets(top: UIScreen.iPad ? 40.0 : 0.0, leading: 0.0, bottom: 0.0, trailing: 16.0))
                                        }.padding(EdgeInsets.init(top: 0, leading: 150, bottom: 0, trailing: 16))
                                        
                                    }
                                }
                                
                                Spacer()
                            }.padding(EdgeInsets.init(top: 10, leading: 6, bottom: 0, trailing: 0))
                        }
                        .frame(width: UIScreen.screenWidth)
                        .background(Color.white)
                        
                        VStack {
                            // YOUR QUIZZES
                            Group {
                                ScreenTitle(title: "Your quizzes")
                                    .padding(EdgeInsets(top: UIScreen.iPad ? -32.0 : 0.0, leading: 16.0, bottom: 8.0, trailing: 0.0))
                                
                                SnapCarouselv2(items: [
                                    Card(
                                        id: 0,
                                        quizType: .random,
                                        action: { startQuiz(ofType: .random) },
                                        counterValue: storageManager.allQuestions
                                            .filter { $0.choosenAnswer != nil }.count
                                    ),
                                    Card(
                                        id: 1,
                                        quizType: .missed,
                                        action: { startQuiz(ofType: .missed) },
                                        counterValue: storageManager.allQuestions
                                            .filter {
                                                !($0.choosenAnswer?.correct ?? true)
                                            }
                                            .count,
                                        isUnlocked: subscriptionManager.isSubscribed
                                    ),
                                    Card(
                                        id: 2,
                                        quizType: .bookmarked,
                                        action: { startQuiz(ofType: .bookmarked) },
                                        isUnlocked: subscriptionManager.isSubscribed
                                    ),
                                    Card(
                                        id: 3,
                                        quizType: .timed,
                                        action: { startQuiz(ofType: .timed) },
                                        counterValue: storageManager
                                            .timedQuizzesCompleted,
                                        isUnlocked: subscriptionManager.isSubscribed
                                    ),
                                    Card(
                                        id: 4,
                                        quizType: .daily,
                                        action: { startQuiz(ofType: .daily) },
                                        isEnabled: storageManager.dailyQuizAvailable,
                                        counterValue: storageManager
                                            .dailyQuizzesCompleted
                                    )
                                ])
                                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 16.0, trailing: 0.0))
                                .environmentObject(self.cardState)
                            }
                            
                            Group {
                                ScreenTitle(title: "Categories")
                                .padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: -4.0, trailing: 0.0))
                                SnapCarouselCategory(items: [
                                    CategoryCard(
                                        id: 0,
                                        categoryType: .humanGrowth,
                                        action: { startCategoryQuiz(ofType: .humanGrowth) }),
                                    CategoryCard(
                                        id: 1,
                                        categoryType: .socialCultural,
                                        action: { startCategoryQuiz(ofType: .socialCultural) }
                                    ),
                                    CategoryCard(
                                        id: 2,
                                        categoryType: .helping,
                                        action: { startCategoryQuiz(ofType: .helping) }
                                    ),
                                    CategoryCard(
                                        id: 3,
                                        categoryType: .groupWork,
                                        action: { startCategoryQuiz(ofType: .groupWork) }
                                    ),
                                    CategoryCard(
                                        id: 4,
                                        categoryType: .career,
                                        action: { startCategoryQuiz(ofType: .career) }
                                    ),
                                    CategoryCard(
                                        id: 5,
                                        categoryType: .assessment,
                                        action: { startCategoryQuiz(ofType: .assessment) }
                                    ),
                                    CategoryCard(
                                        id: 6,
                                        categoryType: .research,
                                        action: { startCategoryQuiz(ofType: .research) }
                                    ),
                                    CategoryCard(
                                        id: 7,
                                        categoryType: .professional,
                                        action: { startCategoryQuiz(ofType: .professional) }
                                    ),
                                ])
                                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 16.0, trailing: 0.0))
                                .environmentObject(self.categoryCardState)
                            }
                            
                            ScreenTitle(title: "Total Progress")
                            .padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 0.0, trailing: 0.0))
                            HStack() {
                                StatsItemView(
                                    statItemType: .streak(
                                        dayStreak: storageManager
                                            .dailyStreak
                                    )
                                )
                                StatsItemView(statItemType: .goal(
                                    goal: storageManager.userSettings.score?
                                        .scorePercentage ?? 80,
                                    percentage: storageManager.actualScore
                                ))
                                StatsItemView(
                                    statItemType: .completed(
                                        numberOfQuizzes: storageManager
                                            .quizzesCompleted
                                    )
                                )
                            }
                            .padding(EdgeInsets.init(top: 0.0, leading: 12.0, bottom: 0.0, trailing: 12.0))
                            
                        }.background(Color.lightestBlue)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 100, trailing: 0))
                    .fullScreenCover(item: $activeFullScreen, onDismiss: {
                        activeFullScreen = nil
                    }) { item in
                        switch item {
                        case .quiz:
                            QuizView()
                            
                        case let .subscribe(limitReached):
                            if StorageManager.shared.shouldShowPromotionalOffer() {
                                IntroductoryOfferView()
                            } else {
                                SubscriptionViewv2()
                            }
                        }
                    }
                }.background(Color.lightestBlue)
                
            }
            .ignoresSafeArea()
            .onChange(of: delegate.initiateBadgeNotifications) { value in
                if value == true {
                    delegate.initiateBadgeNotifications = false
                    badgesToShow = getNewBadgesToShow()
                    if badgesToShow.count > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            badgeNotificationViewPresented = true
                        }
                    }
    
                    storageManager.updateBadgesAndTheirCount()
                }
            }
            .fullScreenCover(isPresented: $badgeNotificationViewPresented, onDismiss: {
                badgeNotificationViewPresented = false
                badgesToShow.removeFirst()
                if badgesToShow.count > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        badgeNotificationViewPresented = true
                    }
                }
            }) {
                let badgeToShow = badgesToShow.first
                BadgeNotificationView(showingSheet: $badgeNotificationViewPresented, badgeNumber: badgeToShow!, tabSelection: $tabSelection)
            }
            .onAppear {
                logScreen(self)
                NotificationsManager.shared.requestPermission()
            }
        }
        
    }
    
    func getNewBadgesToShow() -> Array<BadgeNumber> {
        var arrNewBadges = Array<BadgeNumber>()
        
        // Check Streak
        if(storageManager.dailyStreak >= 2 && userDefaults.bool(forKey: UserDefaultsKeys.badge1Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge1)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge1Shown.rawValue)
        }
        if(storageManager.dailyStreak >= 3 && userDefaults.bool(forKey: UserDefaultsKeys.badge2Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge2)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge2Shown.rawValue)
        }
        if(storageManager.dailyStreak >= 5 && userDefaults.bool(forKey: UserDefaultsKeys.badge3Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge3)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge3Shown.rawValue)
        }
        if(storageManager.dailyStreak >= 10 && userDefaults.bool(forKey: UserDefaultsKeys.badge4Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge4)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge4Shown.rawValue)
        }
        if(storageManager.dailyStreak >= 20 && userDefaults.bool(forKey: UserDefaultsKeys.badge5Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge5)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge5Shown.rawValue)
        }
        if(storageManager.dailyStreak >= 30 && userDefaults.bool(forKey: UserDefaultsKeys.badge6Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge6)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge6Shown.rawValue)
        }
        
        // Check Daily Quiz
        if(storageManager.dailyQuizzesCompleted >= 1 && userDefaults.bool(forKey: UserDefaultsKeys.badge7Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge7)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge7Shown.rawValue)
        }
        if(storageManager.dailyQuizzesCompleted >= 2 && userDefaults.bool(forKey: UserDefaultsKeys.badge8Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge8)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge8Shown.rawValue)
        }
        if(storageManager.dailyQuizzesCompleted >= 5 && userDefaults.bool(forKey: UserDefaultsKeys.badge9Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge9)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge9Shown.rawValue)
        }
        if(storageManager.dailyQuizzesCompleted >= 10 && userDefaults.bool(forKey: UserDefaultsKeys.badge10Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge10)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge10Shown.rawValue)
        }
        if(storageManager.dailyQuizzesCompleted >= 20 && userDefaults.bool(forKey: UserDefaultsKeys.badge11Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge11)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge11Shown.rawValue)
        }
        if(storageManager.dailyQuizzesCompleted >= 30 && userDefaults.bool(forKey: UserDefaultsKeys.badge12Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge12)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge12Shown.rawValue)
        }
        if(storageManager.dailyQuizzesCompleted >= 50 && userDefaults.bool(forKey: UserDefaultsKeys.badge13Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge13)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge13Shown.rawValue)
        }
        
        // Check Questions
        if(storageManager.answeredQuestions >= 20 && userDefaults.bool(forKey: UserDefaultsKeys.badge14Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge14)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge14Shown.rawValue)
        }
        if(storageManager.answeredQuestions >= 50 && userDefaults.bool(forKey: UserDefaultsKeys.badge15Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge15)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge15Shown.rawValue)
        }
        if(storageManager.answeredQuestions >= 100 && userDefaults.bool(forKey: UserDefaultsKeys.badge16Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge16)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge16Shown.rawValue)
        }
        if(storageManager.answeredQuestions >= 250 && userDefaults.bool(forKey: UserDefaultsKeys.badge17Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge17)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge17Shown.rawValue)
        }
        if(storageManager.answeredQuestions >= 500 && userDefaults.bool(forKey: UserDefaultsKeys.badge18Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge18)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge18Shown.rawValue)
        }
        if(storageManager.answeredQuestions >= 750 && userDefaults.bool(forKey: UserDefaultsKeys.badge19Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge19)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge19Shown.rawValue)
        }
        if(storageManager.answeredQuestions >= 1000 && userDefaults.bool(forKey: UserDefaultsKeys.badge20Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge20)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge20Shown.rawValue)
        }
        
        // Score of 100%
        let timesScored100Percent = userDefaults.integer(forKey: UserDefaultsKeys.scored100Percent.rawValue)
        if(timesScored100Percent >= 1 && userDefaults.bool(forKey: UserDefaultsKeys.badge21Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge21)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge21Shown.rawValue)
        }
        if(timesScored100Percent >= 3 && userDefaults.bool(forKey: UserDefaultsKeys.badge22Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge22)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge22Shown.rawValue)
        }
        if(timesScored100Percent >= 10 && userDefaults.bool(forKey: UserDefaultsKeys.badge23Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge23)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge23Shown.rawValue)
        }
        if(timesScored100Percent >= 20 && userDefaults.bool(forKey: UserDefaultsKeys.badge24Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge24)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge24Shown.rawValue)
        }
        
        // Minutes Spent
        let totalSecondsSpent: Int = userDefaults.object(forKey: UserDefaultsKeys.totalTimeQuiz.rawValue) as? Int ?? 0
        if((totalSecondsSpent / 60) >= 30 && userDefaults.bool(forKey: UserDefaultsKeys.badge25Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge25)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge25Shown.rawValue)
        }
        if((totalSecondsSpent / 60) >= 60 && userDefaults.bool(forKey: UserDefaultsKeys.badge26Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge26)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge26Shown.rawValue)
        }
        if((totalSecondsSpent / 60) >= 120 && userDefaults.bool(forKey: UserDefaultsKeys.badge27Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge27)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge27Shown.rawValue)
        }
        if((totalSecondsSpent / 60) >= 300 && userDefaults.bool(forKey: UserDefaultsKeys.badge28Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge28)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge28Shown.rawValue)
        }
        
        // Bookmarks
        let totalBookmarks = storageManager.allQuestions.filter { $0.bookmarked }.count
        if(totalBookmarks >= 3 && userDefaults.bool(forKey: UserDefaultsKeys.badge29Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge29)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge29Shown.rawValue)
        }
        if(totalBookmarks >= 10 && userDefaults.bool(forKey: UserDefaultsKeys.badge30Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge30)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge30Shown.rawValue)
        }
        if(totalBookmarks >= 20 && userDefaults.bool(forKey: UserDefaultsKeys.badge31Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge31)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge31Shown.rawValue)
        }
        
        // Timed quiz
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge32.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge32Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge32)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge32Shown.rawValue)
        }
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge33.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge33Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge33)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge33Shown.rawValue)
        }
        
        // Badges
        if(storageManager.badgesUnlocked >= 5 && userDefaults.bool(forKey: UserDefaultsKeys.badge34Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge34)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge34Shown.rawValue)
        }
        if(storageManager.badgesUnlocked >= 10 && userDefaults.bool(forKey: UserDefaultsKeys.badge35Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge35)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge35Shown.rawValue)
        }
        if(storageManager.badgesUnlocked >= 20 && userDefaults.bool(forKey: UserDefaultsKeys.badge36Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge36)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge36Shown.rawValue)
        }
        
        //11pm and 7am
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge37.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge37Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge37)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge37Shown.rawValue)
        }
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge38.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge38Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge38)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge38Shown.rawValue)
        }
        
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge39.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge39Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge39)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge39Shown.rawValue)
        }
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge40.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge40Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge40)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge40Shown.rawValue)
        }
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge41.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge41Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge41)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge41Shown.rawValue)
        }
        if(userDefaults.bool(forKey: UserDefaultsKeys.badge42.rawValue) == true && userDefaults.bool(forKey: UserDefaultsKeys.badge42Shown.rawValue) == false) {
            arrNewBadges.append(BadgeNumber.badge42)
            userDefaults.setValue(true, forKey: UserDefaultsKeys.badge42Shown.rawValue)
        }
        
        return arrNewBadges
    }
    
    private func presentQuiz(learnMode: Bool) {
        quizManager.startQuiz(learnMode: learnMode)
        activeFullScreen = .quiz
    }
    
    private func presentCategoryQuiz(learnMode: Bool) {
        quizManager.startCategoryQuiz(learnMode: learnMode)
        activeFullScreen = .quiz
    }
    
    private func startQuiz(ofType type: QuizType) {
        if !subscriptionManager.isSubscribed,
           [.missed, .bookmarked, .timed].contains(type) {
            activeFullScreen = .subscribe(limitReached: false)
        } else {
            if !subscriptionManager.isSubscribed,
               storageManager.freeLimitReached {
                activeFullScreen = .subscribe(limitReached: true)
            } else {
                Task.init {
                    await quizManager.fetchNewQuestions(forQuizType: type)
                    switch type {
                    case .timed:
                        presentQuiz(learnMode: false)
                    case .bookmarked, .missed:
                        presentQuiz(learnMode: true)
                    case .category:
                        showingLearnMode = true
                        isCategorySelection = true
                    default:
                        showingLearnMode = true
                    }
                }
            }
        }
    }
    
    private func startCategoryQuiz(ofType type: CategoryType) {
        if !subscriptionManager.isSubscribed,
           storageManager.freeLimitReached {
            activeFullScreen = .subscribe(limitReached: true)
        } else {
            Task.init {
                await quizManager.fetchNewCategoryQuestions(forCategoryType: type)
                switch type {
                default:
                    showingLearnMode = true
                    isCategorySelection = true
                }
            }
        }
    }
    
    private func showStatsScreen() {
        tabSelection = 1
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            tabSelection: .constant(0),
            cardState: UIStateModel(activeCard: 0, screenDrag: 0.0),
            categoryCardState: UIStateModel(activeCard: 0, screenDrag: 0.0)
        )
        .environmentObject(QuizManager())
        .environmentObject(StorageManager())
        .environmentObject(SubscriptionManager.shared)
        .environmentObject(AppDelegate())
    }
}

extension HomeView {
    enum ActiveFullScreen: Identifiable {
        case quiz
        case subscribe(limitReached: Bool)
        
        var id: Int {
            switch self {
            case .quiz:
                return 0
            case .subscribe:
                return 1
            }
        }
    }
}
