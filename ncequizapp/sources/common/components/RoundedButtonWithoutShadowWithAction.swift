//
//  RoundedButtonWithoutShadowWithAction.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 18/06/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct RoundedButtonWithoutShadowWithAction: View {
    var text: String
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Spacer()
                Text(text)
                    .font(Font.roboto(.bold, size: 18).weight(.bold))
                    .foregroundColor(Color.text)
                Spacer()
            }
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .style(
                        withStroke: Color.lightPurpleButtonBackground,
                        lineWidth: 1,
                        fill: Color.lightPurpleButtonBackground
                    )
            )
        }
    }
}

struct RoundedButtonWithoutShadowWithAction_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonWithoutShadowWithAction(text: "Test")
    }
}
