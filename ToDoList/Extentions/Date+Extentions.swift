//
//  Date+Extentions.swift
//  ToDoList
//
//  Created by Иван Дроботов on 29.06.2024.
//

import Foundation

extension Date {
    static var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: .now)!
    }
    
    var deadlineAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        return dateFormatter.string(from: self)
    }
}
