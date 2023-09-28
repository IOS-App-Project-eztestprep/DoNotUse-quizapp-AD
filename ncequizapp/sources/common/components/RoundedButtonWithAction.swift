import SwiftUI

struct RoundedButtonWithAction: View {
    var text: String
    var isSelectable: Bool
    var buttonBackgroundColor: Color?
    var buttonTextColor: Color?
    var isLoading: Bool = false
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Spacer()
                if isLoading {
                    ProgressView()
                } else {
                    Text(text)
                        .font(Font.nunito(.bold, size: 18))
                        .fontWeight(.bold)
                        .foregroundColor((buttonTextColor != nil) ? buttonTextColor : isSelectable ? .white : .buttonGray)
                }
                Spacer()
            }
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                    .style(
                        withStroke: isSelectable ? Color.white : Color.buttonGray,
                        lineWidth: 1,
                        fill: isSelectable ? ((buttonBackgroundColor) != nil) ? buttonBackgroundColor! : Color.purpleRegular : Color.backgroundButton
                    ).shadow(color: .shadow, radius: AppConstants.shadowRadius, x: AppConstants.shadowX, y: AppConstants.shadowY)
            )
        }
    }
}

struct RoundedButtonWithAction_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(text: "Test", isSelectable: false)
    }
}
