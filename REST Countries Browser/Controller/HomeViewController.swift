//
//  ViewController.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 06/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var countries = [Country]()

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCountriesArray()
        
    }
    
    
    fileprivate func updateCountriesArray() {
        
        let filteredDataURL = "https://restcountries.eu/rest/v2/all?fields=name;nativeName"
        
        Alamofire.request(filteredDataURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                let countriesAsJSONs = JSON(response.result.value).arrayValue
                
                countries = countriesAsJSONs.map { Country(name: JSON($0)["name"].stringValue, nativeName: JSON($0)["nativeName"].stringValue)}
           
            } else {
                #warning("Let user know that update failed")
            }
        }
        
    }
    
}

