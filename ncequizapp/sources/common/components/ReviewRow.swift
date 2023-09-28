//
//  ReviewRow.swift
//  ncequizapp
//
//  Created by Hemanshu Liya on 21/02/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct ReviewRow: View {
    var reviewText: String
    var reviewer: String
    
    var body: some View {
        
        VStack {
            Group {
                StarView()
                Text(reviewText)
                    .multilineTextAlignment(.center)
                    .font(.nunito(.medium, size: UIScreen.iPad ? 30 : UIScreen.isSmallScreenIphone ? 16 : 20))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .padding(EdgeInsets(top: 0.0, leading: 26.0, bottom: 0.0, trailing: 26.0))
                    .fixedSize(horizontal: false, vertical: true)
                Text(reviewer)
                    .multilineTextAlignment(.center)
                    .font(.nunito(.medium, size: UIScreen.iPad ? 22 : UIScreen.isSmallScreenIphone ? 13 : 16))
                    .foregroundColor(.buttonGray)
                    .lineLimit(nil)
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                .fixedSize(horizontal: false, vertical: true)                
            }
        }
    }
}

struct StarView: View {
    let starImage = "ic_star_subscription"
    let starHeightWidth = UIScreen.isSmallScreenIphone ? 20 : 30.0
    let starForegroundColor = Color.yellow
    
    
    var body: some View {
        
        HStack {
            Group {
                Image(starImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(starForegroundColor)
                    .frame(width: starHeightWidth, height: starHeightWidth)
                Image(starImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(starForegroundColor)
                    .frame(width: starHeightWidth, height: starHeightWidth)
                Image(starImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(starForegroundColor)
                    .frame(width: starHeightWidth, height: starHeightWidth)
                Image(starImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(starForegroundColor)
                    .frame(width: starHeightWidth, height: starHeightWidth)
                Image(starImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(starForegroundColor)
                    .frame(width: starHeightWidth, height: starHeightWidth)
            }
        }
    }
}

struct ReviewRow_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(reviewText: "\"Life saver! Beautiful interface and easy to use.\"", reviewer: "Stella, LPCC")
    }
}
