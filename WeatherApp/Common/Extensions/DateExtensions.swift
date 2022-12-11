//
//  DateExtensions.swift
//  WeatherApp
//
//  Created by Khue on 15/09/2022.
//

import Foundation

extension Date {
    static func getDayOfWeek(_ date:String, format: String) -> String? {
        let weekDays = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
        ]
        
        let formatter  = DateFormatter()
        formatter.dateFormat = format
        guard let todayDate = formatter.date(from: date) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        
        return weekDays[weekDay-1]
    }
    
}
