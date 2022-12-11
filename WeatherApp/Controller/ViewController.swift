//
//  ViewController.swift
//  WeatherApp
//
//  Created by Khue on 04/08/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var weatherHoursView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    // MARK: - Variable
    var weatherHoursData: [WeatherData]?
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var weatherData: WeatherData?
    
    //Neu click city tren man weatherList thi hien thi thoi tiet tai thanh pho do
    var city: String? = nil
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherHoursView.layer.cornerRadius = 44
        
        configCollectionView()
        configCoreLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Neu city != nil lay thoi tiet o vi tri hien tai
        if city == nil {
            locationManager.requestLocation()
        } else {
            weatherManager.getWeather(cityName: city!)
            weatherManager.getWeatherByHours(cityName: city!)
        }
    }
    
    // MARK: - Config
    func configCollectionView() {
        weatherManager.delegate = self
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        weatherCollectionView.register(UINib(nibName: K.weatherCollectionName, bundle: nil), forCellWithReuseIdentifier: K.weatherCollectionName)
    }
    
    func configCoreLocation(){
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    // MARK: - IBAction
    @IBAction func moreButtonDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let resultVC = storyboard.instantiateViewController(identifier: "DetailView") as DetailVC
        
        resultVC.weatherData = weatherData
        
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: true, completion: nil)
    }
    
    @IBAction func currentButtonDidTap(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    @IBAction func listButtonDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "WeatherList", bundle: nil)
                
        let resultVC = storyboard.instantiateViewController(identifier: "WeatherListView") as WeatherListVC
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: false, completion: nil)
        
    }
    
    // MARK: - Helper
    func updateWeatherUI(_ weatherData: WeatherData){
        cityLabel.text = weatherData.name
        temperatureLabel.text = String(format: "%.0f", weatherData.main.temp)+"°"
        let description = weatherData.weather[0].description.capitalized
        let tempMax = "H:\(String(format: "%.0f",weatherData.main.temp_max))°"
        let tempMin = "L:\(String(format: "%.0f",weatherData.main.temp_min))°"
        
        let attributed1 = NSMutableAttributedString(string: "\(description)\n")
        attributed1.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: attributed1.length))
        
        let attributed2 = NSMutableAttributedString(string: "\(tempMax) \(tempMin)")
        attributed2.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attributed2.length))
        
        attributed1.append(attributed2)
        self.detailLabel.attributedText = attributed1
    }

}

// MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
    func didUpdateHoursWeather(_ weatherManger: WeatherManager, _ weather: [WeatherData]) {
        weatherHoursData = weather
        DispatchQueue.main.async {
            self.weatherCollectionView.reloadData()
        }
        
    }
    
    func didUpdateWeather(_ weatherManger: WeatherManager, _ weather: WeatherData) {
        weatherData = weather
        DispatchQueue.main.async {
            self.updateWeatherUI(weather)
        }
    }
    
    func didFailwithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.getWeather(lat: lat, lon: lon)
            weatherManager.getWeatherByHours(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: weatherCollectionView.frame.height)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if weatherHoursData != nil {
            return 5
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: K.weatherCollectionName, for: indexPath) as! WeatherCollectionViewCell
        if weatherHoursData != nil {
            let weather = weatherHoursData![indexPath.row]
            cell.tempLabel.text = String.init(format: "%.0f", weather.main.temp) + "°"
            cell.humidLabel.text = "\(weather.main.humidity)%"
            cell.weatherImage.image = UIImage(named: weather.weather[0].icon_weather)
            cell.timeLabel.text = Date.getDayOfWeek(weather.dt_txt!, format: "yyyy-MM-dd HH:mm:ss")
        }
        return cell
    }
}
