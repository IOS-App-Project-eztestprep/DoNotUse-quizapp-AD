//
//  Badge.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 19/06/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI

enum BadgeNumber {
    case badge1,
         badge2,
         badge3,
         badge4,
         badge5,
         badge6,
         badge7,
         badge8,
         badge9,
         badge10,
         badge11,
         badge12,
         badge13,
         badge14,
         badge15,
         badge16,
         badge17,
         badge18,
         badge19,
         badge20,
         badge21,
         badge22,
         badge23,
         badge24,
         badge25,
         badge26,
         badge27,
         badge28,
         badge29,
         badge30,
         badge31,
         badge32,
         badge33,
         badge34,
         badge35,
         badge36,
         badge37,
         badge38,
         badge39,
         badge40,
         badge41,
         badge42
    
    var topText: String {
        switch self {
        case .badge1: return "Not Bad"
        case .badge2: return "Impressive"
        case .badge3: return "Show Off"
        case .badge4: return "Fire"
        case .badge5: return "Damn!"
        case .badge6: return "Go Outside"
        case .badge7: return "Newbie"
        case .badge8: return "Welcome Back"
        case .badge9: return "Freshman"
        case .badge10: return "Sophomore"
        case .badge11: return "Junior"
        case .badge12: return "Senior"
        case .badge13: return "Post Grad"
        case .badge14: return "It’s a Start"
        case .badge15: return "Now You Got It"
        case .badge16: return "Benjamins"
        case .badge17: return "Two Fitty"
        case .badge18: return "Wow!"
        case .badge19: return "That’s a Lot"
        case .badge20: return "You Win"
        case .badge21: return "A+"
        case .badge22: return "A+++"
        case .badge23: return "1000%"
        case .badge24: return "You’re Ready"
        case .badge25: return "1800 Seconds"
        case .badge26: return "3600 Seconds"
        case .badge27: return "7200 Seconds"
        case .badge28: return "18K Seconds"
        case .badge29: return "Marked Books"
        case .badge30: return "Sticky Notes"
        case .badge31: return "Highlighter"
        case .badge32: return "So Close"
        case .badge33: return "The Matrix"
        case .badge34: return "Webelos"
        case .badge35: return "Scout"
        case .badge36: return "Eagle Scout"
        case .badge37: return "Early Bird"
        case .badge38: return "Night Owl"
        case .badge39: return "Too Easy"
        case .badge40: return "Cram Time"
        case .badge41: return "5 Stars?"
        case .badge42: return "Shameless"
        }
    }
    
    var icon: String {
        switch self {
        case .badge1: return "1"
        case .badge2: return "2"
        case .badge3: return "3"
        case .badge4: return "4"
        case .badge5: return "5"
        case .badge6: return "6"
        case .badge7: return "7"
        case .badge8: return "8"
        case .badge9: return "9"
        case .badge10: return "10"
        case .badge11: return "11"
        case .badge12: return "12"
        case .badge13: return "13"
        case .badge14: return "14"
        case .badge15: return "15"
        case .badge16: return "16"
        case .badge17: return "17"
        case .badge18: return "18"
        case .badge19: return "19"
        case .badge20: return "20"
        case .badge21: return "21"
        case .badge22: return "22"
        case .badge23: return "23"
        case .badge24: return "24"
        case .badge25: return "25"
        case .badge26: return "26"
        case .badge27: return "27"
        case .badge28: return "28"
        case .badge29: return "29"
        case .badge30: return "30"
        case .badge31: return "31"
        case .badge32: return "32"
        case .badge33: return "33"
        case .badge34: return "34"
        case .badge35: return "35"
        case .badge36: return "36"
        case .badge37: return "37"
        case .badge38: return "38"
        case .badge39: return "39"
        case .badge40: return "40"
        case .badge41: return "41"
        case .badge42: return "42"
        }
    }
    
