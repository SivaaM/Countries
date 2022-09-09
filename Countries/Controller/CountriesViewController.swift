//
//  CountriesViewController.swift
//  Countries
//
//  Created by Sivakumar Muniappan on 9/9/22.
//

import UIKit

class CountriesViewController: UITableViewController {

    private var countries : [Country] = []
    private var filteredCountries: [Country] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        invokeAPI()
    }
}

// MARK: - Setup UI

extension CountriesViewController {
    
    private func setupUI() {
        self.title = "Countries"
        addSearchController()
    }
    
    private func addSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterCountriesForSearchText(_ searchText: String) {
        filteredCountries = countries.filter { (country: Country) -> Bool in
            return country.name.lowercased().contains(searchText.lowercased()) ||
                   country.capital.lowercased().contains(searchText.lowercased())
            
        }
        tableView.reloadData()
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
}

// MARK: - Network Call

extension CountriesViewController {
    private func invokeAPI() {
        ServiceManager.getListOfCountries(complete: {(countries) in
            self.countries = countries
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}

// MARK: - TableView DataSource

extension CountriesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredCountries.count
        }
        return countries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryViewCell", for: indexPath) as! CountryTableViewCell
        let country: Country
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        cell.name.text = country.name
        cell.capital.text = country.capital
        cell.code.text = country.code
        cell.region.text = country.region
        
        return cell
    }
}


// MARK: - Handling Search Results
extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterCountriesForSearchText(searchBar.text!)
    }
}
