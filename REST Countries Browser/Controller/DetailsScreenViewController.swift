//
//  DetailsScreenViewController.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 07/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import SDWebImage
import SDWebImageSVGCoder


class DetailsScreenViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nativeNameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var selectedCountry : Country?
    var countryDetails : JSON?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if let selectedCountry = selectedCountry {
        displayBasicCountryInfo(for: selectedCountry)
        getCountryDetails(for: selectedCountry)
        }
    }
    
    
    fileprivate func displayBasicCountryInfo(for country: Country) {
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
        displayCountryFlag(flagURL: country.flagURL)
    }
    
    
    fileprivate func getCountryDetails(for country: Country) {
        
        let dataRequestURL = "https://restcountries.eu/rest/v2/alpha/\(country.alpha2Code)"
        
        Alamofire.request(dataRequestURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                self.countryDetails = JSON(response.result.value)
                self.zoomInMap()
            } else {
                self.countryDetails = nil
                #warning("Let user know that request failed")
            }
        }
        
    }
    
}


//MARK: - Flag

extension DetailsScreenViewController {
    
    fileprivate func displayCountryFlag(flagURL: String) {
        
        guard let url = URL(string: flagURL) else { return }
        
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        flagImageView.sd_setImage(with: url)
    }
    
}


//MARK: Map

extension DetailsScreenViewController {
    
    func zoomInMap() {
        let coordinates : (Double, Double) = (JSON(countryDetails)["latlng"][0].doubleValue, JSON(countryDetails)["latlng"][1].doubleValue)

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
        
        }
    
}
