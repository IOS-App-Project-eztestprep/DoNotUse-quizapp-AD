//
//  RoundedButtonWithoutShadow.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 14/01/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct RoundedButtonWithoutShadow: View {
    var text: String
    var isSelectable: Bool
    var clearBackground: Bool = false
    var isLoading: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            if isLoading {
                ProgressView()
            } else {
                Text(text)
                    .font(Font.nunito(.bold, size: 18))
                    .foregroundColor(isSelectable ? .white : .buttonGray)
            }
            Spacer()
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.cornerRadius)
                .style(
                    withStroke: isSelectable ? Color.white : Color.buttonGray,
                    lineWidth: 1,
                    fill: isSelectable ? Color.purpleRegular : (clearBackground) ? Color.clear : Color.backgroundButton
                )
        )
    }
}

struct RoundedButtonWithoutShadow_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButtonWithoutShadow(text: "Test", isSelectable: false)
    }
}
