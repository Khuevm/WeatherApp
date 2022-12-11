//
//  City.swift
//  WeatherApp
//
//  Created by Khue on 07/12/2022.
//

import Foundation

struct City {
    let id: Int
    let name: String
    var isCheck: Int //0: No, 1: Yes
    
    func updateIsCheck() {
        let check = isCheck == 1 ? 0 : 1
        DBController.shared.executeUpdate(query: "UPDATE Country SET ischeck = \(check) WHERE id = \(id)")
    }
}
