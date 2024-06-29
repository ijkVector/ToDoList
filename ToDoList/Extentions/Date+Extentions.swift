//
//  Date+Extentions.swift
//  ToDoList
//
//  Created by Иван Дроботов on 29.06.2024.
//

import Foundation

extension Date {
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}
