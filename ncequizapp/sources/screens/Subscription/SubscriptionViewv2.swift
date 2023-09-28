import SwiftUI

struct SubscriptionViewv2: View, Loggable {
    @EnvironmentObject
    var storageManager: StorageManager
    
    @EnvironmentObject
    var subscriptionManager: SubscriptionManager
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @State
    var isAlertPresented: Bool = false
    
    @State
    var result: SubscriptionManager.SubscriptionResult?
    
    var isOnboarding: Bool = false
    
    @StateObject
    var userSettings = StorageManager.shared.userSettings
    
    let minWidth = UIScreen.screenWidth / 2.0 - 1.5 * (UIScreen.iPad ? 120 : 20)
    let minHeight = 230.0
    
    @State private var isLoading = false
    @State private var showAnimate = false
    @State private var is6MonthSelected = true
    
    func getLeadingPaddingForSaveTag() -> Double {
        var padding = UIScreen.iPad ? 40.0 : 32.0
        
        if(UIScreen.screenWidth == 1024) {
            padding = 115
        } else if(UIScreen.screenWidth == 744) {
            padding = 10
        }  else if(UIScreen.screenWidth == 414) {
            padding = 54
        }
        
        return padding
    }
    
    func getTrailingPaddingForSaveTag() -> Double {
        var padding = -32.0
                
        if(UIScreen.screenWidth == 820) {
            padding = -84.0
        } else if(UIScreen.screenWidth == 834) {
            padding = -92.0
        } else if(UIScreen.screenWidth == 1024) {
            padding = -115
        } else if UIScreen.iPad {
            padding = -76.0
        } else if UIScreen.isSmallScreenIphone {
            padding = -20.0
        } else if UIScreen.isProMaxIphone {
            padding = -48.0
        }
        
        return padding
    }
    
