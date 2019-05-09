//
//  Extensions.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 09/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import Foundation


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
