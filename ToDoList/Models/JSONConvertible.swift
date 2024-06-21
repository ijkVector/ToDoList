//
//  JSONConvertible.swift
//  ToDoList
//
//  Created by Иван Дроботов on 21.06.2024.
//

protocol JSONConvertible {
    
    static func parse(json: Any) -> TodoItem?
    
    var json: Any { get }
}
