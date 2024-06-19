//
//  FileCache.swift
//  ToDoList
//
//  Created by Иван Дроботов on 20.06.2024.
//

import Foundation

enum FileCacheError: Error {
    case itemAlreadyExists
    case documentDirectoryNotFound
    case invalidJSON
}


final class FileCache: CustomStringConvertible {
    
    private(set) var todoItems: [TodoItem] = []
    
    private let fileNames: [String]
    
    init(fileNames: [String]) {
        self.fileNames = fileNames
    }
    
    var description: String {
        todoItems.map { $0.jsonString }.description
    }
    
    func add(item: TodoItem) throws {
        guard todoItems.first(where: { $0.id == item.id }) == nil else { throw FileCacheError.itemAlreadyExists }
        
        todoItems.append(item)
    }
    
    func removeItem(by id: String) {
        todoItems.removeAll { $0.id == id }
    }
    
    func save(to file: String) throws {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.documentDirectoryNotFound
        }
        
        let filePath = dir.appendingPathComponent(file)
        try self.description.write(to: filePath, atomically: true, encoding: .utf8)
        
    }
    
    func load(from file: String) throws {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.documentDirectoryNotFound
        }
        
        let filePath = dir.appendingPathComponent(file)
        let jsonData = try Data(contentsOf: filePath)
        
        guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
            throw FileCacheError.invalidJSON
        }
        
        todoItems = jsonArray.compactMap { TodoItem.parse(json: $0) }
    }
}
