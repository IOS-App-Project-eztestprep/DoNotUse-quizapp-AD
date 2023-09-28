import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: UIScreen.screenWidth, maxHeight: 6)
                .foregroundColor(.white)
                .cornerRadius(10)
            Rectangle()
                .frame(width: progress, height: 6)
                .foregroundColor(Color.purpleRegular)
                .cornerRadius(10)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 10)
    }
}
