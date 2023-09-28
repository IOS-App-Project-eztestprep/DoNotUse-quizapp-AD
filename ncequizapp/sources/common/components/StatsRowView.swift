import SwiftUI

struct StatsRowView: View {
    var text: String
    var value: String
    var primary: Bool = true
    var action: (() -> Void)?

    func getHeightWidth() -> CGFloat {
        return UIScreen.iPad ? 180 : 180
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius, style: .continuous)
                .fill(primary ? Color.purpleRegular : Color.white)
                .frame(maxWidth: getHeightWidth(), maxHeight: getHeightWidth())
            VStack {
                Text(text)
                    .font(Font.nunito(.bold, size: UIScreen.iPad ? 18 : 16))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(primary ? Color.white : Color.text)
                Text(value)
                    .font(Font.nunito(.bold, size: UIScreen.iPad ? 60 : 40))
                    .fontWeight(.heavy)
                    .foregroundColor(primary ? Color.white : Color.text)
            }
            .padding()
        }.onTapGesture {
            action?()
        }
    }
}

struct StatsRowView_Previews: PreviewProvider {
    static var previews: some View {
        StatsRowView(text: "Longest Streak", value: "00:00", primary: true)
    }
}
