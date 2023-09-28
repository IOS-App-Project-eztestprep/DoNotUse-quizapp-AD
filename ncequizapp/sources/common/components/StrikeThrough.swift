//
//  StrikeThrough.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 04/03/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct StrikeThrough: View {
    @State private var changeLine = false
    var textContent: String = "Hello World"

    var body: some View {
        VStack {
            Spacer()
                ZStack{
                    Text("**\(textContent)**")
                        .font(.nunito(.regular, size: 16))
                        .foregroundColor(.text)
                    LineSegment(endPoint: CGPoint(
                        x: changeLine ? 0.0 : 1.0,y: 0.0))
                        .stroke(.strikeThrough, lineWidth: 2.0)
                        .frame(height: 1)
                        .animation(.easeInOut(duration: 0.4))
                }
                .fixedSize()
                .onTapGesture {
                    changeLine.toggle()
                }
            Spacer()
        }
    }
}

struct StrikeThroughV2: View {
    @State private var changeLine = false
    var prefix: String = ""
    var suffix: String = ""

    var body: some View {
        VStack {
            Spacer()
            HStack {
                ZStack{
                    Text("**\(prefix)**")
                        .font(.nunito(.regular, size: 16))
                        .foregroundColor(.text)
                    LineSegment(endPoint: CGPoint(
                        x: changeLine ? 0.0 : 1.0,y: 0.0))
                        .stroke(.strikeThrough, lineWidth: 2.0)
                        .frame(height: 1)
                        .animation(.easeInOut(duration: 0.4))
                }
                .fixedSize()
                .onTapGesture {
                    changeLine.toggle()
                }
                Text("**\(suffix)**")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(.text)
            }
            Spacer()
        }
    }
}

struct LineSegment: Shape {
    var endPoint: CGPoint
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(endPoint.x, endPoint.y) }
        set { endPoint.x = newValue.first; endPoint.y = newValue.second }
    }

    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: 0.0, y: 0.0)
        let end = CGPoint(x: endPoint.x * rect.width,
        y: endPoint.y * rect.height)
    
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct StrikeThrough_Previews: PreviewProvider {
    static var previews: some View {
        //StrikeThrough(textContent: "$24.99 / month")
        StrikeThroughV2(prefix: "$24.99", suffix: "/ month")
    }
}
