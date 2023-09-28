import SwiftUI

class UnlockViewConstants {
    static let TEXT_SIZE = 12.0
    static let TEXT_SIZE_IPAD = 24.0
    static let IMAGE_HEIGHT_WIDTH = 20.0
    static let IMAGE_HEIGHT_WIDTH_IPAD = 28.0
}

struct UnlockView: View {
    var icon: String?
    var text: String?
    var fillColor: Color
    var actionHandler: (() -> Void)?

    func getImageHeightWidth() -> CGFloat {
        return UIScreen.iPad ? UnlockViewConstants.IMAGE_HEIGHT_WIDTH_IPAD : UnlockViewConstants.IMAGE_HEIGHT_WIDTH
    }
    
    func getTextSize() -> CGFloat {
        return UIScreen.iPad ? UnlockViewConstants.TEXT_SIZE_IPAD : UnlockViewConstants.TEXT_SIZE
    }
    
    var body: some View {
        HStack(spacing: UIScreen.iPad ? 12.0 : 8.0) {
            if let icon = icon {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: getImageHeightWidth(), height: getImageHeightWidth())
                    .padding(EdgeInsets(top: UIScreen.iPad ? 12.0 : 4.0, leading: UIScreen.iPad ? 16.0 : 8.0, bottom: UIScreen.iPad ? 12.0 : 6.0, trailing: UIScreen.iPad ? 0.0 : -4.0))
            }
            if let text = text {
                Text(text)
                    .font(Font.nunito(.bold, size: getTextSize()))
                    .fontWeight(.bold)
                    .foregroundColor(.text)
                    .padding(.trailing, UIScreen.iPad ? 8.0 : 6.0)
            }
        }
        .onTapGesture {
            actionHandler?()
        }
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius / 2)
                .style(
                    withStroke: fillColor,
                    lineWidth: 1,
                    fill: fillColor
                )
        )
    }
}

struct UnlockView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(icon: "ic_crown", text: "UNLOCK", fillColor: .goalGreen)
    }
}
