//
//  ViewController.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 06/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit

var countries = [CountryHeader]()

let searchController = UISearchController(searchResultsController: nil)
var filteredCountries = [CountryHeader]()


class MainScreenViewController: CustomViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCountriesTableView()
        updateCountriesArray()
    }
    
    
    fileprivate func updateCountriesArray() {
        
        let url = URL(string: "https://restcountries.eu/rest/v2/all/?fields=name;nativeName;flag;alpha2Code")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                
                do {
                    countries = try JSONDecoder().decode([CountryHeader].self, from: data)
                    DispatchQueue.main.async {
                        self.countriesTableView.reloadData()
                    }
                    
                } catch {
                    print("Failed to parse JSON")
                }
                
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Failed to load data", message: "Check your network connection.\nPull down the list to retry.")
                }
            }
            
            DispatchQueue.main.async {
                self.countriesTableView.refreshControl?.endRefreshing()
            }
            
            }.resume()
        
    }
    
}




//MARK: - Table View

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func setUpCountriesTableView() {
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
        
        countriesTableView.estimatedRowHeight = countriesTableView.rowHeight
        countriesTableView.rowHeight = UITableView.automaticDimension
        
        setUpSearchController()
        setUpPullToRefresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredCountries.count : countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryCell
        let country = isFiltering() ? filteredCountries[indexPath.row] : countries[indexPath.row]
        cell.setUpCell(for: country)
        return cell
    }

    fileprivate func setUpPullToRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        countriesTableView.refreshControl = refresh
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
