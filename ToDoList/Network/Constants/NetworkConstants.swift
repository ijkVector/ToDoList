//
//  NetworkConstants.swift
//  ToDoList
//
//  Created by Иван Дроботов on 19.07.2024.
//

enum NetworkConstants {
    static let token = "Bearer Gwindor"
    static let baseURl = "https://beta.mrdekk.ru/todo"
    static let todoListURL = "\(baseURl)/list"
    static let lastRevision = "X-Last-Known-Revision"
    static let contentType = "Content-Type"
    static let jsonType = "application/json"
    static let authorization = "Authorization"
}
