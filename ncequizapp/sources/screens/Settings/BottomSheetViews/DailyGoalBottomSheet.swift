import SwiftUI

struct DailyGoalBottomSheet: View {
    var selectedOption: OnboardingNumberOfQuestions?
    var action: ((OnboardingNumberOfQuestions) -> Void)?

    var body: some View {
        VStack {
            OnboardingRow(
                title: "Casual",
                subtitle: "\(OnboardingNumberOfQuestions.casual.numberOfQuestions) questions per day",
                isSelected: selectedOption == .casual
            ) {
                action?(.casual)
            }
            OnboardingRow(
                title: "Regular",
                subtitle: "\(OnboardingNumberOfQuestions.regular.numberOfQuestions) questions per day",
                isSelected: selectedOption == .regular
            ) {
                action?(.regular)
            }
            OnboardingRow(
                title: "Serious",
                subtitle: "\(OnboardingNumberOfQuestions.serious.numberOfQuestions) questions per day",
                isSelected: selectedOption == .serious
            ) {
                action?(.serious)
            }
            OnboardingRow(
                title: "Extreme",
                subtitle: "\(OnboardingNumberOfQuestions.insane.numberOfQuestions) questions per day",
                isSelected: selectedOption == .insane
            ) {
                action?(.insane)
            }
        }.padding()
    }
}

struct DailyGoalBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        DailyGoalBottomSheet(selectedOption: .regular)
    }
}
