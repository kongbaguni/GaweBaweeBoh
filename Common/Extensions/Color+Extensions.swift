//
//  Color+Extensions.swift
//  GaweeBaweeBoh
//
//  Created by Changyeol Seo on 2023/07/05.
//

import Foundation
import SwiftUI

extension Color {
    var stringValue:String {
        let uicolor = UIColor(self)
        guard let colorComponents = uicolor.cgColor.components else {
            return "#00000000"
        }
        
        let red = Int(colorComponents[0] * 255)
        let green = Int(colorComponents[1] * 255)
        let blue = Int(colorComponents[2] * 255)
        let alpha = Int(colorComponents[3] * 255)
        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
    }
        
    static func fromString(_ string: String) -> Color? {
        let colorString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard colorString.hasPrefix("#") && (colorString.count == 7 || colorString.count == 9) else {
            return nil
        }
        
        let start = colorString.index(colorString.startIndex, offsetBy: 1)
        let hexString = String(colorString[start...])
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        let alpha: Double
        if colorString.count == 9 {
            let alphaValue = (rgbValue & 0xFF000000) >> 24
            alpha = Double(alphaValue) / 255.0
        } else {
            alpha = 1.0
        }
        
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }

    static var random:Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}
