//
//  DetailsScreenViewController.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 07/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit
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
    
    //Define structure of sections for details table view
    let sections : [Section] = [
        Section(title: "Names", items: [Item.name, Item.nativeName, Item.altSpellings, Item.translations, Item.demonym]),
        Section(title: "General Info", items: [Item.capital, Item.region, Item.subregion, Item.area, Item.population, Item.gini, Item.latlng, Item.borders, Item.timezones, Item.flag]),
        Section(title: "Languages", items: [Item.languages]),
        Section(title: "Currencies", items: [Item.currencies]),
        Section(title: "Regional Blocs", items: [Item.regionalBlocs]),
        Section(title: "Codes", items: [Item.alpha2Code, Item.alpha3Code, Item.callingCodes, Item.topLevelDomain, Item.numericCode,Item.cioc])]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCountryFlagImageViewSize()
        
        nameLabel.textColor = MyPalette.baseText
        nativeNameLabel.textColor = MyPalette.baseText
        
        setUpDetailsTableView()

        if let selectedCountry = selectedCountry {
            displayBasicCountryInfo(for: selectedCountry)
            updateCountryDetails(for: selectedCountry)
        }
    }
    
    
    fileprivate func displayBasicCountryInfo(for country: CountryHeader) {
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
        displayCountryFlag(flagURL: country.flag)
    }
    
    
    fileprivate func updateCountryDetails(for country: CountryHeader) {
        
        let url = URL(string: "https://restcountries.eu/rest/v2/alpha/\(country.alpha2Code)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                
                do {
                    self.countryDetails = try JSONDecoder().decode(CountryDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.detailsTableView.reloadData()
                        self.displayCountryFlag(flagURL: self.countryDetails?.flag ?? self.selectedCountry?.flag ?? "")
                        self.zoomInMap()
                    }

                } catch {
                    print("Failed to parse JSON")
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to load data", message: "Check your network connection.\nPull down the list below the map to retry.")
                }
            }
            
            DispatchQueue.main.async {
                self.detailsTableView.refreshControl?.endRefreshing()
            }
            
            }.resume()
        
    }
    
}


//MARK: - Flag

extension DetailsScreenViewController {
  

    fileprivate func setCountryFlagImageViewSize() {
        
        let height = UIScreen.main.bounds.size.height * 0.07
        let width = height * 2
        
        flagImageView.addConstraint(NSLayoutConstraint(
            item: flagImageView!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: height))
        
        flagImageView.addConstraint(NSLayoutConstraint(
            item: flagImageView!,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: width))
    }
    
    
    fileprivate func displayCountryFlag(flagURL: String) {
        
        guard let url = URL(string: flagURL) else { return }
        
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        let height = UIScreen.main.bounds.size.height * 0.07
        let width = height * 1.5
        
        let SVGImageSize = CGSize(width: width, height: height)
        flagImageView.sd_setImage(with: url, placeholderImage: nil, options: [], context: [.svgImageSize : SVGImageSize])
    }
    
}


//MARK: - Map

extension DetailsScreenViewController {
    
    func zoomInMap() {
        
        if let countryDetails = countryDetails {
            
            let coordinates = (countryDetails.latlng[0], countryDetails.latlng[1])
            let area = countryDetails.area ?? 1000.0
            let estimatedCountrySpan = area.squareRoot() / 100 * 1.3
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1), span: MKCoordinateSpan(latitudeDelta: estimatedCountrySpan, longitudeDelta: estimatedCountrySpan))
            
            self.mapView.setRegion(region, animated: true)

        }
        
    }
    
}


//MARK: - Details Table View

extension DetailsScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setUpDetailsTableView() {
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        detailsTableView.backgroundColor = MyPalette.background
        
        detailsTableView.estimatedRowHeight = detailsTableView.rowHeight
        detailsTableView.rowHeight = UITableView.automaticDimension
        
