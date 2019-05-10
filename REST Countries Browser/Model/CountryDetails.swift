//
//  CountryDetails.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 08/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import Foundation
import SwiftyJSON


struct CountryDetails {
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
    let latlng : (Double, Double)
    let demonym : String
    let area : Int
    let gini : Double
    let timezones : [String]
    let borders : [String]
    let nativeName : String
    let numericCode : Int
    let currencies : [Currency]
    let languages : [Language]
    let translations : [String : String]
    let flag : String
    let regionalBlocs : [RegionalBloc]
    let cioc : String
    
    struct RegionalBloc {
        let acronym : String
        let name : String
        let otherAcronyms : [String]
        let otherNames : [String]
    }
    
    struct Currency {
        let name : String
        let symbol : String
        let code : String
    }
    
    struct Language {
        let name : String
        let nativeName : String
        let iso639_1 : String
        let iso639_2 : String
    }
    
    
    init(countryDetailsJSON : JSON) {
        
        name = countryDetailsJSON["name"].stringValue
        topLevelDomain = countryDetailsJSON["topLevelDomain"].arrayObject as? [String] ?? [String]()
        alpha2Code = countryDetailsJSON["alpha2Code"].stringValue
        alpha3Code = countryDetailsJSON["alpha3Code"].stringValue
        callingCodes = countryDetailsJSON["callingCodes"].arrayObject as? [String] ?? [String]()
        capital = countryDetailsJSON["capital"].stringValue
        altSpellings = countryDetailsJSON["altSpellings"].arrayObject as? [String] ?? [String]()
        region = countryDetailsJSON["region"].stringValue
        subregion = countryDetailsJSON["subregion"].stringValue
        population = countryDetailsJSON["population"].intValue
        latlng = (countryDetailsJSON["latlng"][0].doubleValue, countryDetailsJSON["latlng"][1].doubleValue)
        demonym = countryDetailsJSON["demonym"].stringValue
        area = countryDetailsJSON["area"].intValue
        gini = countryDetailsJSON["gini"].doubleValue
        timezones = countryDetailsJSON["timezones"].arrayObject as? [String] ?? [String]()
        borders = countryDetailsJSON["borders"].arrayObject as? [String] ?? [String]()
        nativeName = countryDetailsJSON["nativeName"].stringValue
        numericCode = countryDetailsJSON["numericCode"].intValue

        do {
            var tempArray = [Currency]()
            let tempReference = countryDetailsJSON["currencies"].arrayObject as? [[String : String]] ?? [[String : String]]()
            for item in tempReference {
                let newItem = Currency(name: JSON(item)["name"].stringValue, symbol: JSON(item)["symbol"].stringValue, code: JSON(item)["code"].stringValue)
                tempArray.append(newItem)
            }
            currencies = tempArray
        }
        
        do {
            var tempArray = [Language]()
            let tempReference = countryDetailsJSON["languages"].arrayObject as? [[String : String]] ?? [[String : String]]()
            for item in tempReference {
                let newItem = Language(name: JSON(item)["name"].stringValue, nativeName: JSON(item)["nativeName"].stringValue, iso639_1: JSON(item)["iso639_1"].stringValue, iso639_2: JSON(item)["iso639_2"].stringValue)
                tempArray.append(newItem)
            }
            languages = tempArray
        }
        
        translations = countryDetailsJSON["translations"].dictionaryObject as? [String : String] ?? [String : String]()
        flag = countryDetailsJSON["flag"].stringValue
        
        do {
            var tempArray = [RegionalBloc]()
            
            if let tempReference = countryDetailsJSON["regionalBlocs"].arrayObject {
                for item in tempReference {
                    let newItem = RegionalBloc(acronym: JSON(item)["acronym"].stringValue, name: JSON(item)["name"].stringValue, otherAcronyms: JSON(item)["otherAcronyms"].arrayObject as? [String] ?? [String](), otherNames: JSON(item)["otherNames"].arrayObject as? [String] ?? [String]())
                    tempArray.append(newItem)
                }
            }
            regionalBlocs = tempArray
        }
        
        cioc = countryDetailsJSON["cioc"].stringValue
    }
    
}
