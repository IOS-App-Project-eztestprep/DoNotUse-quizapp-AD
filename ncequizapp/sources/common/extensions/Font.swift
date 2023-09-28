//
//  Font.swift
//  ncequizapp
//
//  Created by Mahendra Liya on 08/01/23.
//  Copyright © 2023 Mahendra Liya. All rights reserved.
//

import SwiftUI
//MARK: Font Extension
extension Font {
    enum NunitoFont {
        case italic
        case regular
        case medium
        case bold
        case light
        case custom(String)
        
        var value: String {
            switch self {
            case .italic:
                return "Nunito-Italic"
            case .regular:
                return "Nunito-Regular"
            case .medium:
                return "Nunito-Medium"
            case .bold:
                return "Nunito-Bold"
            case .light:
                return "Nunito-Light"
            case .custom(let name):
                return name
            }
        }
    }
    
    enum RobotoFont {
        case italic
        case regular
        case medium
        case bold
        case light
        case custom(String)
        
        var value: String {
            switch self {
            case .italic:
                return "Roboto-Italic"
            case .regular:
                return "Roboto-Regular"
            case .medium:
                return "Roboto-Medium"
            case .bold:
                return "Roboto-Bold"
            case .light:
                return "Roboto-Light"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func nunito(_ type: NunitoFont, size: CGFloat = 20) -> Font {
        return .custom(type.value, size: size)
    }
        
    static func roboto(_ type: RobotoFont, size: CGFloat = 20) -> Font {
        return .custom(type.value, size: size)
    }
}