    var body: some View {
        ZStack {
            Color.lightestBlue.ignoresSafeArea()
            ScrollView{
                VStack(spacing: 20) {
                    
                    Text("STUDY EASIER")
                        .font(Font.nunito(.bold, size: UIScreen.iPad ? 42 : 30))
                        .foregroundColor(Color.lightTeal)
                        .padding(EdgeInsets(top: 30.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    
                    Text("Cram anywhere, anytime")
                        .font(Font.nunito(.regular, size: UIScreen.iPad ? 36 : 24))
                        .foregroundColor(Color.text)
                        .padding(EdgeInsets(top: -20.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    
                    // 1 Month and 6 Months Buttons Starts
                    // ===================================
                    HStack{
                        Button {
                            is6MonthSelected = false
                            subscribe()
                        } label: {
                            VStack{
                                VStack{
                                    Text("****1 Month****")
                                        .font(.nunito(.bold, size: 25))
                                        .fontWeight(.bold)
                                        .foregroundColor(.purpleRegular)
                                        .padding(EdgeInsets(top: UIScreen.iPad ? 32.0 : 18.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                    Text("**Cancel anytime**")
                                        .font(.nunito(.regular, size: 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 3, trailing: 0))
                                    VStack {}.frame(height: 24)
                                    Text("**\(subscriptionManager.monthlyPrice())**")
                                        .font(.nunito(.regular, size: UIScreen.iPad ? 20 : 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 16, leading: 0, bottom: 16, trailing: 0))
                                }
                                .padding(16)
                                .frame(alignment: .center)
                                .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight )
                                .background(Color.white)
                                
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purpleRegular, lineWidth: (is6MonthSelected) ? 1 : 3)
                            )
                        }.disabled(isLoading)
                        Spacer()
                        Button {
                            is6MonthSelected = true
                            subscribe()
                        } label: {
                            VStack{
                                VStack{
                                    ZStack {
                                        Image("save_tag")
                                        Text("\(subscriptionManager.getSavings())")
                                            .font(.nunito(.bold, size: 16))
                                            .foregroundColor(.white)
                                    }.padding(EdgeInsets(top: UIScreen.iPad ? 16.0 : 0.0, leading: getLeadingPaddingForSaveTag(), bottom: 0.0, trailing: getTrailingPaddingForSaveTag()))
                                    
                                    Text("****6 Months****")
                                        .font(.nunito(.bold, size: 25))
                                        .fontWeight(.bold)
                                        .foregroundColor(.purpleRegular)
                                        .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                    Text("**Cancel Anytime**")
                                        .font(.nunito(.regular, size: 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    VStack {}.frame(height: 32)
                                    VStack {
                                        Text("**\(subscriptionManager.halfYearlyPrice())**")
                                            .font(.nunito(.regular, size: UIScreen.iPad ? 20 : 16))
                                            .foregroundColor(.text)
                                            .padding(EdgeInsets.init(top: 5, leading: 0, bottom: -2.0, trailing: 0))
                                        Text (subscriptionManager.halfYearlyPriceAsMonthly())
                                            .font(.nunito(.regular, size: UIScreen.iPad ? 14 : 10))
                                            .foregroundColor(.buttonGray)
                                            .padding(EdgeInsets(top: 0.0, leading: 8.0, bottom: 16.0, trailing: 8.0))
                                    }
                                }
                                .frame(alignment: .center)
                                .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight )
                                .background(Color.white)
                            }.overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purpleRegular, lineWidth: (is6MonthSelected) ? 3 : 1)
                            )
                        }.disabled(isLoading)
                    }
                    .frame(maxWidth: 350.0)
                    // ===================================
                    
                    Text("Unlock All Content")
                        .font(Font.nunito(.medium, size: UIScreen.iPad ? 33 : 23))
                        .fontWeight(.medium)
                        .fontWeight(.regular)
                        .foregroundColor(.text)
                    VStack(alignment: .leading, spacing: 10) {
                        Group {
                            SubscriptionInfoRowv2(text: "1100+ Exam-Style Questions")
                            SubscriptionInfoRowv2(text: "Comprehensive Explanations")
                            SubscriptionInfoRowv2(text: "Bookmark & Review Questions")
                            SubscriptionInfoRowv2(text: "Timed Exam Simulator")
                        }
                    }.padding(.horizontal, UIScreen.iPad ? 100 : 20)
                    
                    
                    Group {
                        ReviewRow(reviewText: "\"Life saver! Beautiful interface and easy to use.\"", reviewer: "Stella, LPCC")

                        RoundedButtonWithAction(text: "Unlock All Content", isSelectable: true) {
                            subscribe()
                        }.frame(width: UIScreen.iPad ? 480.0: 320.0)
                        
                        Text("Not sure?")
                            .font(Font.nunito(.regular, size: UIScreen.iPad ? 18 : 14))
                            .foregroundColor(Color.grayRegular)
                            .padding(EdgeInsets(top: 60.0, leading: 0.0, bottom: -4.0, trailing: 0.0))
                        //                        if isOnboarding {
                        VStack {
                            Button {
                                userSettings.isCompleted = true
                                userSettings.storeToUserDefaults()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("TRY IT FREE FIRST")
                                    .font(Font.nunito(.bold, size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.buttonGray)
                            }
                            .disabled(isLoading)
                            .padding(EdgeInsets.init(top: 12, leading: 26, bottom: 12, trailing: 26))
                        }.overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.purpleRegular, lineWidth: 1)
                        )
                        //                        }
                        Text("Research shows breaking up study sessions into smaller, more frequent intervals increases retention rate and speed. ")
                            .multilineTextAlignment(.center)
                            .lineLimit(6)
                            .foregroundColor(.lightTeal)
                            .font(Font.nunito(.italic, size: UIScreen.iPad ? 30 : 20))
                            .padding(EdgeInsets(top: 0.0, leading: 52.0, bottom: 0.0, trailing: 52.0))
                        
                        Group {
                            ReviewRow(reviewText: "\"Great for studying on the go! I can study while my baby naps.\"", reviewer: "Yanna, New Mom")
                            ReviewRow(reviewText: "\"I love how I can choose the different levels of intensity.\"", reviewer: "Josh, LPCC")
                            ReviewRow(reviewText: "\"Finally feel like I can measure my progress.\"", reviewer: "Lauren, Just Graduated")
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Group {
                            SubscriptionInfoRowv2(text: "Personalize Your Study Plan")
                            SubscriptionInfoRowv2(text: "Track Your Daily Stats & Progress")
                            SubscriptionInfoRowv2(text: "Study Offline Anywhere")
                            SubscriptionInfoRowv2(text: "Focus on Difficult Subjects")
                            SubscriptionInfoRowv2(text: "Study Reminders & Achievements")
                        }
                    }
                    
                    RoundedButtonWithAction(text: "Unlock All Content", isSelectable: true) {
                        subscribe()
                    }.frame(width: UIScreen.iPad ? 480.0: 320.0)
                    
                    Divider()
                    
                    Group {
                        Button {
                            Task {
                                isLoading.toggle()
                                showAnimate.toggle()
                                await subscriptionManager.restorePurchase()
                                showAnimate.toggle()
                                isLoading.toggle()
                                isAlertPresented.toggle()
                            }
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Restore Purchase")
                                .font(Font.nunito(.bold, size: UIScreen.iPad ? 18 : 12))
                                .fontWeight(.bold)
                                .underline()
                                .foregroundColor(Color.grayRegular)
                        }.disabled(isLoading)
                        
                        Text("**[Terms & Conditions](https://www.eztestprep.com/terms-of-use)** and **[Privacy Policy](https://www.eztestprep.com/privacy-policy)**.")
                            .font(Font.nunito(.regular, size: UIScreen.iPad ? 18 : 12))
                            .foregroundColor(Color.grayRegular)
                            .tint(Color.grayRegular)
                            .padding(EdgeInsets.init(top: -16.0, leading: 0.0, bottom:    0.0, trailing: 0.0))
                    }
                }.alert(result?.title ?? "Whoops", isPresented: $isAlertPresented) {
                    Button(
                        "Okay",
                        role: .cancel
                    ) {
                        result = nil
                        if subscriptionManager.isSubscribed {
                            userSettings.isCompleted = true
                            userSettings.storeToUserDefaults()
                        }
                        isAlertPresented.toggle()
                        isLoading = false
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text(result?.message ?? "An unexpected error happened.")
                }
                .padding()
                .padding(.bottom, 20.0)
                .onAppear {
                    logScreen(self)
                }
            }
            ActivityIndicator(shouldAnimate: $showAnimate)
        }.disabled(showAnimate)
        .ignoresSafeArea()
    }
    
    func subscribe() {
        Task {
            isLoading.toggle()
            showAnimate.toggle()
            if is6MonthSelected{
                result = await subscriptionManager.purchaseHalfYearlySubscription()
            } else {
                result = await subscriptionManager.purchaseMonthlySubscription()
            }
            showAnimate.toggle()
            isLoading.toggle()
            guard result != nil else {
                return
            }
            isAlertPresented.toggle()
        }
    }
}

struct SubscriptionViewv2_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionViewv2(isOnboarding: false)
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}
