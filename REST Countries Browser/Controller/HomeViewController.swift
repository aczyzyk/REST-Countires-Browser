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
        
    }


    func updateListOfCountries() {
        let sourceDataBaseURL = "https://restcountries.eu/rest/v2/all"
        let filteredDataURL = "\(sourceDataBaseURL)?fields=name;nativeName"
        
        
    }
}

