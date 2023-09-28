import MessageUI
import StoreKit
import SwiftUI

class SettingsConstants {
    static let PADDING_FIX_TOP = -24.0
    static let PADDING_FIX_LEFT = -16.0
    static let PADDING_BOTTOM = 4.0
    static let TEXT_SIZE_SECTION_HEADER = 11.0
    static let TEXT_SIZE_SECTION_HEADER_IPAD = (TEXT_SIZE_SECTION_HEADER / 2) * 3
}

struct SettingsView: View, Loggable {
    @Binding
    var tabSelection: Int
    @EnvironmentObject
    private var delegate: AppDelegate
    @EnvironmentObject
    var storageManager: StorageManager
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    @Environment(\.presentationMode)
    var presentationMode
    @ObservedObject
    var userSettings: UserSettings = StorageManager.shared
        .userSettings
    @State
    var activeBottomSheet: ActiveBottomSheet?
    @State
    var activeSafaryView: ActiveSafaryView?
    @State
    var showingAlert: Bool = false
    @State
    var result: Result<MFMailComposeResult, Error>? = nil

    var body: some View {
        ZStack {
            Color.lightestBlue
                .ignoresSafeArea()
            List {
                if !subscriptionManager.isSubscribed {
                    Section {
                        Button {
                            activeSafaryView = .subscribe
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Go Premium")
                                        .font(Font.nunito(.regular, size: 12))
                                        .foregroundColor(Color.white)
                                    Text("Unlock All Content")
                                        .font(Font.nunito(.bold, size: 22))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                                Spacer()
                                Image("ic_crown")
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }.frame(minHeight: 50)
                        }

                    }.listRowBackground(Color.purpleRegular)
                    Section {
                        Button {
                            Task {
                                await subscriptionManager.restorePurchase()
                            }
                        } label: {
                            HStack {
                                Text("Restore Purchase")
                                    .foregroundColor(.text)
                                    .font(Font.nunito(.medium, size: 16))
                                Spacer()
                                Image("ic_arrow_right")
                                    .renderingMode(.template)
                                    .foregroundColor(.answerBackgroundBlue)
                            }.frame(minHeight: 40)
                        }
                    }
                } else {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Current Subscription")
                                .foregroundColor(.buttonGray)
                                .font(Font.nunito(.regular, size: 12))
                            Text("Active")
                                .font(Font.nunito(.bold, size: 16))
                                .foregroundColor(.text)
                        }.frame(minHeight: 40)
                    }
                }
                Section {
                    Button {
                        activeBottomSheet = .difficulty
                        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.badge39.rawValue)
                    } label: {
                        HStack {
                            Text("Difficulty")
                                .foregroundColor(.text)
                                .font(Font.nunito(.bold, size: 16))

                            Spacer()
                            Text((
                                storageManager.userSettings.level?
                                    .title ?? "Easy"
                            ).capitalized)
                            .font(Font.nunito(.regular, size: 14))
                                .foregroundColor(.buttonGray)
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 40)
                    }
                    Button {
                        activeBottomSheet = .dailyGoal
                    } label: {
                        HStack {
                            Text("Daily Goal")
                                .foregroundColor(.text)
                                .font(Font.nunito(.bold, size: 16))

                            Spacer()
                            Text(
                                "\(storageManager.userSettings.numberOfQuestions?.numberOfQuestions ?? 20) questions"
                                    .capitalized
                            )
                            .font(Font.nunito(.regular, size: 14))
                            .foregroundColor(.buttonGray)
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 40)
                    }
                    Button {
                        activeBottomSheet = .scoreGoal
                    } label: {
                        HStack {
                            Text("Score Goal")
                                .foregroundColor(.text)
                                .font(Font.nunito(.bold, size: 16))

                            Spacer()
                            Text(
                                "\(storageManager.userSettings.score?.scorePercentage ?? 80)%"
                                    .capitalized
                            )
                            .font(Font.nunito(.regular, size: 14))
                            .foregroundColor(.buttonGray)
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 40)
                    }

                } header: {
                    /*
                    Text("Study settings".uppercased())
                        .font(Font.nunito(.bold, size: UIScreen.iPad ? SettingsConstants.TEXT_SIZE_SECTION_HEADER_IPAD : SettingsConstants.TEXT_SIZE_SECTION_HEADER))
                        .foregroundColor(.text)
                        .padding(EdgeInsets.init(top: SettingsConstants.PADDING_FIX_TOP, leading: SettingsConstants.PADDING_FIX_LEFT, bottom: SettingsConstants.PADDING_BOTTOM, trailing: 0.0))
                     */
                    ScreenTitle(title: "Study settings")
                        .padding(EdgeInsets.init(top: SettingsConstants.PADDING_FIX_TOP, leading: SettingsConstants.PADDING_FIX_LEFT, bottom: SettingsConstants.PADDING_BOTTOM, trailing: 0.0))
                }
                
                Section {
                    Button {
                        rateButtonTapped()
                    } label: {
                        HStack(spacing: 20) {
                            Image("ic_star")
                            VStack(alignment: .leading) {
                                Text("Rate us")
                                    .font(Font.nunito(.bold, size: 16))
                                    .foregroundColor(.text)
                                Text("Your rating helps us improve!")
                                    .foregroundColor(.buttonGray)
                                    .font(Font.nunito(.regular, size: 14))
                            }
                            Spacer()
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 50)
                    }
                    
                    Button {
                        shareButtonTapped()
                    } label: {
                        HStack(spacing: 20) {
                            Image("ic_plain")
                            VStack(alignment: .leading) {
                                Text("Share with a Friend")
                                    .font(Font.nunito(.bold, size: 16))
                                    .foregroundColor(.text)
                                Text("Link to App Store")
                                    .foregroundColor(.buttonGray)
                                    .font(Font.nunito(.regular, size: 14))
                            }
                            Spacer()
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 50)
                    }
                } header: {
                    /*
                    Text("Community".uppercased())
                        .font(Font.nunito(.bold, size: UIScreen.iPad ? SettingsConstants.TEXT_SIZE_SECTION_HEADER_IPAD : SettingsConstants.TEXT_SIZE_SECTION_HEADER))
                        .foregroundColor(.text)
                        .padding(EdgeInsets.init(top: SettingsConstants.PADDING_FIX_TOP, leading: SettingsConstants.PADDING_FIX_LEFT, bottom: SettingsConstants.PADDING_BOTTOM, trailing: 0.0))
                     */
                    ScreenTitle(title: "Community")
                        .padding(EdgeInsets.init(top: SettingsConstants.PADDING_FIX_TOP, leading: SettingsConstants.PADDING_FIX_LEFT, bottom: SettingsConstants.PADDING_BOTTOM, trailing: 0.0))
                }
                Section {
                    Button {
                        showingAlert = true
                    } label: {
                        Text("Reset Progress")
                            .foregroundColor(.text)
                            .font(Font.nunito(.bold, size: 16))
                            .frame(minHeight: 50)
                    }

                } header: {
                    ScreenTitle(title: "Exam")
                        .padding(EdgeInsets.init(top: SettingsConstants.PADDING_FIX_TOP, leading: SettingsConstants.PADDING_FIX_LEFT, bottom: SettingsConstants.PADDING_BOTTOM, trailing: 0.0))
                }
                
                
                Section {
                    Button {
                        activeSafaryView = .contactUs
                    } label: {
                        HStack {
                            Text("Contact Us")
                                .foregroundColor(.text)
                                .font(Font.nunito(.bold, size: 16))
                            Spacer()
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 40)
                    }
                    Button {
                        activeSafaryView = .terms
                    } label: {
                        HStack {
                            Text("Terms of Use")
                                .foregroundColor(.text)
                                .font(Font.nunito(.bold, size: 16))
                            Spacer()
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 40)
                    }
                    Button {
                        activeSafaryView = .privacy
                    } label: {
                        HStack {
                            Text("Privacy Policy")
                                .foregroundColor(.text)
                                .font(Font.nunito(.bold, size: 16))

                            Spacer()
                            Image("ic_arrow_right")
                                .renderingMode(.template)
                                .foregroundColor(.answerBackgroundBlue)
                        }.frame(minHeight: 40)
                    }

                } header: {
                    ScreenTitle(title: "Legal")
                        .padding(EdgeInsets.init(top: SettingsConstants.PADDING_FIX_TOP, leading: SettingsConstants.PADDING_FIX_LEFT, bottom: SettingsConstants.PADDING_BOTTOM, trailing: 0.0))
                }
                Section {
                    EmptyView()
                }
            }.listStyle(.insetGrouped)
                .preferredColorScheme(.light)
                .fullScreenCover(item: $activeSafaryView, onDismiss: {
                    activeSafaryView = nil
                }, content: { item in
                    switch item {
                    case .subscribe:
                        if StorageManager.shared.shouldShowPromotionalOffer() {
                            IntroductoryOfferView()
                        } else {
                            SubscriptionViewv2()
                        }
                    case .mail:
                        MailView(
                            result: self.$result,
                            recipients: [
                                "support@eztestprep.com",
                            ],
                            subscriberId: storageManager.subscriberId
                        )
                    default:
                        SFSafariViewWrapper(url: item.url)
                    }
                })
                .sheet(item: $activeBottomSheet, onDismiss: {
                    activeBottomSheet = nil
                }) { item in
                    ZStack {
                        Color.white
                            .ignoresSafeArea()
                        BottomSheet {
                            switch item {
                            case .dailyGoal:
                                DailyGoalBottomSheet(
                                    selectedOption: userSettings
                                        .numberOfQuestions
                                ) { selectedOption in
                                    storageManager
                                        .updateNumberOfQuestions(selectedOption)
                                    activeBottomSheet = nil
                                }
                            case .scoreGoal:
                                ScoreGoalBottomSheet(
                                    selectedOption: userSettings
                                        .score
                                ) { selectedOption in
                                    storageManager.updateGoalScore(selectedOption)
                                    UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.badge40.rawValue)
                                    storageManager.updateBadgesAndTheirCount()
                                    activeBottomSheet = nil
                                }
                            case .difficulty:
                                DifficultyBottomSheet(
                                    selectedOption: userSettings
                                        .level
                                ) { selectedOption in
                                    storageManager.updateLevel(selectedOption)
                                    UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.badge39.rawValue)
                                    storageManager.updateBadgesAndTheirCount()
                                    activeBottomSheet = nil
                                }
                            }
                        }
                    }
                }.alert("Warning", isPresented: $showingAlert) {
                    Button("Reset", role: .destructive) {
                        showingAlert = false
                        resetDefaults()
                        storageManager.resetProgress()
                    }
                } message: {
                    Text(
                        "Are you sure you want to reset your progress? All progress data will be lost."
                    )
                }
                .onAppear {
                    logScreen(self)
                }
        }
    }

    func shareButtonTapped() {
        log("Share button tapped")
        guard let url =
            URL(string: "itms-apps://itunes.apple.com/app/id1664527804")
        else {
            return
        }
        let activityController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        UIApplication.shared.windows.first?.rootViewController!.present(
            activityController,
            animated: true,
            completion: nil
        )
        
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.badge42.rawValue)
    }
    
    func resetDefaults() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge1.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge2.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge3.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge4.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge5.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge6.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge7.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge8.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge9.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge10.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge11.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge12.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge13.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge14.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge15.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge16.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge17.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge18.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge19.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge20.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge21.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge22.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge23.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge24.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge25.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge26.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge27.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge28.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge29.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge30.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge31.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge32.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge33.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge34.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge35.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge36.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge37.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge38.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge39.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge40.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge41.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge42.rawValue)
        
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge1Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge2Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge3Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge4Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge5Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge6Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge7Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge8Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge9Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge10Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge11Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge12Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge13Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge14Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge15Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge16Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge17Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge18Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge19Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge20Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge21Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge22Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge23Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge24Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge25Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge26Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge27Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge28Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge29Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge30Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge31Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge32Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge33Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge34Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge35Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge36Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge37Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge38Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge39Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge40Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge41Shown.rawValue)
        userDefaults.setValue(false, forKey: UserDefaultsKeys.badge42Shown.rawValue)
        
        userDefaults.setValue(0, forKey: UserDefaultsKeys.scored100Percent.rawValue)
        userDefaults.setValue(0, forKey: UserDefaultsKeys.scored90PercentOnExamSimulator.rawValue)
        userDefaults.setValue(0, forKey: UserDefaultsKeys.scored100PercentOnExamSimulator.rawValue)
        userDefaults.setValue(0, forKey: UserDefaultsKeys.badgesUnlocked.rawValue)
        
        storageManager.badgesUnlocked = 0
    }

    func rateButtonTapped() {
        log("Rate button tapped")
        guard let url =
            URL(
                string: "itms-apps://itunes.apple.com/app/id1664527804?mt=8&action=write-review"
            )
        else {
            return
        }
        UIApplication.shared.open(url)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tabSelection: .constant(2))
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}
