//
//  UIColor+HexString.swift
//  TestApp
//
//  Created by Stephen O'Connor (MHP) on 21.02.19.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init?(hexString: String) {
        
        guard let values = UIColor.rgba(from: hexString) else {
            return nil
        }
        self.init(red: values.red, green: values.green, blue: values.blue, alpha: values.alpha)
    }
    
    public convenience init?(values: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?) {
        guard let values = values else {
            return nil
        }
        self.init(red: values.red, green: values.green, blue: values.blue, alpha: values.alpha)
    }
    
    public static func rgba(from hexString: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            guard hexColor.count == 6 || hexColor.count == 8 else {
                return nil
            }
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if hexColor.count == 8 {
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    return (red: r, green: g, blue: b, alpha: a)
                }
            } else {
                if scanner.scanHexInt64(&hexNumber) {
                    
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    return (red: r, green: g, blue: b, alpha: 1.0)
                }
            }
        }
        
        return nil
    }
}
