//
//  NetworkTodoListModel.swift
//  ToDoList
//
//  Created by Иван Дроботов on 19.07.2024.
//

struct NetworkTodoListModel: Codable {
    let status: String
    let list: [NetworkTodoItem]
    let revision: Int32
}
