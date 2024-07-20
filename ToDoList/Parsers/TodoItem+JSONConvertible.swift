//
//  TodoItem+JSONConvertible.swift
//  ToDoList
//
//  Created by Иван Дроботов on 28.06.2024.
//

import Foundation
import FileCacheUtil

// MARK: - Parse JSON
extension TodoItem: JSONConvertible {
    // MARK: - From Json to TodoItem
    static func parse(json: Any) -> TodoItem? {
        guard let jsonAsString = json as? String else { return nil } // Можно ли сократить ?
        let jsonData = Data(jsonAsString.utf8)

        guard let jsonAsDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let id = jsonAsDictionary["id"] as? String,
              let text = jsonAsDictionary["text"] as? String,
              let isDone = jsonAsDictionary["isFinished"] as? Bool,
              let сreationTimeInterval = jsonAsDictionary["сreationDate"] as? TimeInterval
        else { return nil }

        let createdAt = Date(timeIntervalSince1970: сreationTimeInterval)
        let importance = (jsonAsDictionary["importance"] as? String).flatMap(Importance.init(rawValue:)) ?? .basic
        let deadline = (jsonAsDictionary["deadline"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        let changedAt = (jsonAsDictionary["modifiedDate"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))

        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            createdAt: createdAt,
            changedAt: changedAt
        )
    }

    // MARK: - From TodoItme to Json
    var json: Any {
        var dict = [String: Any]()
        dict["id"] = id
        dict["text"] = text
        dict["importance"] = importance == .basic ? nil : importance.rawValue
        dict["deadline"] = deadline == nil ? nil : deadline?.timeIntervalSince1970
        dict["isFinished"] = isDone
        dict["сreationDate"] = createdAt.timeIntervalSince1970
        dict["modifiedDate"] = changedAt == nil ? nil : changedAt?.timeIntervalSince1970
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
