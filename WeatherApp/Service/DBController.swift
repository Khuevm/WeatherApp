//
//  DBController.swift
//  WeatherApp
//
//  Created by Khue on 06/12/2022.
//

import Foundation
import FMDB

private let databaseName = "Weather.db"

class DBController {
    static let shared = DBController()
    var database: FMDatabase!
    
    init() {
        self.initDatabase(dbName: databaseName)
    }
    
    func getCityData() -> [City] {
        var cities = [City]()
        database.open()
        do {
            let resultSet = try DBController.shared.database.executeQuery("SELECT * FROM Country", values: nil)
            
            while resultSet.next() {
                let id = Int(resultSet.int(forColumn: "id"))
                let name = resultSet.string(forColumn: "name") ?? ""
                let isCheck = Int(resultSet.int(forColumn: "isCheck"))
                
                let city = City(id: id, name: name, isCheck: isCheck)
                cities.append(city)
            }
        } catch {
            print("Error getitng city data: \(error)")
        }
        database.close()
        return cities
    }
    
    func getCheckedCity() -> [City] {
        let cities = getCityData().filter {
            $0.isCheck == 1
        }
        return cities
    }
    
    func getCityData(contains text: String) -> [City] {
        var cities = [City]()
        database.open()
        do {
            let resultSet = try DBController.shared.database.executeQuery("SELECT * FROM Country WHERE name like '%\(text)%'", values: nil)
            
            while resultSet.next() {
                let id = Int(resultSet.int(forColumn: "id"))
                let name = resultSet.string(forColumn: "name") ?? ""
                let isCheck = Int(resultSet.int(forColumn: "isCheck"))
                
                let city = City(id: id, name: name, isCheck: isCheck)
                cities.append(city)
            }
        } catch {
            print("Error getting city data: \(error)")
        }
        database.close()
        return cities
    }
}

extension DBController {
    func initDatabase(dbName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    print("Document Directory not found")
                    return
                }
        let databaseFilePath = documentDirectory.appendingPathComponent(dbName).path
                
        //Neu db ko ton tai
        if !FileManager.default.fileExists(atPath: databaseFilePath) {
            let bundle = Bundle.main.resourceURL
            let file = bundle?.appendingPathComponent(dbName)
            
            do {
                print(databaseFilePath)
                try FileManager.default.copyItem(atPath: file!.path, toPath: databaseFilePath)
            } catch {
                print("Error copyDatabase: \(error)")
            }
            
        }
        
        database = FMDatabase.init(path: databaseFilePath)
        
    }
    
    func executeUpdate(query: String) {
        database.open()
        let _ = database.executeStatements(query)
        database.close()
    }
}
