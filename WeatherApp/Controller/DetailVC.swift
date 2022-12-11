//
//  DetailVC.swift
//  WeatherApp
//
//  Created by Khue on 04/08/2022.
//

import UIKit

class DetailVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    //Detail
    @IBOutlet weak var feelLikesTemperatureLabel: UILabel!
    @IBOutlet weak var feelLikesInfoLabel: UILabel!
    
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
    @IBOutlet weak var windArrowImage: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var visibilityLabel: UILabel!
    
    // MARK: - Variable
    var weatherData: WeatherData?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(weatherData)
        
        if weatherData != nil {
            updateUI()
        }
    }
    
    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Config
    func updateUI() {
        cityLabel.text = weatherData!.name
        weatherLabel.text = "\(round(weatherData!.main.temp))° | \(weatherData!.weather[0].description.capitalized)"

        //feel likes
        var feelLikesInfo: String {
            let range = round(weatherData!.main.feels_like ?? 0) - round(weatherData!.main.temp)
            switch range {
            case 0:
                return "Similar to the actual temperature"
            case ..<0:
                return "\(abs(range))° lower than actual temperature"
            default:
                return "\(range)° higher than actual temperature"
            }
        }
        feelLikesTemperatureLabel.text =  "\(round(weatherData!.main.feels_like ?? 0))°"
        feelLikesInfoLabel.text = feelLikesInfo
        
        //sun
        let timezone = weatherData!.timezone ?? 0
        sunriseTimeLabel.text = getDateStringFromUTC(date: weatherData!.sys?.sunrise, timezone: timezone)
        sunsetTimeLabel.text = "Sunset: " + getDateStringFromUTC(date: weatherData!.sys?.sunset, timezone: timezone)
        
        //wind
        windLabel.text = String(format: "%.0f",weatherData!.wind?.speed ?? "--")
        windArrowImage.transform = windArrowImage.transform.rotated(by: .pi/180*(weatherData!.wind?.deg ?? 0))
        
        //pressure
        pressureLabel.text = "\(weatherData!.main.pressure ?? 0)"
        
        //humidity
        humidityLabel.text = "\(weatherData!.main.humidity)%"
        
        //visibility
        let visibility = weatherData!.visibility ?? 0
        visibilityLabel.text = "\(visibility/1000)km"
    }
    
    // MARK: - Helper
    func getDateStringFromUTC(date: Date?, timezone: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date ?? Date())
    }
}
