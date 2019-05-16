//
//  CountryDetails.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 08/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import Foundation
import SwiftyJSON


struct CountryDetails : Decodable {
    let name : String
    let topLevelDomain : [String]
    let alpha2Code : String
    let alpha3Code : String
    let callingCodes : [String]
    let capital : String
    let altSpellings : [String]
    let region : String
    let subregion : String
    let population : Int
    let latlng : [Double]
    let demonym : String
    let area : Double?
    let gini : Double?
    let timezones : [String]
    let borders : [String]
    let nativeName : String
    let numericCode : String?
    let currencies : [Currency]
    let languages : [Language]
    let translations : [String : String?]
    let flag : String
    let regionalBlocs : [RegionalBloc]
    let cioc : String?
    
    struct RegionalBloc : Decodable {
        let acronym : String
        let name : String
        let otherAcronyms : [String]
        let otherNames : [String]
    }

    struct Currency : Decodable {
        let name : String?
        let symbol : String?
        let code : String?
    }

    struct Language : Decodable {
        let iso639_1 : String?
        let iso639_2 : String?
        let name : String?
        let nativeName : String?
    }
    
}
