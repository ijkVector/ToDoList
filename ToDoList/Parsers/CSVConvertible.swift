//
//  CSVConvertible.swift
//  ToDoList
//
//  Created by Иван Дроботов on 21.06.2024.
//

protocol CSVConvertible {
    
    static func parse(csv: Any, with separator: String) -> TodoItem?
    
    static func getHeader(with separator: String) -> String
    
    func csv(with separator: String) -> String
}
