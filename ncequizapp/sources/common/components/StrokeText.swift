
import SwiftUI

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let textBorderColor: Color
    let textForegroundColor: Color
    let alignment: TextAlignment
    let font: Font

    var body: some View {
        let diagonal: CGFloat = 1/sqrt(2) * width

        ZStack{
            ZStack{
                
                Text(text).offset(x:  diagonal, y:  diagonal).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                Text(text).offset(x: -diagonal, y: -diagonal).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                Text(text).offset(x: -diagonal, y:  diagonal).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                Text(text).offset(x:  diagonal, y: -diagonal).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                Text(text).offset(x:  -width, y: 0).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                                // right
                                Text(text).offset(x:  width, y: 0).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                                // top
                                Text(text).offset(x:  0, y: -width).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
                                // bottom
                                Text(text).offset(x:  0, y: width).font(font).foregroundColor(textForegroundColor).multilineTextAlignment(alignment)
            }
            .foregroundColor(textBorderColor)
            Text(text).font(Font.nunito(.regular,size: 40)).foregroundColor(textBorderColor).multilineTextAlignment(alignment)
        }
    }
}

