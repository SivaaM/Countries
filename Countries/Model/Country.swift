//
//  Country.swift
//  Countries
//
//  Created by Sivakumar Muniappan on 9/9/22.
//

import Foundation

struct Country: Codable {
    let name: String
    let capital: String
    let region: String?
    let code: String
}
