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


class DetailsScreenViewController: CustomViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nativeNameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var selectedCountry : CountryHeader?
    var countryDetails : CountryDetails?
    var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        detailsTableView.estimatedRowHeight = detailsTableView.rowHeight
        detailsTableView.rowHeight = UITableView.automaticDimension
        
        //Set up pull to reload data
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        detailsTableView.refreshControl = refresh
        
        //Define sections for details table view
        sections = [
            Section(title: "Names", items: [Item.name, Item.nativeName, Item.altSpellings, Item.translations, Item.demonym]),
            Section(title: "General Info", items: [Item.capital, Item.region, Item.subregion, Item.area, Item.population, Item.gini, Item.latlng, Item.borders]),
            Section(title: "Languages", items: [Item.languages]),
            Section(title: "Currencies", items: [Item.currencies]),
            Section(title: "Time zones", items: [Item.timezones]),
            Section(title: "Regional Blocs", items: [Item.regionalBlocs]),
            Section(title: "Codes", items: [Item.alpha2Code, Item.alpha3Code, Item.callingCodes, Item.topLevelDomain, Item.numericCode,Item.cioc])
        ]
        
        if let selectedCountry = selectedCountry {
            displayBasicCountryInfo(for: selectedCountry)
            updateCountryDetails(for: selectedCountry)
        }
    }
    
    
    fileprivate func displayBasicCountryInfo(for country: CountryHeader) {
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
        displayCountryFlag(flagURL: country.flagURL)
    }
    
    
    fileprivate func updateCountryDetails(for country: CountryHeader) {
        
        let dataRequestURL = "https://restcountries.eu/rest/v2/alpha/\(country.alpha2Code)"
        
        Alamofire.request(dataRequestURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                self.countryDetails = CountryDetails(countryDetailsJSON: JSON(response.result.value))
                self.detailsTableView.reloadData()
                self.zoomInMap()
            
            } else {
                self.countryDetails = nil
                self.showAlert(title: "Failed to load data", message: "Check your network connection.\nPull down the list to retry.")
            }
            
            self.detailsTableView.refreshControl?.endRefreshing()
        }
        
    }
    
}


//MARK: - Flag

extension DetailsScreenViewController {
    
    fileprivate func displayCountryFlag(flagURL: String) {
        
        guard let url = URL(string: flagURL) else { return }
        
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        let SVGImageSize = CGSize(width: 120, height: 60)
        flagImageView.sd_setImage(with: url, placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
    }
    
}


//MARK: - Map

extension DetailsScreenViewController {
    
    func zoomInMap() {
        
        if let countryDetails = countryDetails {
            
            let coordinates = countryDetails.latlng
            let estimatedCountrySpan = Double(countryDetails.area).squareRoot() / 100 * 1.3
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), span: MKCoordinateSpan(latitudeDelta: estimatedCountrySpan, longitudeDelta: estimatedCountrySpan))
            
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
    
}


//MARK: - Details Table View

extension DetailsScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as! DetailsTableViewCell
        
        if let countryDetails = countryDetails {
            switch sections[indexPath.section].items[indexPath.row] {
                
            case .name:
                cell.setDetail(("Name", countryDetails.name))
                
            case .topLevelDomain:
                cell.setDetail(("Top Level Domains", countryDetails.topLevelDomain.joined(separator: "\n")))
                
            case .alpha2Code:
                cell.setDetail(("alpha2Code", countryDetails.alpha2Code))
                
            case .alpha3Code:
                cell.setDetail(("alpha3Code", countryDetails.alpha3Code))
                
            case .callingCodes:
                cell.setDetail(("Calling Codes", countryDetails.callingCodes.joined(separator: "\n") ))
                
            case .capital:
                cell.setDetail(("Capital", countryDetails.capital))
                
            case .altSpellings:
                cell.setDetail(("Alternative Spellings", countryDetails.altSpellings.joined(separator: "\n")))
                
            case .region:
                cell.setDetail(("Region", countryDetails.region))
                
            case .subregion:
                cell.setDetail(("Subregion", countryDetails.subregion))
                
            case .population:
                cell.setDetail(("Population", String(countryDetails.population)))
                
            case .latlng:
                cell.setDetail(("Coordinates", "(\(countryDetails.latlng.0), \(countryDetails.latlng.1))"))
                
            case .demonym:
                cell.setDetail(("Demonym", countryDetails.demonym))
                
            case .area:
                cell.setDetail(("Area", String(countryDetails.area)))
                
            case .gini:
                cell.setDetail(("GINI", String(countryDetails.gini)))
                
            case .timezones:
                cell.setDetail(("", countryDetails.timezones.joined(separator: "\n")))
                
            case .borders:
                cell.setDetail(("Borders", countryDetails.borders.joined(separator: "\n")))
                
            case .nativeName:
                cell.setDetail(("Native Name", countryDetails.nativeName))
                
            case .numericCode:
                cell.setDetail(("Numeric Code", String(countryDetails.numericCode)))
                
            case .currencies:
                var value = ""
                for currency in countryDetails.currencies {
                    value += currency.reduce("") { result, item in "\(result)\(item.key): \(item.value)\n" }
                    value += "\n"
                }
                cell.setDetail(("", value))
                
            case .languages:
                var value = ""
                for language in countryDetails.languages {
                    value += language.reduce("") { result, item in "\(result)\(item.key): \(item.value)\n" }
                    value += "\n"
                }
                cell.setDetail(("", value))
                
            case .translations:
                cell.setDetail(("Translations", countryDetails.translations.reduce("") { result, item in "\(result)\(item.key): \(item.value)\n" }))
                
            case .flag:
                cell.setDetail(("Flag URL", countryDetails.flag))
                
            case .regionalBlocs:
                var value = ""
                for bloc in countryDetails.regionalBlocs {
                    value += "\(bloc.name)\n"
                    value += "\(bloc.acronym)\n"
                    value += bloc.otherNames.joined(separator: "\n")
                    value += bloc.otherAcronyms.joined(separator: "\n")
                    value += "\n"
                }
                cell.setDetail(("", value))
            case .cioc:
                cell.setDetail(("CIOC", countryDetails.cioc))
            }
        }

        return cell
    }
    
    
    @objc func refresh() {
        if let selectedCountry = selectedCountry {
            updateCountryDetails(for: selectedCountry)
        }
    }
    
    enum Item {
        case name
        case topLevelDomain
        case alpha2Code
        case alpha3Code
        case callingCodes
        case capital
        case altSpellings
        case region
        case subregion
        case population
        case latlng
        case demonym
        case area
        case gini
        case timezones
        case borders
        case nativeName
        case numericCode
        case currencies
        case languages
        case translations
        case flag
        case regionalBlocs
        case cioc
    }
    
    struct Section {
        let title : String
        let items : [Item]
    }
    
}
