import SwiftUI

struct DifficultyBottomSheet: View {
    var selectedOption: OnboardingLevel?
    var action: ((OnboardingLevel) -> Void)?

    var body: some View {
        VStack {
            OnboardingRow(
                title: "Easy",
                isSelected: selectedOption == .easy
            ) {
                action?(.easy)
            }
            OnboardingRow(
                title: "Medium",
                isSelected: selectedOption == .medium
            ) {
                action?(.medium)
            }
            OnboardingRow(
                title: "Hard",
                isSelected: selectedOption == .hard
            ) {
                action?(.hard)
            }
        }.padding()
    }
}

struct DifficultyBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyBottomSheet()
    }
}
