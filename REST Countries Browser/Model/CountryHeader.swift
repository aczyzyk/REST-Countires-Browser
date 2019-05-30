//
//  Country.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 06/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import Foundation

struct CountryHeader : Decodable {
    let name : String
    let nativeName : String
    let flag : String
    let alpha2Code : String
}
