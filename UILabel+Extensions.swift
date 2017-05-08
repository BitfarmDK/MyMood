//
//  UILabel+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 06/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(isBold: Bool, size: CGFloat, color: UIColor, alignment: NSTextAlignment, multiLine: Bool = false, resize: Bool = false) {
        self.init()
        self.font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        self.textColor = color
        self.textAlignment = alignment
        if multiLine {
            self.numberOfLines = 0
            self.lineBreakMode = .byWordWrapping
        }
        self.adjustsFontSizeToFitWidth = resize
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
