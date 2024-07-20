//
//  NetworkTodoItem.swift
//  ToDoList
//
//  Created by Иван Дроботов on 19.07.2024.
//

import Foundation
import UIKit

struct NetworkTodoItem: Codable {
    let id: String
    let text: String
    let importance: String
    let deadline: Date?
    let isDone: Bool
    let color: String?
    let createdAt: Date
    let changedAt: Date
    let lastUpdatedBy: String
    let files: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case isDone = "done"
        case color
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
        case files = "files"
    }

    init(modelItem: TodoItem) {
        self.id = modelItem.id
        self.text = modelItem.text
        self.importance = modelItem.importance.rawValue
        self.deadline = modelItem.deadline
        self.isDone = modelItem.isDone
        self.color = modelItem.hexColor
        self.createdAt = modelItem.createdAt
        self.changedAt = modelItem.changedAt ?? Date()
        self.lastUpdatedBy = UIDevice.current.identifierForVendor?.uuidString ?? "some device"
        self.files = nil
    }
}
