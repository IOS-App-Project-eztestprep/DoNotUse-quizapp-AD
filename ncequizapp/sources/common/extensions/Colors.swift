//
//  Colors.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 31/12/22.
//  Copyright © 2022 Mahendra Liya. All rights reserved.
//

import SwiftUI

// MARK: - App colors

extension Color {
    static let primaryBlue = Color(hex: "4687AD")
    static let lightBlue = Color(hex: "D1E7F5")
    static let quizSelectedColor = Color(hex:"D7D7D7")
    
    static let lightTeal = Color(hex:"417DA0")// Color(hex: "D1E7F5")
    static let textColor = Color(hex:"1A3151")
    static let background = Color(hex: "F5F5F5")
    static let backgroundButton = Color(hex:"D7D7D7")
    static let backgroundCategory = Color(hex: "DFD4FD")
    static let text = Color(hex:"00303E")
    static let textSubtitle = Color(hex: "00303E")
    
    static let buttonGray = Color(hex: "595C69")
    static let medGray =  Color(hex:"999CA9")
    static let orangeRegular = Color(hex: "E1501F")
    static let grayRegular = Color(hex: "999CA9")
    static let lightestBlue = Color(hex: "F6F9FC")
    static let errorRed = Color(hex: "DE5D5D")
    static let errorRedBackground = Color(hex: "FFDCDC")
    static let successGreen = Color(hex: "20CC82")
    static let successGreenBackground = Color(hex: "E6F4EA")
    static let lightOrange = Color(hex: "FB814E")
    static let purpleRegular = Color(hex: "543C92").opacity(0.80)
    static let purpleRegularWithoutOpactiy = Color(hex: "543C92")
    static let dailyQuizBackground = purpleRegular //.opacity(0.80)
    static let lightPurple = Color(hex: "D6D4F5")
    static let lightPurpleButtonBackground = Color(hex: "543C92").opacity(0.30)
    static let answerBackgroundBlue = Color(hex: "E4EEF4")
    static let goalGreen = Color(hex: "AEF027")
    static let disabledGray = Color(hex: "DFDFDF")
    static let shadow = Color(hex: "000000").opacity(0.45)
    static let strikeThrough = Color(hex: "FF0101")
    static let badgeNotificationTitleColor = Color(hex: "6853A7")
    static let lockedBadgeShadow = Color(hex: "000040").opacity(0.25)
}

extension ShapeStyle where Self == Color {
    static var strikeThrough: Color {
        Color(hex: "FF0101")
    }
}

// MARK: - Color hex init

extension Color {
    init(hex: String) {
        let hex = hex
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
