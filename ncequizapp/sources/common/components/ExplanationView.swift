import SwiftUI

struct ExplanationView: View {
    var correct: Bool
    var correctAnswer: String
    var explanation: AttributedString

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(correct ? "Correct" : "Incorrect")
                    .font(Font.nunito(.regular, size:12))
                    .fontWeight(.bold)
                    .foregroundColor(.buttonGray)
                Spacer()
                Image(correct ? "ic_check_black" : "ic_close_black")
            }

//            Text(correct ? "" : "The answer is \(correctAnswer)")
//                .font(.system(size: 12))
//                .foregroundColor(.buttonGray)
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity, alignment: .leading)

            Text(explanation)
                .font(Font.nunito(.regular, size:12))
                .foregroundColor(.buttonGray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .style(
                    withStroke: correct ? Color.successGreen : Color.errorRed,
                    lineWidth: 1,
                    fill: correct ? Color.successGreenBackground : Color
                        .errorRedBackground
                )
        )
    }
}

struct ExplanationView_Previews: PreviewProvider {
    static var previews: some View {
        ExplanationView(
            correct: false,
            correctAnswer: "Ripe",
            explanation: "laskdjal asdlkajsd laskd alskdja sldkaj sdlaksjdalsdj alsdkjaldkjas dlkajs dlaksdj asljla"
        )
    }
}
