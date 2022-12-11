//
//  CityListVC.swift
//  WeatherApp
//
//  Created by Khue on 11/10/2022.
//

import UIKit

class CityListVC: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    var cityData = [City]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCityData()

        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Config
    
    // MARK: - IBAction
    @IBAction func backButtonDidTab(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Helper
    func loadCityData(){
        cityData = DBController.shared.getCityData()
    }
}

// MARK: - UITableViewDataSource
extension CityListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "CityTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath)
        let currentCity = cityData[indexPath.row]
        cell.textLabel?.text = currentCity.name
        cell.accessoryType = currentCity.isCheck == 1 ? .checkmark : .none
        cell.tintColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData.count
    }
    
    
}

// MARK: - UITableViewDelegate
extension CityListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCity = cityData[indexPath.row]
        currentCity.updateIsCheck()
        cityData[indexPath.row].isCheck = currentCity.isCheck == 1 ? 0 : 1
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension CityListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            cityData = DBController.shared.getCityData(contains: searchBar.text!)
            tableView.reloadData()
        } else {
            cityData = DBController.shared.getCityData()
        }
    }
}
