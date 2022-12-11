//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Khue on 04/08/2022.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager, _ weather: WeatherData)
    func didFailwithError(error: Error)
    func didUpdateHoursWeather(_ weatherManger: WeatherManager, _ weather: [WeatherData])
}

extension WeatherManagerDelegate {
    func didUpdateHoursWeather(_ weatherManger: WeatherManager, _ weather: [WeatherData]) {
        //
    }
}

struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    let apiKey = "e800afc8fee0487e98a21761ad8b0e66"
    let baseHoursURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func getWeatherByHours(cityName: String) {
        let weatherURL = "\(baseHoursURL)&appid=\(apiKey)&q=\(cityName)"
        print(weatherURL)
        performHoursRequest(url: weatherURL)
    }
    
    func getWeatherByHours(lat: Double, lon: Double) {
        let weatherURL = "\(baseHoursURL)&appid=\(apiKey)&lat=\(lat)&lon=\(lon)"
        print(weatherURL)
        performHoursRequest(url: weatherURL)
    }
    
    func getWeather(cityName: String) {
        let weatherURL = "\(baseURL)&appid=\(apiKey)&q=\(cityName)"
        print(weatherURL)
        performRequest(url: weatherURL)
    }
    
    func getWeather(lat: Double, lon: Double) {
        let weatherURL = "\(baseURL)&appid=\(apiKey)&lat=\(lat)&lon=\(lon)"
        print(weatherURL)
        performRequest(url: weatherURL)
    }
    
    private func performRequest(url: String){
        if let safeURL = URL(string: url) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: safeURL) { data, response, error in
                if error != nil {
                    delegate?.didFailwithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weatherData = parseJSON(data: safeData) {
                        delegate?.didUpdateWeather(self, weatherData)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedWeather = try decoder.decode(WeatherData.self, from: data)
            return decodedWeather
        } catch {
            delegate?.didFailwithError(error: error)
            return nil
        }
    }
    
    private func performHoursRequest(url: String){
        if let safeURL = URL(string: url) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: safeURL) { data, response, error in
                if error != nil {
                    delegate?.didFailwithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weatherHoursData = parseHoursJSON(data: safeData) {
                        delegate?.didUpdateHoursWeather(self, weatherHoursData)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseHoursJSON(data: Data) -> [WeatherData]? {
        let decoder = JSONDecoder()
        var weatherData: [WeatherData] = []
        
        do {
            let decodedWeather = try decoder.decode(WeatherByHours.self, from: data)
            for i in 0..<decodedWeather.list.count {
                if i%8==0 {
                    //Get data of each day
                    weatherData.append(decodedWeather.list[i])
                }
            }
//            print(weatherData)
            return weatherData
        } catch {
            delegate?.didFailwithError(error: error)
            return nil
        }
    }
}
