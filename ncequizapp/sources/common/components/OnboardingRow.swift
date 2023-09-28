import SwiftUI

struct OnboardingRow: View {
    @EnvironmentObject
    var userSettings: UserSettings
    var title: String
    var subtitle: String?
    var isSelected: Bool = false
    var actionHandler: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 20) {
            Text(title)
                .font(Font.nunito(.bold, size: 12))
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .buttonGray)
                .minimumScaleFactor(0.01)
                .frame(width: 50.0)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(Font.nunito(.regular, size: 12))
                    .foregroundColor(isSelected ? .white : .grayRegular)
                    .padding(.leading, 10)
                    .minimumScaleFactor(0.01)
            }
            Spacer()
            Image("ic_check")
                .renderingMode(.template)
                .foregroundColor(isSelected ? .white : .white.opacity(0))
        }
        .padding()
        
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .style(
                    withStroke: Color.purpleRegular,
                    lineWidth: 1,
                    fill: backgroundColor()
                )
        )
        .onTapGesture {
            actionHandler?()
        }
        .padding(EdgeInsets(top: 0.0, leading: 2.0, bottom: 0.0, trailing: 2.0))
    }

    func backgroundColor() -> Color {
        isSelected ? .lightPurple : .white
    }
}

struct OnboardingRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OnboardingRow(title: "Easy", subtitle: "70% Correct", isSelected: false)
            OnboardingRow(title: "Difficut", subtitle: "80% Correct", isSelected: false)
            OnboardingRow(title: "Hard", subtitle: "90% Correct", isSelected: false)
            OnboardingRow(title: "Extreme", subtitle: "100% Correct", isSelected: false)
        }
    }
}
