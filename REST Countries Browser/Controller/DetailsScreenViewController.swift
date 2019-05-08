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
    var countryDetails : CountryDetails?
    var simpleArray = [(String, String)]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        if let selectedCountry = selectedCountry {
            displayBasicCountryInfo(for: selectedCountry)
            updateCountryDetails(for: selectedCountry)
            
        }
    }
    
    
    fileprivate func displayBasicCountryInfo(for country: Country) {
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
        displayCountryFlag(flagURL: country.flagURL)
    }
    
    
    fileprivate func updateCountryDetails(for country: Country) {
        
        let dataRequestURL = "https://restcountries.eu/rest/v2/alpha/\(country.alpha2Code)"
        
        Alamofire.request(dataRequestURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                self.countryDetails = CountryDetails(countryDetailsJSON: JSON(response.result.value))
                self.zoomInMap()
                if let countryDetails = self.countryDetails {
                    self.simpleArray = countryDetails.asSimpleArray()
                    self.detailsTableView.reloadData()
                }

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


//MARK: - Map

extension DetailsScreenViewController {
    
    func zoomInMap() {
        
        if let countryDetails = countryDetails {
            
            let coordinates = countryDetails.latlng
            let estimatedCountrySpan = Double(countryDetails.area).squareRoot() / 100
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), span: MKCoordinateSpan(latitudeDelta: estimatedCountrySpan, longitudeDelta: estimatedCountrySpan))
            
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
    
}


//MARK: - Details Table View

extension DetailsScreenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as! DetailsTableViewCell
        cell.setDetail(simpleArray[indexPath.row])
        return cell
    }
    
    
}
