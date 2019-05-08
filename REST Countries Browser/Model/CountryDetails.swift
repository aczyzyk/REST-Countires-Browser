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
    let currencies : [[String : String]]
    let languages : [[String : String]]
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
        currencies = countryDetailsJSON["currencies"].arrayObject as? [[String : String]] ?? [[String : String]]()
        languages = countryDetailsJSON["languages"].arrayObject as? [[String : String]] ?? [[String : String]]()
        translations = countryDetailsJSON["translations"].arrayObject as? [String : String] ?? [String : String]()
        flag = countryDetailsJSON["flag"].stringValue
        
        let tempArray = countryDetailsJSON["regionalBlocs"].arrayObject as! [Any]
        var tempBlocsArray = [RegionalBloc]()
        for bloc in tempArray {
            let regionalBloc = RegionalBloc(acronym: JSON(bloc)["acronym"].stringValue, name: JSON(bloc)["name"].stringValue, otherAcronyms: JSON(bloc)["otherAcronyms"].arrayObject as? [String] ?? [String](), otherNames: JSON(bloc)["otherNames"].arrayObject as? [String] ?? [String]())
            tempBlocsArray.append(regionalBloc)
        }
        regionalBlocs = tempBlocsArray
        
        cioc = countryDetailsJSON["cioc"].stringValue
    }
}
