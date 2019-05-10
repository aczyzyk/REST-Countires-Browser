//
//  Extensions.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 09/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import Foundation
import UIKit


enum MyPalette {
    static let background   = UIColor(hex: 0x95a5a6)
    static let white        = UIColor(hex: 0xecf0f1)
    static let red          = UIColor(hex: 0xe74c3c)
    static let orange       = UIColor(hex: 0xe67e22)
    static let yellow       = UIColor(hex: 0xf1c40f)
}


enum MyFonts {
    static let regular = UIFont(name: "AvenirNext", size: 17)
    static let bold = UIFont(name: "AvenirNext-DemiBold", size: 17)
}


extension UIColor {
    // enable use of hex colors, e.g.:
    // let semitransparentBlack = UIColor(hex: 0x000000).withAlphaComponent(0.5)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}


extension Int {
    var asStringWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
