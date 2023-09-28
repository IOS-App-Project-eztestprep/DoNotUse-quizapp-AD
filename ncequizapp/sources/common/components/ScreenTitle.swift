import SwiftUI

class ScreenTitleConstants {
    static let TEXT_SIZE = 14.0
    static let TEXT_SIZE_IPAD = (TEXT_SIZE/2) * 3
}

struct ScreenTitle: View {
    var title: String
    var tapAction: (() -> Void)?

    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        tapAction = action
    }

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(Font.roboto(.bold, size: UIScreen.iPad ? ScreenTitleConstants.TEXT_SIZE_IPAD : ScreenTitleConstants.TEXT_SIZE))
                .foregroundColor(.text)
            Spacer()
//            if tapAction != nil {
//                Button {
//                    tapAction?()
//                } label: {
//                    Text("VIEW ALL")
//                        .font(.system(size: UIScreen.iPad ? 15 : 10))
//                        .fontWeight(.bold)
//                        .foregroundColor(.lightOrange)
//                }
//            }
        }
        .padding(EdgeInsets.init(top: 12.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
    }
}

struct ScreenTitle_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTitle(title: "Your Quizzes")
    }
}
