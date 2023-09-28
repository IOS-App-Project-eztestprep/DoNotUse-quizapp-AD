import SwiftUI

struct ScoreGoalBottomSheet: View {
    var selectedOption: OnboardingScore?
    var action: ((OnboardingScore) -> Void)?

    var body: some View {
        VStack {
            OnboardingRow(
                title: "Easy",
                subtitle: "\(OnboardingScore.easy.scorePercentage)% correct",
                isSelected: selectedOption == .easy
            ) {
                action?(.easy)
            }
            OnboardingRow(
                title: "Difficult",
                subtitle: "\(OnboardingScore.difficult.scorePercentage)% correct",
                isSelected: selectedOption == .difficult
            ) {
                action?(.difficult)
            }
            OnboardingRow(
                title: "Hard",
                subtitle: "\(OnboardingScore.hard.scorePercentage)% correct",
                isSelected: selectedOption == .hard
            ) {
                action?(.hard)
            }
            OnboardingRow(
                title: "Extreme",
                subtitle: "\(OnboardingScore.insane.scorePercentage)% correct",
                isSelected: selectedOption == .insane
            ) {
                action?(.insane)
            }
        }.padding()
    }
}

struct ScoreGoalBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ScoreGoalBottomSheet()
    }
}
