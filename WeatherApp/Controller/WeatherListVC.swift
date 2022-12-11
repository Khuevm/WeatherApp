//
//  WeatherListVC.swift
//  WeatherApp
//
//  Created by Khue on 27/09/2022.
//

import UIKit

class WeatherListVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    var cityData = [City]()
    var weatherManager = WeatherManager()
    var weatherCitiesData = [WeatherData]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        loadData()
    }
    
    // MARK: - Config
    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.weatherCityTableCellName, bundle: nil), forCellReuseIdentifier: K.weatherCityTableCellName)
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }

    // MARK: - IBAction
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func addButtonDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CityList", bundle: nil)
        let resultVC = storyboard.instantiateViewController(identifier: "CityListView") as CityListVC
        resultVC.modalPresentationStyle = .fullScreen
        self.present(resultVC, animated: true, completion: nil)
    }
    
    // MARK: - Helper
    func loadData() {
        weatherCitiesData = [WeatherData]()
        cityData = DBController.shared.getCheckedCity()
        for city in cityData {
            weatherManager.getWeather(cityName: city.name)
        }
    }
}

extension WeatherListVC: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger: WeatherManager, _ weather: WeatherData) {
        weatherCitiesData.append(weather)
        
        //Khi load xong cap nhat lai tableView
        if weatherCitiesData.count == cityData.count {
            self.weatherCitiesData.sort {
                $0.name! < $1.name!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func didFailwithError(error: Error) {
        print(error)
    }
    
}

// MARK: - UITableViewDataSource
extension WeatherListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCitiesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.weatherCityTableCellName, for: indexPath) as! WeatherCityTableViewCell
        
        cell.setData(weatherCitiesData[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 204
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(identifier: "MainView") as ViewController
        resultVC.modalPresentationStyle = .fullScreen
        
        //Set city
        resultVC.city = cityData[indexPath.row].name
        self.present(resultVC, animated: false, completion: nil)
    }
}