    var bottomText: String {
        switch self {
        case .badge1: return "2 Day Streak"
        case .badge2: return "3 Day Streak"
        case .badge3: return "5 Day Streak"
        case .badge4: return "10 Day Streak"
        case .badge5: return "20 Day Streak"
        case .badge6: return "30 Day Streak"
        case .badge7: return "1 Daily Quiz"
        case .badge8: return "2 Daily Quizzes"
        case .badge9: return "5 Daily Quizzes"
        case .badge10: return "10 Daily Quizzes"
        case .badge11: return "20 Daily Quizzes"
        case .badge12: return "30 Daily Quizzes"
        case .badge13: return "50 Daily Quizzes"
        case .badge14: return "20 Questions"
        case .badge15: return "50 Questions"
        case .badge16: return "100 Questions"
        case .badge17: return "250 Questions"
        case .badge18: return "500 Questions"
        case .badge19: return "750 Questions"
        case .badge20: return "1000 Questions"
        case .badge21: return "Score 100%"
        case .badge22: return "100% x 3"
        case .badge23: return "100% x 10"
        case .badge24: return "100% x 20"
        case .badge25: return "30 Minutes"
        case .badge26: return "60 Minutes"
        case .badge27: return "120 Minutes"
        case .badge28: return "300 Minutes"
        case .badge29: return "3 Bookmarks"
        case .badge30: return "10 Bookmarks"
        case .badge31: return "20 Bookmarks"
        case .badge32: return "90% Simulator"
        case .badge33: return "100% Simulator"
        case .badge34: return "5 Badges"
        case .badge35: return "10 Badges"
        case .badge36: return "20 Badges"
        case .badge37: return "Before 7am"
        case .badge38: return "After 11pm"
        case .badge39: return "Change Difficulty"
        case .badge40: return "Change Daily"
        case .badge41: return "Rate the App"
        case .badge42: return "Send to a Friend"
        }
    }
    
    var iconHeight: CGFloat {
        switch self {
        case .badge1, .badge2, .badge3, .badge4, .badge5, .badge6: return 104
        case .badge7, .badge8, .badge9, .badge10, .badge11, .badge12, .badge13: return 91
        case .badge14, .badge15, .badge16, .badge17, .badge18, .badge19, .badge20: return 91
        case .badge21, .badge22, .badge23, .badge24: return 94
        case .badge25, .badge26, .badge27, .badge28: return 104
        case .badge29, .badge30, .badge31: return 91
        case .badge32, .badge33: return 98
        case .badge34, .badge35, .badge36: return 91
        case .badge37, .badge38, .badge39: return 91
        case .badge40: return 91
        case .badge41: return 83
        case .badge42: return 94
        }
    }
        
    var iconWidth: CGFloat {
        switch self {
        case .badge1, .badge2, .badge3, .badge4, .badge5, .badge6: return 90
        case .badge7, .badge8, .badge9, .badge10, .badge11, .badge12, .badge13: return 91
        case .badge14, .badge15, .badge16, .badge17, .badge18, .badge19, .badge20: return 91
        case .badge21, .badge22, .badge23, .badge24: return 82
        case .badge25, .badge26, .badge27, .badge28: return 91
        case .badge29, .badge30, .badge31: return 91
        case .badge32, .badge33: return 81
        case .badge34, .badge35, .badge36: return 91
        case .badge37, .badge38, .badge39: return 91
        case .badge40: return 91
        case .badge41: return 91
        case .badge42: return 77
        }
    }
}

struct Badge: View, Identifiable {
    var id: Int
    let badgeNumber: BadgeNumber
    let isUnlocked: Bool
    
    var body: some View {
    
        VStack {
            if(isUnlocked) {
                ZStack {
                    VStack {
                        Text(badgeNumber.topText)
                            .font(Font.nunito(.bold, size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightTeal)
                            .padding(.bottom, -6)
                        
                        Image(badgeNumber.icon)
                            .resizable()
                            .frame(width: badgeNumber.iconWidth, height: badgeNumber.iconHeight)
                            
                        Text(badgeNumber.bottomText)
                        .font(Font.nunito(.medium, size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .padding(.top, -6)
                    }.padding(EdgeInsets(top: 0.0, leading: 12.0, bottom: 0.0, trailing: 12.0))
                }
            } else {
                ZStack {
                    VStack {
                        Text(" ")
                            .font(Font.nunito(.bold, size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.lightTeal)
                            .padding(.bottom, -6)
                        
                        Image(badgeNumber.icon)
                            .resizable()
                            .frame(width: badgeNumber.iconWidth, height: badgeNumber.iconHeight)
                            .opacity(0.2)
                            
                        Text(badgeNumber.bottomText)
                        .font(Font.nunito(.medium, size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.text)
                        .padding(.top, -6)
                        .opacity(0.2)
                    }.padding(EdgeInsets(top: 0.0, leading: 12.0, bottom: 0.0, trailing: 12.0))
                }
            }
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.lightestBlue.ignoresSafeArea()
            VStack {
                HStack {
                    Badge(id: 1, badgeNumber: BadgeNumber.badge1, isUnlocked: true)
                    Badge(id: 2, badgeNumber: BadgeNumber.badge2, isUnlocked: true)
                    Badge(id: 3, badgeNumber: BadgeNumber.badge3, isUnlocked: true)
                }
                HStack {
                    Badge(id: 4, badgeNumber: BadgeNumber.badge4, isUnlocked: false)
                    Badge(id: 5, badgeNumber: BadgeNumber.badge5, isUnlocked: false)
                    Badge(id: 6, badgeNumber: BadgeNumber.badge6, isUnlocked: false)
                }
            }
        }
    }
}
