import SwiftUI

struct RoundedButton: View {
    var text: String
    var isSelectable: Bool
    var isLoading: Bool = false
    var body: some View {
        HStack {
            Spacer()
            if isLoading {
                ProgressView()
            } else {
                Text(text)
                    .font(Font.nunito(.bold, size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(isSelectable ? .white : .buttonGray)
            }
            Spacer()
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .style(
                    withStroke: isSelectable ? Color.white : Color.buttonGray,
                    lineWidth: 1,
                    fill: isSelectable ? Color.purpleRegular : Color.backgroundButton
                ).shadow(color: .shadow, radius: AppConstants.shadowRadius, x: AppConstants.shadowX, y: AppConstants.shadowY)
        )
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(text: "Test", isSelectable: false)
    }
}
