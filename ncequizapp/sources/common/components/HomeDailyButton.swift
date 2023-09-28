import SwiftUI

struct HomeDailyButton: View {
    @EnvironmentObject
    var storageManager: StorageManager
    
    @State
    var numberOfQuestions = OnboardingNumberOfQuestions.casual.numberOfQuestions
    
    var action: (() -> Void)?

    func getWidth() -> CGFloat {
        return UIScreen.iPad ? 400 : 230
    }
    
    func getHeight() -> CGFloat {
        return UIScreen.iPad ? 130 : 80
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: 20) {
                Image("ic_calendar_check")
                VStack(alignment: .leading) {
                    Text(
                        storageManager
                            .dailyQuizAvailable ? "Daily quiz" : "Completed!"
                    )
                    .font(Font.nunito(.bold, size: UIScreen.iPad ? 34 : 20))
                    .foregroundColor(.white)
                    if storageManager.dailyQuizAvailable {
                        Text(
                            "(\(numberOfQuestions) questions)"
                        )
                        .font(Font.nunito(.medium, size: UIScreen.iPad ? 18 : 10))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    }
                }
                UIScreen.iPad ? Spacer() : nil
                Image("ic_right_arrow")
                    .padding(.leading, 18.0)
            }
            .padding()
            .frame(width: getWidth(), height: getHeight())
            .background(
                    RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                        .style(
                            withStroke: storageManager.dailyQuizAvailable ? Color.dailyQuizBackground : Color.disabledGray,
                            lineWidth: 1,
                            fill: storageManager.dailyQuizAvailable ? Color.dailyQuizBackground : Color.disabledGray
                        )
                )
        }.disabled(!storageManager.dailyQuizAvailable)
            .onAppear{
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    numberOfQuestions = storageManager.userSettings.numberOfQuestions!.numberOfQuestions
                    print("Count: ", storageManager.userSettings.numberOfQuestions?.numberOfQuestions)
                    print("numberOfQuestions: ", storageManager.userSettings.numberOfQuestions)
                    print("storageManager.userSettings: ", storageManager.userSettings)
                    print("storageManager: ", storageManager)
                }
                
                
            }
    }
}

struct HomeDailyButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeDailyButton()
            .environmentObject(StorageManager())
    }
}
