import SwiftUI

struct QuizListView: View, Loggable {
    @EnvironmentObject
    var quizManager: QuizManager
    
    @EnvironmentObject
    var storageManager: StorageManager
    
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    
    @State
    private var activeFullScreen: ActiveFullScreen?
    
    @State
    var showingLearnMode = false
    
    @Binding
    var tabSelection: Int
    
    @State
    var isCategorySelection = false
    
    var categoryIndex: Int = 0
    fileprivate let multiplierForHalfHorizontalCell = 0.43
    fileprivate let multiplierForHorizontalCell = 0.9
    fileprivate let spacingBetweenListItem = 14.0
    
    
    var body: some View {
        ZStack {
            Color.lightestBlue
                .ignoresSafeArea()
                .sheet(isPresented: $showingLearnMode, onDismiss: {
                    showingLearnMode = false
                }) {
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        BottomSheet {
                            if UIScreen.iPad {
                                QuizModeViewIpad { quizMode in
                                    if isCategorySelection {
                                        isCategorySelection = false
                                        presentCategoryQuiz(learnMode: quizMode == .learn)
                                    } else {
                                        presentQuiz(learnMode: quizMode == .learn)
                                    }
                                }
                            }else {
                                QuizModeView { quizMode in
                                    if isCategorySelection {
                                        isCategorySelection = false
                                        presentCategoryQuiz(learnMode: quizMode == .learn)
                                    } else {
                                        presentQuiz(learnMode: quizMode == .learn)
                                    }
                                }
                            }
                        }
                    }
                }
            VStack {
                ZStack {
                    ScreenTitle(title: "YOUR QUIZZES")
                        .padding(.leading, 16)
                    if !subscriptionManager.isSubscribed {
                        HStack {
                            Spacer()
                            UnlockView(
                                icon: "ic_crown",
                                text: "UNLOCK",
                                fillColor: .goalGreen
                            ) {
                                activeFullScreen =
                                    .subscribe(limitReached: false)
                            }
                        }.padding(.trailing, 12)
                    }
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 12) {
                        
                        HStack(spacing: spacingBetweenListItem){
                            horizontalQuizCell(item: getQuizCards()[0], multiplier: multiplierForHalfHorizontalCell)
                            horizontalQuizCell(item: getQuizCards()[1], multiplier: multiplierForHalfHorizontalCell)
                        }
                        HStack(spacing: spacingBetweenListItem){
                            horizontalQuizCell(item: getQuizCards()[2], multiplier: multiplierForHalfHorizontalCell)
                            horizontalQuizCell(item: getQuizCards()[3], multiplier: multiplierForHalfHorizontalCell)
                        }
                        horizontalQuizCell(item: getQuizCards()[4], multiplier: multiplierForHorizontalCell)
                        
                        ScreenTitle(title: "CATEGORIES")
                        HStack(spacing: spacingBetweenListItem){
                            horizontalCategoryCell(item: getCategoryCards()[0], multiplier: multiplierForHalfHorizontalCell)
                            horizontalCategoryCell(item: getCategoryCards()[1], multiplier: multiplierForHalfHorizontalCell)
                        }
                        HStack(spacing: spacingBetweenListItem){
                            horizontalCategoryCell(item: getCategoryCards()[2], multiplier: multiplierForHalfHorizontalCell)
                            horizontalCategoryCell(item: getCategoryCards()[3], multiplier: multiplierForHalfHorizontalCell)
                        }
                        HStack(spacing: spacingBetweenListItem){
                            horizontalCategoryCell(item: getCategoryCards()[4], multiplier: multiplierForHalfHorizontalCell)
                            horizontalCategoryCell(item: getCategoryCards()[5], multiplier: multiplierForHalfHorizontalCell)
                        }
                        HStack(spacing: spacingBetweenListItem){
                            horizontalCategoryCell(item: getCategoryCards()[6], multiplier: multiplierForHalfHorizontalCell)
                            horizontalCategoryCell(item: getCategoryCards()[7], multiplier: multiplierForHalfHorizontalCell)
                        }
                        
                        
                    }.padding(EdgeInsets(top: 0.0, leading: 16.0, bottom: 16.0, trailing: 16.0))
                    
                }
            }
            .padding(EdgeInsets(
                top: 60,
                leading: 20,
                bottom: 100,
                trailing: 20
            ))
            .ignoresSafeArea()
            
        }.fullScreenCover(item: $activeFullScreen, onDismiss: {
            activeFullScreen = nil
        }, content: { item in
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
        })
        .onAppear {
            logScreen(self)
        }
    }
    
    
    private func getQuizCards() -> [Card] {
        [
            Card(
                id: 2,
                quizType: .random,
                action: { startQuiz(ofType: .random) },
                counterValue: storageManager.allQuestions
                    .filter { $0.choosenAnswer != nil }.count,
                isQuizList: true
            ),
            
            Card(
                id: 4,
                quizType: .daily,
                action: { startQuiz(ofType: .daily) },
                isEnabled: storageManager.dailyQuizAvailable,
                counterValue: storageManager.dailyQuizzesCompleted,
                isQuizList: true
            ),
            Card(
                id: 0,
                quizType: .missed,
                action: { startQuiz(ofType: .missed) },
                counterValue: storageManager.allQuestions
                    .filter { !($0.choosenAnswer?.correct ?? true) }.count,
                isQuizList: true,
                isUnlocked: subscriptionManager.isSubscribed
            ),
            Card(
                id: 1,
                quizType: .bookmarked,
                action: { startQuiz(ofType: .bookmarked) },
                isQuizList: true,
                isUnlocked: subscriptionManager.isSubscribed
            ),
            Card(
                id: 3,
                quizType: .timed,
                action: { startQuiz(ofType: .timed) },
                counterValue: storageManager.timedQuizzesCompleted,
                isQuizList: true,
                isUnlocked: subscriptionManager.isSubscribed
            )
        ]
    }
    
    private func getCategoryCards() -> [CategoryCard] {
        [
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
        ]
    }
    
    fileprivate func horizontalQuizCell(item: Card, multiplier: Double) -> some View{
        return VStack(alignment: .center) {
            
            Text("\(item.quizType.title)")
                .font(Font.nunito(.bold, size: UIScreen.iPad ? 30 : 21))
                .fontWeight(.bold)
                .foregroundColor(.text)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
            
            if item.isUnlocked {
                Text(item.subtitle)
                    .font(Font.nunito(.medium, size: UIScreen.iPad ? 16 : 10))
                    .fontWeight(.medium)
                    .foregroundColor(Color.text)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
            }
            
            item.quizType.icon?
                .resizable()
                .foregroundColor(.white)
                .frame(
                    width: UIScreen.iPad ? 40 : 25,
                    height: UIScreen.iPad ? 40 : 25
                )
            
        }.padding(4.0)
        .frame(
            width: UIScreen.screenWidth*multiplier,
            height: 130
        )
        .foregroundColor(Color.white)
        .background(
            item.secondaryColor ? Color.quizSelectedColor : Color.lightBlue
        )
        .cornerRadius(20)
        .shadow(color: .medGray, radius: 4, x: 0, y: 4)
        .onTapGesture {
            if item.isEnabled {
                item.action?()
            }
        }
    }
    
    fileprivate func horizontalCategoryCell(item: CategoryCard, multiplier: Double) -> some View{
        return VStack(alignment: .center, spacing: 0) {
            Text("\(item.categoryType.title)")
                .font(Font.nunito(.bold, size: UIScreen.iPad ? 30 : 21))
                .fontWeight(.bold)
                .foregroundColor(.text)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
        }.padding(4.0)
        .frame(
            width: UIScreen.screenWidth*multiplier,
            height: 130
        )
        .foregroundColor(Color.white)
        .background(Color.backgroundCategory)
        .cornerRadius(20)
        .shadow(color: .medGray, radius: 4, x: 0, y: 4)
        .onTapGesture {
            if item.isEnabled {
                item.action?()
            }
        }
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
                        isCategorySelection = true
                        showingLearnMode = true
                    default:
                        showingLearnMode = true
                    }
                }
            }
        }
    }
    
    private func startCategoryQuiz(ofType type: CategoryType) {
        Task.init {
            if !subscriptionManager.isSubscribed,
               storageManager.freeLimitReached {
                activeFullScreen = .subscribe(limitReached: true)
            } else {
                await quizManager.fetchNewCategoryQuestions(forCategoryType: type)
                switch type {
                default:
                    showingLearnMode = true
                    isCategorySelection = true
                }
            }
        }
    }
}

struct QuizListView_Previews: PreviewProvider {
    static var previews: some View {
        QuizListView(tabSelection: .constant(1))
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}

struct CategoryBox: View {
    var title: String
    var action: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                Text(title)
                    .font(Font.nunito(.bold, size: UIScreen.iPad ? 30 : 20))
                    .fontWeight(.bold)
                    .foregroundColor(.text)
                    .lineLimit(nil)
                Spacer()
            }.padding()
        }.padding()
            .frame(
                width: UIScreen.screenWidth - 40,
                height: 130
            )
            .foregroundColor(Color.white)
            .background(Color.backgroundCategory)
            .cornerRadius(20)
            .shadow(color: .medGray, radius: 4, x: 0, y: 4)
            .onTapGesture {
                action()
            }
    }
}

extension QuizListView {
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
