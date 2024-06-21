//
//  FileCacheProtocol.swift
//  ToDoList
//
//  Created by Иван Дроботов on 21.06.2024.
//

protocol FileCacheProtocol {
    var todoItems: [TodoItem] { get }
    
    func add(item: TodoItem) throws
    func removeItem(by id: String)
    func save(to file: String, with format: FileFormat, by separator: String) throws
    func load(from file: String, with format: FileFormat, by separator: String) throws
}
