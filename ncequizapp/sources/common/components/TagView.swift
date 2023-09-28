import SwiftUI

class TagViewConstants {
    static let TEXT_SIZE = 24.0
    static let TEXT_SIZE_IPAD = 32.0
    static let IMAGE_HEIGHT_WIDTH = 36.0
    static let IMAGE_HEIGHT_WIDTH_IPAD = 56.0
}

struct TagView: View {
    var icon: String?
    var text: String?
    var fillColor: Color
    var actionHandler: (() -> Void)?

    func getImageHeightWidth() -> CGFloat {
        return UIScreen.iPad ? TagViewConstants.IMAGE_HEIGHT_WIDTH_IPAD : TagViewConstants.IMAGE_HEIGHT_WIDTH
    }
    
    func getTextSize() -> CGFloat {
        return UIScreen.iPad ? TagViewConstants.TEXT_SIZE_IPAD : TagViewConstants.TEXT_SIZE
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(icon)
                    .resizable()
                    .frame(width: getImageHeightWidth(), height: getImageHeightWidth())
                    .padding(EdgeInsets.init(top: 0.0, leading: 0.0, bottom: 0.0, trailing: -8.0))
            }
            if let text = text {
                Text(text)
                    .font(Font.nunito(.bold, size: getTextSize()))
                    .fontWeight(.bold)
                    .foregroundColor(.text)
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

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(icon: "img_streak", text: "6", fillColor: .lightestBlue)
    }
}
