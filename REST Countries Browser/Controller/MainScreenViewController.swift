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

var countries = [CountryHeader]()

let searchController = UISearchController(searchResultsController: nil)
var filteredCountries = [CountryHeader]()


class MainScreenViewController: CustomViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
        setUpSearchController()
        
        //Set up pull to reload data
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        countriesTableView.refreshControl = refresh

        updateCountriesArray()
    }
        
    fileprivate func updateCountriesArray() {
        
        let filteredDataURL = "https://restcountries.eu/rest/v2/all?fields=name;nativeName;flag;alpha2Code"
        
        Alamofire.request(filteredDataURL, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                if let value = response.result.value {
                    
                    let RESTCountriesJSON = JSON(value).arrayValue
                    
                    countries = RESTCountriesJSON.map { CountryHeader(name: JSON($0)["name"].stringValue, nativeName: JSON($0)["nativeName"].stringValue, flagURL: JSON($0)["flag"].stringValue, alpha2Code: JSON($0)["alpha2Code"].stringValue)}
                    self.countriesTableView.reloadData()
                }

            } else {
    
                self.showAlert(title: "Failed to load data", message: "Check your network connection.\nPull down the list to retry.")
            }
            
            self.countriesTableView.refreshControl?.endRefreshing()
        }
        
    }
    
}


//MARK: - Table View

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredCountries.count : countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryCell
        let country = isFiltering() ? filteredCountries[indexPath.row] : countries[indexPath.row]
        cell.setCountry(country)
        return cell
    }

    @objc func refresh() {
        updateCountriesArray()
    }
}


//MARK: - Search bar

extension MainScreenViewController: UISearchResultsUpdating {

    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCountries = countries.filter({( country : CountryHeader) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased()) || country.nativeName.lowercased().contains(searchText.lowercased())
        })
        
        countriesTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}


//MARK: - Segues

extension MainScreenViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToDetails" {
            if let destination = segue.destination as? DetailsScreenViewController,
                let index = countriesTableView.indexPathsForSelectedRows?.first {
                destination.selectedCountry = isFiltering() ? filteredCountries[index.row] : countries[index.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MainToDetails", sender: self)
    }
    
}