        detailsTableView.addConstraint(NSLayoutConstraint(
            item: detailsTableView!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: UIScreen.main.bounds.size.height / 3))
        
        //Set up pull to reload data
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        refresh.backgroundColor = MyPalette.background
        detailsTableView.refreshControl = refresh
    }
    
    
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
                cell.setUpCell(("Name", countryDetails.name))
                
            case .topLevelDomain:
                cell.setUpCell(("Top Level Domains", countryDetails.topLevelDomain.joined(separator: "\n")))
                
            case .alpha2Code:
                cell.setUpCell(("alpha2Code", countryDetails.alpha2Code))
                
            case .alpha3Code:
                cell.setUpCell(("alpha3Code", countryDetails.alpha3Code))
                
            case .callingCodes:
                cell.setUpCell(("Calling Codes", countryDetails.callingCodes.joined(separator: "\n") ))
                
            case .capital:
                cell.setUpCell(("Capital", countryDetails.capital))
                
            case .altSpellings:
                cell.setUpCell(("Alternative Spellings", countryDetails.altSpellings.joined(separator: "\n")))
                
            case .region:
                cell.setUpCell(("Region", countryDetails.region))
                
            case .subregion:
                cell.setUpCell(("Subregion", countryDetails.subregion))
                
            case .population:
                cell.setUpCell(("Population", countryDetails.population.asStringWithSeparator))

            case .latlng:
                
                cell.setUpCell(("Coordinates", "(\(countryDetails.latlng[0]), \(countryDetails.latlng[1] ))"))
            
            case .demonym:
                cell.setUpCell(("Demonym", countryDetails.demonym))
                
            case .area:
                cell.setUpCell(("Area", "\(countryDetails.area ?? 0.0)"))
                
            case .gini:
                cell.setUpCell(("GINI", String(countryDetails.gini ?? 0.0)))
                
            case .timezones:
                cell.setUpCell(("Time Zones", countryDetails.timezones.joined(separator: "\n")))
                
            case .borders:
                cell.setUpCell(("Borders", countryDetails.borders.joined(separator: "\n")))
                
            case .nativeName:
                cell.setUpCell(("Native Name", countryDetails.nativeName))
                
            case .numericCode:
                cell.setUpCell(("Numeric Code", countryDetails.numericCode ?? ""))
                
            case .currencies:
                cell.setUpCell(("", countryDetails.currencies.map { "\($0.name ?? "")\nsymbol: \($0.symbol ?? "")\ncode: \($0.code ?? "")\n" } .joined(separator: "\n")))
                
            case .languages:
                cell.setUpCell(("", countryDetails.languages.map { "\($0.name ?? "") (\($0.nativeName ?? ""))\niso639_1: \($0.iso639_1 ?? "")\niso639_2: \($0.iso639_2 ?? "")\n" } .joined(separator: "\n") ))
                
            case .translations:
                cell.setUpCell(("Translations", countryDetails.translations.map { "\($0.key): \($0.value ?? "")" }.joined(separator: "\n")))

            case .flag:
                cell.setUpCell(("Flag URL", countryDetails.flag))
                
            case .regionalBlocs:
                var value = ""
                for bloc in countryDetails.regionalBlocs {
                    value += "\(bloc.name) (\(bloc.acronym))\n"
                    if !bloc.otherNames.isEmpty { value += "Other names:\n" }
                    value += bloc.otherNames.joined(separator: "\n")
                    if !bloc.otherAcronyms.isEmpty { value += "Other acronyms:\n" }
                    value += bloc.otherAcronyms.joined(separator: "\n")
                    value += "\n\n"
                }
                cell.setUpCell(("", value))

            case .cioc:
                cell.setUpCell(("CIOC", countryDetails.cioc ?? ""))
            }
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.tintColor = MyPalette.header
        header.textLabel?.font = MyFonts.bold
        header.textLabel?.textColor = MyPalette.baseText
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
