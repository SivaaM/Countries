//
//  ServiceManager.swift
//  Countries
//
//  Created by Sivakumar Muniappan on 9/9/22.
//

import Foundation

class ServiceManager {
    static func getListOfCountries(complete: @escaping([Country]) -> ()) {
        
        let apiURL = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        
        let url = URL(string: apiURL)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            if let error = error {
                print("Error fetching countries list \(error)")
            }
            
            if let data = data, let cntrs = try?
                JSONDecoder().decode([Country].self, from: data) {
                    DispatchQueue.main.async {
                        complete(cntrs)
                    }
            }
        })
        task.resume()
    }
}
