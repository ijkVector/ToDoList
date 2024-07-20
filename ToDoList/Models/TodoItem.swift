//
//  TodoItem.swift
//  ToDoList
//
//  Created by Иван Дроботов on 20.06.2024.
//

import Foundation

enum Importance: String {
    case low
    case basic
    case important
}

// MARK: - TodoItem Defenition
struct TodoItem: Equatable, Identifiable {

    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let changedAt: Date?
    let hexColor: String?
    let files: [String]?

    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdAt: Date = Date(),
        changedAt: Date? = nil,
        hexColor: String? = nil,
        files: [String]? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.changedAt = changedAt
        self.hexColor = hexColor
        self.files = files
    }

    init(todoItem: TodoItem) {
        self.init(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isDone: !todoItem.isDone,
            createdAt: todoItem.createdAt,
            changedAt: todoItem.changedAt,
            hexColor: todoItem.hexColor
        )
    }

    init(networkItem: NetworkTodoItem) {
        self.init(
            id: networkItem.id,
            text: networkItem.text,
            importance: Importance(rawValue: networkItem.importance) ?? .basic,
            deadline: networkItem.deadline,
            isDone: !networkItem.isDone,
            createdAt: networkItem.createdAt,
            changedAt: networkItem.changedAt,
            hexColor: networkItem.color,
            files: networkItem.files
        )
    }
}
