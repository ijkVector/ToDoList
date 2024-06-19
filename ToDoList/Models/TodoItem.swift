//
//  TodoItem.swift
//  ToDoList
//
//  Created by Иван Дроботов on 20.06.2024.
//

import Foundation

enum Importance: String, Codable {
    case unimportant
    case routine
    case important
}

struct TodoItem: Codable {
    
    let id: String
    
    let text: String
    
    let importance: Importance
    
    let deadline: Date?
    
    let isFinished: Bool
    
    let сreationDate: Date
    
    let modifiedDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .routine,
        deadline: Date? = nil,
        isFinished: Bool = false,
        сreationDate: Date = Date(),
        modifiedDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isFinished = isFinished
        self.сreationDate = сreationDate
        self.modifiedDate = modifiedDate
    }
}
