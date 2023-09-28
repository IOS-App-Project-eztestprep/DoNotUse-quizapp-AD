//
//  BadgeNotificationView.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 18/06/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

struct BadgeNotificationView: View, Loggable {
    @EnvironmentObject
    private var delegate: AppDelegate
    
    @Binding var showingSheet: Bool
    
    var badgeNumber: BadgeNumber
    
    @State private var showFullScreen = true
    
    @Binding
    var tabSelection: Int
    
    var body: some View {
        if showFullScreen {
            ZStack {
                Color.init(red: 0, green: 0, blue: 0, opacity: 0.05)
                    .ignoresSafeArea()
                
                VStack (alignment: .leading){
                    Button {
                        showingSheet = false
                        if delegate.badgesToShow.count > 0 {
                            delegate.badgesToShow.removeFirst()
                        }
                        
                        if delegate.badgesToShow.count > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                delegate.showBadgeNotification = true
                            }
                        }
                    } label: {
                        Image("ic_close")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }.padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                    
                    VStack {
                        Text("New Achievement Unlocked")
                            .font(Font.nunito(.bold, size: 22))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.badgeNotificationTitleColor)
                        
                        Text(badgeNumber.topText)
                            .font(Font.nunito(.bold, size: 48))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightTeal)
                        
                        Image(badgeNumber.icon)
                            .resizable()
                            .frame(width: 175, height: 175)
                            .padding(.top, -28)

                        Text(badgeNumber.bottomText)
                        .font(Font.nunito(.medium, size: 34))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .padding(.top, -4)
                        
                        RoundedButtonWithoutShadowWithAction(text: "My Achievements") {
                            showingSheet = false
                            showStatsScreen()
                        }
                        .padding(EdgeInsets.init(top: 0, leading: 30, bottom: 30, trailing: 30))
                       
                    }
                }.cornerRadius(30)
                    .background(Color.lightestBlue)
                        .padding(8.0)
                    .onAppear {
                        logScreen(self)
                    }
            }
        }
    }
    
    func showStatsScreen() {
        tabSelection = 1
    }
}

struct BadgeNotificationView_Previews: PreviewProvider {
    @State private var showingSheet = true
    static var previews: some View {
        Text("Hello")
    }
}
