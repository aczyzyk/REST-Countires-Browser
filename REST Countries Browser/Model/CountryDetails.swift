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
    
    func asSimpleArray() -> [(String, String)] {
        
        var tempArray = [(String, String)]()
        
        let name = ("name:", self.name)
        tempArray.append(name)
        
        for (index, item) in topLevelDomain.enumerated() {
            let newLine = (index == 0 ? "topLevelDomain:" : "", item)
            tempArray.append(newLine)
        }
        
        let alpha2Code = ("alpha2Code:", self.alpha2Code)
        tempArray.append(alpha2Code)

        let alpha3Code = ("alpha3Code:", self.alpha3Code)
        tempArray.append(alpha3Code)
        
        for (index, item) in callingCodes.enumerated() {
            let newLine = (index == 0 ? "callingCodes:" : "", item)
            tempArray.append(newLine)
        }

        let capital = ("capital:", self.capital)
        tempArray.append(capital)

        for (index, item) in altSpellings.enumerated() {
            let newLine = (index == 0 ? "altSpellings:" : "", item)
            tempArray.append(newLine)
        }
        
        let region = ("region:", self.region)
        tempArray.append(region)

        let subregion = ("subregion:", self.subregion)
        tempArray.append(subregion)
        
        let population = ("population:", "\(self.population)")
        tempArray.append(population)

        let latlng = ("latlng:", "\(self.latlng)")
        tempArray.append(latlng)

        let demonym = ("demonym:", self.demonym)
        tempArray.append(demonym)

        let area = ("area:", "\(self.area)")
        tempArray.append(area)
        
        let gini = ("gini:", "\(self.gini)")
        tempArray.append(gini)
        
        for (index, item) in timezones.enumerated() {
            let newLine = (index == 0 ? "timezones:" : "", item)
            tempArray.append(newLine)
        }

        for (index, item) in borders.enumerated() {
            let newLine = (index == 0 ? "borders:" : "", item)
            tempArray.append(newLine)
        }
        
        let nativeName = ("nativeName:", self.nativeName)
        tempArray.append(nativeName)
        
        let numericCode = ("numericCode:", "\(self.numericCode)")
        tempArray.append(numericCode)
        
        for (index, item) in currencies.enumerated() {
            for (index2, item2) in item.enumerated() {
                let newLine = (index == 0 && index2 == 0 ? "currencies:" : "", "\(item2.key): \(item2.value)")
                tempArray.append(newLine)
            }
        }
        
        for (index, item) in languages.enumerated() {
            for (index2, item2) in item.enumerated() {
                let newLine = (index == 0 && index2 == 0 ? "languages:" : "", "\(item2.key): \(item2.value)")
                tempArray.append(newLine)
            }
        }
        
        for (index, item) in translations.enumerated() {
            let newLine = (index == 0 ? "translations:" : "", "\(item.key): \(item.value)")
            tempArray.append(newLine)
        }
        
        let flag = ("flag:", self.flag)
        tempArray.append(flag)
        
        for (index, item) in regionalBlocs.enumerated() {
            let newLine = (index == 0 ? "regionalBlocs:" : "", "acronym: \(item.acronym)")
            tempArray.append(newLine)
            let newLIne2 = ("", "name: \(item.name)")
            tempArray.append(newLIne2)
            for (index, item) in item.otherAcronyms.enumerated() {
                let newLine = ("", "\(index == 0 ? "otherAcronyms: " : "")\(item)")
                tempArray.append(newLine)
            }
            for (index, item) in item.otherNames.enumerated() {
                let newLine = ("", "\(index == 0 ? "otherNames: " : "")\(item)")
                tempArray.append(newLine)
            }
        }
        
        let cioc = ("cioc:", self.cioc)
        tempArray.append(cioc)
        
        return tempArray
    }
}
