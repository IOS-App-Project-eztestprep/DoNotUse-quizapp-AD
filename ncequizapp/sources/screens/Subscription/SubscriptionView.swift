import SwiftUI

struct SubscriptionView: View, Loggable {
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
    
    var mainText: String = "Sign up now to access everything!"
    
    let heroImageMaxWidth = UIScreen.iPad ? UIScreen.screenWidth - 240 : UIScreen.screenWidth - 160
    let minWidth = UIScreen.screenWidth / 2.0 - 1.5 * (UIScreen.iPad ? 120 : 20)
    let minHeight = 230.0
    @State private var isLoading = false
    @State private var showAnimate = false

    var body: some View {
        ScrollView{
            ZStack {
                VStack(spacing: 20) {
                    if !isOnboarding {
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    Image("ic_back")
                                }
                            }
                            .disabled(isLoading)
                            Spacer()
                        }.padding(EdgeInsets.init(top: 40.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                        
                        Image(UIScreen.iPad ? "img_unlock_subscription" : "img_unlock_subscription")
                        
                    }else {
                        Image(UIScreen.iPad ? "img_ob_subscription_ipad" : "img_ob_subscription")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: heroImageMaxWidth)
                            .padding(EdgeInsets(top: 40.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        SubscriptionInfoRow(text: "Daily customized learning")
                        SubscriptionInfoRow(text: "500+ NBCC 2023 questions")
                        SubscriptionInfoRow(text: "Track your stats and progress")
                    }.padding(.horizontal, UIScreen.iPad ? 100 : 20)
                    Text(mainText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(.text)
                        .font(Font.nunito(.regular, size: 20))
                    HStack{
                        Button {
                            Task {
                                isLoading.toggle()
                                showAnimate.toggle()
                                self.result = await subscriptionManager.purchaseMonthlySubscription()
                                showAnimate.toggle()
                                isLoading.toggle()
                                guard result != nil else {
                                    return
                                }
                                isAlertPresented.toggle()
                                
                            }
                        } label: {
                            VStack{
                                VStack{
                                    Text("****1 Month****")
                                        .font(.nunito(.regular, size: 25))
                                        .foregroundColor(.text)
                                    Text("**Cancel anytime**")
                                        .font(.nunito(.regular, size: 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 3, trailing: 0))
                                    Spacer()
                                    Text("**\(subscriptionManager.monthlyPrice())**")
                                        .font(.nunito(.regular, size: UIScreen.iPad ? 20 : 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 5, leading: 0, bottom: 60, trailing: 0))
                                }
                                .padding(16)
                                .frame(alignment: .center)
                                .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight )
                                .background(Color.white)
                                
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purpleRegular, lineWidth: 1)
                            )
                        }.disabled(isLoading)
                        Spacer()
                        Button {
                            Task {
                                isLoading.toggle()
                                showAnimate.toggle()
                                self.result = await subscriptionManager.purchaseHalfYearlySubscription()
                                showAnimate.toggle()
                                isLoading.toggle()
                                guard result != nil else {
                                    return
                                }
                                isAlertPresented.toggle()
                                
                            }
                        } label: {
                            VStack{
                                VStack{
                                    Text("****6 Months****")
                                        .font(.nunito(.bold, size: 25))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets(top: 16.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                                    Text("**Cancel Anytime**")
                                        .font(.nunito(.regular, size: 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    Spacer()
                                    Text("**\(subscriptionManager.halfYearlyPrice())**")
                                        .font(.nunito(.regular, size: UIScreen.iPad ? 20 : 16))
                                        .foregroundColor(.text)
                                        .padding(EdgeInsets.init(top: 5, leading: 0, bottom: -2.0, trailing: 0))
                                    VStack {
                                        Text ("**\(subscriptionManager.getSavings())**")
                                            .font(.nunito(.bold, size: 15))
                                            .foregroundColor(.white)
                                            .frame(width: 110, height: 32)
                                    }.background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .style(
                                                withStroke: Color.white ,
                                                lineWidth: 1,
                                                fill: Color.purpleRegular
                                            )
                                    )
                                    Text (subscriptionManager.halfYearlyPriceAsMonthly())
                                        .font(.nunito(.regular, size: UIScreen.iPad ? 14 : 10))
                                        .foregroundColor(.buttonGray)
                                        .padding(EdgeInsets(top: 0.0, leading: 8.0, bottom: 16.0, trailing: 8.0))
                                }
                                .frame(alignment: .center)
                                .frame(minWidth: minWidth, maxWidth: minWidth, minHeight: minHeight )
                                .background(Color.white)
                            }.overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.purpleRegular, lineWidth: 1)
                            )
                        }.disabled(isLoading)
                    }
                    .frame(maxWidth: 350.0)
                    
                    Divider()
                    if isOnboarding {
                        Text("Want to try it first?")
                            .font(Font.nunito(.regular, size: UIScreen.iPad ? 18 : 14))
                            .foregroundColor(Color.grayRegular)
                            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: -4.0, trailing: 0.0))
                        VStack {
                            Button {
                                userSettings.isCompleted = true
                                userSettings.storeToUserDefaults()
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("TRY IT FREE NOW")
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
                    }
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
                    Text(
                        "**[Terms & Conditions](https://www.eztestprep.com/terms-of-use)** and **[Privacy Policy](https://www.eztestprep.com/privacy-policy)**."
                    )
                    .font(Font.nunito(.regular, size: UIScreen.iPad ? 18 : 12))
                    .foregroundColor(Color.grayRegular)
                    .tint(Color.grayRegular)
                    .padding(EdgeInsets.init(top: -16.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    
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
                .onAppear {
                    logScreen(self)
                }
                ActivityIndicator(shouldAnimate: $showAnimate)
            }
        }.ignoresSafeArea()
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(isOnboarding: true, mainText: "Sign up now to access everything!")
            .environmentObject(QuizManager())
            .environmentObject(StorageManager())
            .environmentObject(SubscriptionManager.shared)
    }
}
