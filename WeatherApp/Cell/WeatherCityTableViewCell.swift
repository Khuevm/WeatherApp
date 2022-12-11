//
//  CityTableViewCell.swift
//  WeatherApp
//
//  Created by Khue on 27/09/2022.
//

import UIKit

class WeatherCityTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setData(_ weatherData: WeatherData) {
        cityLabel.text = weatherData.name
        temperatureLabel.text = String(format: "%.0f", weatherData.main.temp)+"°"
        let tempMax = "H:\(String(format: "%.0f",weatherData.main.temp_max))°"
        let tempMin = "L:\(String(format: "%.0f",weatherData.main.temp_min))°"
        
        detailLabel.text = "\(tempMax) \(tempMin)"
        
        weatherLabel.text = weatherData.weather[0].description.capitalized
        weatherImage.image = UIImage(named: weatherData.weather[0].icon_weather)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
