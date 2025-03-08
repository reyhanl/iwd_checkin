//
//  UIColor+Extension.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

extension UIColor{
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHex = cleanedHex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: cleanedHex).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return String(format:"#%06x", rgb)
    }
    
    static var isDarkMode: Bool{
//        guard let temp: Bool = UserDefaultHelper.shared.retrieve(userDefaultKey: .isDarkMode) else {
//            return true
//        } 
        return true
    }
    
    static var secondaryForegroundColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "989899"):.darkGray
        return color
        
    }
    
    static var primaryForegroundColor: UIColor{
        let color: UIColor = isDarkMode ? .white:.black
        return color
        
    }
    
    static var oppositePrimaryForegroundColor: UIColor{
        let color: UIColor = isDarkMode ? .black:.white
        return color
        
    }
    
    static var oppositePrimaryBackgroundColor: UIColor{
        let color: UIColor = isDarkMode ? .white:.black
        return color
        
    }
    
    static var oppositeSecondaryBackgroundColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "F2F2F2", alpha: 1):UIColor(hex: "252525")
        return color
    }
    
    static var secondaryBackgroundColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "252525"):UIColor(hex: "F2F2F2", alpha: 1)
        return color
    }
    
    static var validColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "558B5E"):UIColor(hex: "8DF19D")
        return color
    }
    
    static var invalidColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "E55252"):UIColor(hex: "FD3535")
        return color
    }
    
    static var primaryButton: UIColor{
        let color = isDarkMode ? UIColor(hex: "A334CA"):UIColor(hex: "C930FF")
        return color
    }
    
    static var primaryButtonPressed: UIColor{
        let color = isDarkMode ? UIColor(hex: "992CBF"):UIColor(hex: "992CBF")
        return color
    }
    
    static var buttonDisabledColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "EAD1F2"):UIColor(hex: "EAD1F2")
        return color
    }
    
    static var customGreen: UIColor{
        let color = isDarkMode ? UIColor(hex: "61D65E"):UIColor(hex: "61D65E")
        return color
    }
    
    static var customYellow: UIColor{
        let color = isDarkMode ? UIColor(hex: "D6CA5E"):UIColor(hex: "D6CA5E")
        return color
    }
    
    static var cancelButtonColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "D9D9D9", alpha: 1):.init(hex: "242424")
        return color
    }
    
    static var cancelButtonTextColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "212121", alpha: 1):.init(hex: "D9D9D9")
        return color
    }
    
    func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            return (red, green, blue, alpha)
        }
}
