import SwiftUI

struct SubscriptionInfoRowv2: View {
    var text: String
    var body: some View {
        HStack {
            Image("ic_checkmark_circle")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.lightTeal)
                .frame(width: 30, height: 30)
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.nunito(.regular, size: 18))
                .foregroundColor(.buttonGray)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, UIScreen.isSmallScreenIphone ? -8 : 0)
    }
}

struct SubscriptionInfoRowv2_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionInfoRowv2(text: "Lorem ipsum short description")
    }
}
