//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Khue on 04/08/2022.
//

import Foundation

struct WeatherData: Decodable {
    let name: String?
    let weather: [Weather]
    let main: Main
    let dt_txt: String?
    let visibility: Int?
    let wind: Wind?
    let sys: Sys?
    let timezone: Int?
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double?
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
    let pressure: Int?
}

struct Weather: Decodable {
    let id: Int
    let description: String
    
    var icon_weather: String {
        switch id {
        case 200...232:
            return "ic_bolt"
        case 300...321:
            return "ic_drizzle"
        case 500...531:
            return "ic_rain"
        case 600...622:
            return "ic_snow"
        case 701...781:
            return "ic_fog"
        case 800:
            return "ic_sun"
        case 801...804:
            return "ic_cloud"
        default:
            return "ic_tornado"
        }
        }
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Double?
}

struct Sys: Decodable {
    let sunrise: Date?
    let sunset: Date?
}
