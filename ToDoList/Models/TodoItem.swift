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

//MARK: - TodoItem Defenition
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

//MARK: - Parse JSON
extension TodoItem {
    //MARK: - From Json to TodoItem
    static func parse(json: Any) -> TodoItem? {
        guard let jsonAsString = json as? String else { return nil }
        let jsonData = Data(jsonAsString.utf8)
        
        guard let jsonAsDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let id = jsonAsDictionary["id"] as? String,
              let text = jsonAsDictionary["text"] as? String,
              let isFinished = jsonAsDictionary["isFinished"] as? Bool,
              let сreationTimeInterval = jsonAsDictionary["сreationDate"] as? TimeInterval else { return nil }
        
        let сreationDate = Date(timeIntervalSince1970: сreationTimeInterval)
        var importance: Importance = .routine
        var deadline: Date?
        var modifiedDate: Date?
        
        if let rawValue = jsonAsDictionary["importance"] as? String, let value = Importance(rawValue: rawValue) {
            importance = value
        }
        
        if let deadlineTimeInterval = jsonAsDictionary["deadline"] as? TimeInterval {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        
        if let modifiedDateTimeInterval = jsonAsDictionary["modifiedDate"] as? TimeInterval {
            modifiedDate = Date(timeIntervalSince1970: modifiedDateTimeInterval)
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            сreationDate: сreationDate,
            modifiedDate: modifiedDate
        )
    }
}

