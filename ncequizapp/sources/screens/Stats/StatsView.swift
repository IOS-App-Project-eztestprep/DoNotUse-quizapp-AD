import SwiftUI

struct StatsView: View, Loggable {
    enum ActiveScreen: Identifiable {
        case quiz, subscribe
        var id: Int {
            hashValue
        }
    }

    @EnvironmentObject
    var quizManager: QuizManager
    
    @EnvironmentObject
    var storageManager: StorageManager
    
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    
    @Binding
    var tabSelection: Int
    private let userDefaults = UserDefaults.standard

    @State
    private var activeScreen: ActiveScreen?

    var body: some View {
        Group {
            ZStack {
                Color.lightestBlue
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                   
                    HStack {
                        StatsItemView(statItemType: .longestStreak(dayStreak: storageManager.longestStreak))
                        StatsItemView(statItemType: .badges(badgesEarned: storageManager.badgesUnlocked ))
                        StatsItemView(statItemType: .correct(correctAnswers: storageManager.correctAnswered))
                    }.padding(.top, 16)
      
                    VStack {
                        Group {
                            HStack {
                                getAllBadges()[0]
                                getAllBadges()[1]
                                getAllBadges()[2]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[3]
                                getAllBadges()[4]
                                getAllBadges()[5]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[6]
                                getAllBadges()[7]
                                getAllBadges()[8]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[9]
                                getAllBadges()[10]
                                getAllBadges()[11]
                            }.padding(.top, 12.0)
                        }
                        
                        Group {
                            HStack {
                                getAllBadges()[12]
                                getAllBadges()[13]
                                getAllBadges()[14]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[15]
                                getAllBadges()[16]
                                getAllBadges()[17]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[18]
                                getAllBadges()[19]
                                getAllBadges()[20]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[21]
                                getAllBadges()[22]
                                getAllBadges()[23]
                            }.padding(.top, 12.0)
                        }
                        
                        Group {
                            HStack {
                                getAllBadges()[24]
                                getAllBadges()[25]
                                getAllBadges()[26]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[27]
                                getAllBadges()[28]
                                getAllBadges()[29]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[30]
                                getAllBadges()[31]
                                getAllBadges()[32]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[33]
                                getAllBadges()[34]
                                getAllBadges()[35]
                            }.padding(.top, 12.0)
                        }
                        
                        Group {
                            HStack {
                                getAllBadges()[36]
                                getAllBadges()[37]
                                getAllBadges()[38]
                            }.padding(.top, 12.0)
                            
                            HStack {
                                getAllBadges()[39]
                                getAllBadges()[40]
                                getAllBadges()[41]
                            }.padding(.top, 12.0)
                            
                        }
                        
                        Group {
                            Spacer()
                        }.padding(.bottom, 60)
                    }.padding(.top, -16)
                }
            }
            
        }.fullScreenCover(item: $activeScreen, onDismiss: {
            activeScreen = nil
        }, content: { item in
            switch item {
            case .quiz:
                QuizView()
            case .subscribe:
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
    
    func formatMinuteSeconds(_ totalSeconds: Float) -> String {
        let seconds = totalSeconds.truncatingRemainder(dividingBy: 60).rounded(.toNearestOrAwayFromZero)
        let minutes = (totalSeconds/60).truncatingRemainder(dividingBy: 60).rounded(.toNearestOrAwayFromZero)
        
        return String(format:"%02.f:%02.f", minutes, seconds );
        
    }

    private func startQuiz(ofType type: QuizType) {
        if !subscriptionManager.isSubscribed {
            activeScreen = .subscribe
        } else {
            Task.init {
                await quizManager.fetchNewQuestions(forQuizType: type)
                quizManager.startQuiz(learnMode: true)
                activeScreen = .quiz
            }
        }
    }
    
    private func getAllBadges() -> [Badge] {
        [
            Badge(id: 1, badgeNumber: BadgeNumber.badge1, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge1.rawValue)),
            Badge(id: 2, badgeNumber: BadgeNumber.badge2, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge2.rawValue)),
            Badge(id: 3, badgeNumber: BadgeNumber.badge3, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge3.rawValue)),
            Badge(id: 4, badgeNumber: BadgeNumber.badge4, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge4.rawValue)),
            Badge(id: 5, badgeNumber: BadgeNumber.badge5, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge5.rawValue)),
            Badge(id: 6, badgeNumber: BadgeNumber.badge6, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge6.rawValue)),
            Badge(id: 7, badgeNumber: BadgeNumber.badge7, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge7.rawValue)),
            Badge(id: 8, badgeNumber: BadgeNumber.badge8, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge8.rawValue)),
            Badge(id: 9, badgeNumber: BadgeNumber.badge9, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge9.rawValue)),
            Badge(id: 10, badgeNumber: BadgeNumber.badge10, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge10.rawValue)),
            Badge(id: 11, badgeNumber: BadgeNumber.badge11, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge11.rawValue)),
            Badge(id: 12, badgeNumber: BadgeNumber.badge12, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge12.rawValue)),
            Badge(id: 13, badgeNumber: BadgeNumber.badge13, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge13.rawValue)),
            Badge(id: 14, badgeNumber: BadgeNumber.badge14, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge14.rawValue)),
            Badge(id: 15, badgeNumber: BadgeNumber.badge15, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge15.rawValue)),
            Badge(id: 16, badgeNumber: BadgeNumber.badge16, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge16.rawValue)),
            Badge(id: 17, badgeNumber: BadgeNumber.badge17, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge17.rawValue)),
            Badge(id: 18, badgeNumber: BadgeNumber.badge18, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge18.rawValue)),
            Badge(id: 19, badgeNumber: BadgeNumber.badge19, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge19.rawValue)),
            Badge(id: 20, badgeNumber: BadgeNumber.badge20, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge20.rawValue)),
            Badge(id: 21, badgeNumber: BadgeNumber.badge21, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge21.rawValue)),
            Badge(id: 22, badgeNumber: BadgeNumber.badge22, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge22.rawValue)),
            Badge(id: 23, badgeNumber: BadgeNumber.badge23, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge23.rawValue)),
            Badge(id: 24, badgeNumber: BadgeNumber.badge24, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge24.rawValue)),
            Badge(id: 25, badgeNumber: BadgeNumber.badge25, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge25.rawValue)),
            Badge(id: 26, badgeNumber: BadgeNumber.badge26, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge26.rawValue)),
            Badge(id: 27, badgeNumber: BadgeNumber.badge27, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge27.rawValue)),
            Badge(id: 28, badgeNumber: BadgeNumber.badge28, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge28.rawValue)),
            Badge(id: 29, badgeNumber: BadgeNumber.badge29, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge29.rawValue)),
            Badge(id: 30, badgeNumber: BadgeNumber.badge30, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge30.rawValue)),
            Badge(id: 31, badgeNumber: BadgeNumber.badge31, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge31.rawValue)),
            Badge(id: 32, badgeNumber: BadgeNumber.badge32, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge32.rawValue)),
            Badge(id: 33, badgeNumber: BadgeNumber.badge33, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge33.rawValue)),
            Badge(id: 34, badgeNumber: BadgeNumber.badge34, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge34.rawValue)),
            Badge(id: 35, badgeNumber: BadgeNumber.badge35, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge35.rawValue)),
            Badge(id: 36, badgeNumber: BadgeNumber.badge36, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge36.rawValue)),
            Badge(id: 37, badgeNumber: BadgeNumber.badge37, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge37.rawValue)),
            Badge(id: 38, badgeNumber: BadgeNumber.badge38, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge38.rawValue)),
            Badge(id: 39, badgeNumber: BadgeNumber.badge39, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge39.rawValue)),
            Badge(id: 40, badgeNumber: BadgeNumber.badge40, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge40.rawValue)),
            Badge(id: 41, badgeNumber: BadgeNumber.badge41, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge41.rawValue)),
            Badge(id: 42, badgeNumber: BadgeNumber.badge42, isUnlocked: UserDefaults.standard.bool(forKey: UserDefaultsKeys.badge42.rawValue))
        ]
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(tabSelection: .constant(2))
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}
