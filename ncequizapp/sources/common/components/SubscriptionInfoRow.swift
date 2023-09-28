import SwiftUI

struct SubscriptionInfoRow: View {
    var text: String
    var body: some View {
        HStack {
            Image("ic_star_subscription")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.nunito(.regular, size: 18))
                .foregroundColor(.buttonGray)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct SubscriptionInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionInfoRow(text: "Lorem ipsum short description")
    }
}
