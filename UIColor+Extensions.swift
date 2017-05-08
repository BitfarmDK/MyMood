//
//  UIColor+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 05/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let systemBlue = UIColor(hex: 0x157EFB)
    static let systemBluePressed = UIColor(hex: 0x1164C7)
    static let systemGrayLabel = UIColor(hex: 0x8E8E93)
    static let systemPlaceholderLabel = UIColor(hex: 0xC7C7CD)
    static let systemLightGray = UIColor(hex: 0xF7F7F7)
    static let systemSeparatorGray = UIColor(hex: 0xC8C7CC)
    
    static let appBrightBlue = UIColor(hex: 0x00F8FE)
    static let appBrightBluePressed = UIColor(hex: 0x00BABF)
    
    static let appGrayLabel = UIColor(hex: 0xAAAAAA)
    static let appGrayDivider = UIColor(hex: 0xCCCCCC)
    static let appText = UIColor(hex: 0x777777)
    static let appTextBlue = UIColor(hex: 0x4197BD)
    
    convenience init(hex: Int) {
        self.init(
            red:    CGFloat((hex >> 16) & 0xff) / 255,
            green:  CGFloat((hex >> 08) & 0xff) / 255,
            blue:   CGFloat((hex >> 00) & 0xff) / 255,
            alpha:  1
        )
    }
    
    /// Percent between 0 and 1
    static func colorBetween(colorA: UIColor, colorB: UIColor, percent: CGFloat) -> UIColor {
        let percent = min(1, max(0, percent))
        
        var redA : CGFloat = 0
        var greenA : CGFloat = 0
        var blueA : CGFloat = 0
        var alphaA : CGFloat = 0
        colorA.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA)
        
        var redB : CGFloat = 0
        var greenB : CGFloat = 0
        var blueB : CGFloat = 0
        var alphaB : CGFloat = 0
        colorB.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB)
        
        let red: Float = Float(redA + percent * ( redB - redA ))
        let green: Float = Float(greenA + percent * ( greenB - greenA ))
        let blue: Float = Float(blueA + percent * ( blueB - blueA ))
        let alpha: Float = Float(alphaA + percent * ( alphaB - alphaA ))
        
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
    }
}
