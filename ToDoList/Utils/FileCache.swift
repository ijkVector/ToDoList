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
    case invalidCSV
    case fileNotFound
}

enum FileFormat {
    case json
    case csv
}

final class FileCache: FileCacheProtocol {
    
    private(set) var todoItems: [TodoItem] = []
    
    func add(item: TodoItem) throws {
        guard todoItems.first(where: { $0.id == item.id }) == nil else { throw FileCacheError.itemAlreadyExists
        }
        
        todoItems.append(item)
    }
    
    func removeItem(by id: String) {
        todoItems.removeAll { $0.id == id }
    }
    
    func save(to file: String, with format: FileFormat = .json, by separator: String = ",") throws {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.documentDirectoryNotFound
        }
        let filePath = dir.appendingPathComponent(file)
        
        switch format {
        case .json:
            let jsonArray = todoItems.map { $0.json }
            guard JSONSerialization.isValidJSONObject(jsonArray) else {
                throw FileCacheError.invalidJSON
            }
            try jsonArray.description.write(to: filePath, atomically: true, encoding: .utf8)
        case .csv:
            let csvData = ([TodoItem.getHeader(with: separator)] + todoItems.map { $0.csv(with: separator) })
                .joined(separator: "/n")
            try csvData.write(to: filePath, atomically: true, encoding: .utf8)
        }
    }
    
    func load(from file: String, with format: FileFormat = .json, by separator: String = ",") throws {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.documentDirectoryNotFound
        }
        let filePath = dir.appendingPathComponent(file)
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            throw FileCacheError.fileNotFound
        }
        
        switch format {
        case .json:
            let data = try Data(contentsOf: filePath)
            guard let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [Any] else {
                throw FileCacheError.invalidJSON
            }
            todoItems = jsonArray.compactMap { TodoItem.parse(json: $0) }
        case .csv:
            guard let data = try? String(contentsOf: filePath) else {
                throw FileCacheError.invalidCSV
            }
            var csvRows = data.components(separatedBy: "/n")
            csvRows.removeFirst()
            todoItems = csvRows.compactMap { TodoItem.parse(csv: $0, with: separator) }
        }
    }
}
