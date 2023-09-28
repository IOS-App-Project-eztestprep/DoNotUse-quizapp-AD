//


import SwiftUI

class GetStartedViewConstants {
    static let TEXT_SIZE_TITLE = 32.0
    static let TEXT_SIZE_TITLE_IPAD = (TEXT_SIZE_TITLE / 2) * 2.5
    
    static let TEXT_SIZE_SUBTITLE = 20.0
    static let TEXT_SIZE_SUBTITLE_IPAD = (TEXT_SIZE_SUBTITLE / 2) * 2.5
}

struct GetStartedView: View, Loggable {
    @EnvironmentObject
    var storageManager: StorageManager
    
    @State
    var onboardingPresent: Bool = false

    func getTitleText() -> String {
        let title = UIScreen.iPad ? "National\nCounselor\nExam\n" : "National\nCounselor\nExam"
        return title
    }
    
    func getSubtitleText() -> String {
        let title = UIScreen.iPad ? "Personalized study plan \nand daily challenges" : "Quizzes, practice test, personalized\nstudy plans, and daily challenges."
        return title
    }
    
    func getTitleTextSize() -> CGFloat {
        if UIScreen.iPad {
            return GetStartedViewConstants.TEXT_SIZE_TITLE_IPAD
        } else {
            return GetStartedViewConstants.TEXT_SIZE_TITLE
        }
    }
    
    func getSubTitleTextSize() -> CGFloat {
        if UIScreen.iPad {
            return GetStartedViewConstants.TEXT_SIZE_SUBTITLE_IPAD
        } else {
            return GetStartedViewConstants.TEXT_SIZE_SUBTITLE
        }
    }
    
    func getTopPaddingForLabelsForiPhone() -> CGFloat {
        if UIScreen.isProMaxIphone {
            return -48
        } else if UIScreen.isSmallScreenIphone {
            return -78
        } else {
            return -58
        }
    }
    
    var body: some View {
        if !onboardingPresent {
                ZStack {
                    Color.lightestBlue
                        .ignoresSafeArea()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center, spacing: 20) {
                            VStack {
                                Text("STUDY EASIER")
                                    .font(Font.nunito(.bold, size: UIScreen.iPad ? 42 : 30))
                                    .foregroundColor(Color.lightTeal)
                                    .padding(.top, UIScreen.isSmallScreenIphone ? -20 : 0)
                                
                                Text("Cram anywhere, anytime")
                                    .font(Font.nunito(.regular, size: UIScreen.iPad ? 36 : 24))
                                    .foregroundColor(Color.text)
                            }.padding(.top, -66)
                            
                            Image(UIScreen.iPad ? "img_getstarted_ipad" : "img_getstarted")
                                .padding(.top, UIScreen.isSmallScreenIphone ? -36 : -10)
                            
                            VStack (alignment: .leading, spacing: 8){
                                SubscriptionInfoRowv2(text: "Remove Exam Day Stress")
                                SubscriptionInfoRowv2(text: "Customize Your Study Goals")
                                SubscriptionInfoRowv2(text: "Study In Your Spare Time")
                                SubscriptionInfoRowv2(text: "Offline, Anywhere, Anytime ")
                            }
                            .padding(.top, UIScreen.isSmallScreenIphone ? -20 : -10)
                            
                            Text(getTitleText())
                                .foregroundColor(Color.purpleRegular)
                                .font(Font.nunito(.bold, size: getTitleTextSize()))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.01)
                                .padding(.top, UIScreen.iPad ? 14 : 0)
                                .padding(.top, UIScreen.isSmallScreenIphone ? -20 : -10)
                            
                            Button {
                                onboardingPresent.toggle()
                            } label: {
                                RoundedButton(text: "Get Started", isSelectable: true)
                                    .frame(maxWidth: 350.0)
                            }
                        }
                        .padding(EdgeInsets(
                            top: 100,
                            leading: 30,
                            bottom: 20,
                            trailing: 30
                        ))
                }.onAppear {
                    logScreen(self)
                }
            }
        } else {
            OnboardingView(onboardingPresented: $onboardingPresent)
                .environmentObject(storageManager)
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView().environmentObject(StorageManager())
    }
}

