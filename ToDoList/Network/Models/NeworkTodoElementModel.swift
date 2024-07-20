//
//  NeworkTodoElementModel.swift
//  ToDoList
//
//  Created by Иван Дроботов on 19.07.2024.
//

struct NetworkTodoElementModel: Codable {
    let status: String
    let element: NetworkTodoItem
    let revision: Int32
}
