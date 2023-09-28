import SwiftUI

struct IntroductoryOfferView: View, Loggable {
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
    @EnvironmentObject
    private var delegate: AppDelegate


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
                VStack {
                    HStack {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            delegate.openedFromNotification = false
                        } label: {
                            Image("ic_close")
                        }
                        Spacer()
                    }.padding(EdgeInsets(top: 64.0, leading: 36.0, bottom: 0.0, trailing: 0.0))
                    VStack(alignment: .center) {
                        Text("24 Hour")
                            .font(Font.nunito(.medium, size: UIScreen.iPad ? 42.0 : 26.0))
                            .foregroundColor(Color.lightTeal)
                            .padding(EdgeInsets(top: 30.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                        Text("Limited-Time Offer!")
                            .font(Font.nunito(.medium, size: UIScreen.iPad ? 36 : 24))
                            .foregroundColor(Color.buttonGray)
                        
                        Text("50% off")
                            .font(Font.nunito(.bold, size: UIScreen.iPad ? 100 : 70))
                            .foregroundColor(Color.lightTeal)
                        
                        Image(UIScreen.iPad ? "read_line_ipad" : "read_line")
                            .padding(EdgeInsets(top: UIScreen.iPad ? -90.0 : -70.0, leading: 0.0, bottom: -80.0, trailing: 0.0))

                        
                        Text("Take 50% off your first 1 or 6 Month Subscription!")
                            .multilineTextAlignment(.center)
                            .font(Font.nunito(.regular, size: UIScreen.iPad ? 26 : 16))
                            .foregroundColor(Color.text)
                            .padding(EdgeInsets(top: -40.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                            .padding(.horizontal, UIScreen.iPad ? 200 : 90)
                        
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
                                            .padding(EdgeInsets(top: UIScreen.iPad ? 32.0 : 38.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                        Text("**Cancel anytime**")
                                            .font(.nunito(.regular, size: 16))
                                            .foregroundColor(.text)
                                            .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 3, trailing: 0))
                                        VStack {}.frame(height: 20)
                                        
                                        Text("**\(subscriptionManager.monthlyIntroductoryPriceWithoutMonthSuffix())** \t\t")
                                            .font(.nunito(.regular, size: UIScreen.iPad ? 20 : 16))
                                            .foregroundColor(.strikeThrough)
                                            .padding(.top, UIScreen.iPad ? 12.0 : 6.0)
                                            
                                            
                                        StrikeThroughV2(prefix: subscriptionManager.monthlyPriceWithoutMonthSuffix(), suffix: "/ \(subscriptionManager.getLocalizedDurationForMonthlySubscription())")
                                            .padding(.top, UIScreen.iPad ? -42.0 : -34.0)
                                            
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
                                            Text("\(subscriptionManager.getSavingsForIntroductoryPrice())")
                                                .font(.nunito(.bold, size: 16))
                                                .foregroundColor(.white)
                                        }.padding(EdgeInsets(top: 14.0, leading: getLeadingPaddingForSaveTag(), bottom: 0.0, trailing: getTrailingPaddingForSaveTag()))
                                        Text("****6 Months****")
                                            .font(.nunito(.bold, size: 25))
                                            .fontWeight(.bold)
                                            .foregroundColor(.purpleRegular)
                                            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                        Text("**Cancel Anytime**")
                                            .font(.nunito(.regular, size: 16))
                                            .foregroundColor(.text)
                                            .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                                        VStack {}.frame(height: 22)
                                        VStack {
                                            Text("**\(subscriptionManager.halfYearlyIntroductoryPriceWithoutMonthSuffix())** \t\t\t")
                                                .font(.nunito(.regular, size: UIScreen.iPad ? 20 : 16))
                                                .foregroundColor(.strikeThrough)
                                            
                                            StrikeThroughV2(prefix: subscriptionManager.halfYearlyPriceWithoutMonthSuffix(), suffix: "/ \(subscriptionManager.getLocalizedDurationForHalfYearlySubscription())")
                                                .padding(.top, -24.0)

                                                
                                            Text (subscriptionManager.getHalfYearlyPriceAsMontlyForIntroductoryOffer())
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
                        }
                        
                        RoundedButtonWithAction(text: "Unlock All Content", isSelectable: true) {
                            subscribe()
                        }.frame(width: UIScreen.iPad ? 480.0: 320.0)
                        
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
                                .padding(EdgeInsets(top: 16.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                            
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
                    .padding(EdgeInsets(top: -64.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    .padding()
                    .onAppear {
                        logScreen(self)
                    }
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
            if is6MonthSelected {
                result = await subscriptionManager.purchaseHalfYearlyIntroductorySubscription()
            } else {
                result = await subscriptionManager.purchaseMonthlyIntroductorySubscription()
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

struct IntroductoryOfferView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductoryOfferView()
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}
