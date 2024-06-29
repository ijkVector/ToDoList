//
//  DateFormatter+Extentions.swift
//  ToDoList
//
//  Created by Иван Дроботов on 29.06.2024.
//

import Foundation

extension DateFormatter {
    var ruDateFormatter: DateFormatter {
        self.dateFormat = "d MMMM yyyy"
        self.locale = Locale(identifier: "ru_RU")
        return self
    }
}
