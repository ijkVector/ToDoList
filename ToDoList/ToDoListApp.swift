//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Иван Дроботов on 17.06.2024.
//

import SwiftUI

@main
struct ToDoListApp: App {
//    static func main() throws {
//        let todoItem = TodoItem(
//            id: "0",
//            text: "task1",
//            importance: .unimportant,
//            deadline: Date(timeIntervalSince1970: 101),
//            isFinished: true,
//            сreationDate: Date(timeIntervalSince1970: 99),
//            modifiedDate: Date(timeIntervalSince1970: 100)
//        )
//        
//        let todoItem1 = TodoItem(
//            id: "1",
//            text: "task1",
//            importance: .routine,
//            deadline: Date(timeIntervalSince1970: 101),
//            isFinished: true,
//            сreationDate: Date(timeIntervalSince1970: 99),
//            modifiedDate: Date(timeIntervalSince1970: 100)
//        )
//        
//        let todoItem2 =  TodoItem(
//            id: "2",
//            text: "task1",
//            importance: .routine,
//            isFinished: true,
//            сreationDate: Date(timeIntervalSince1970: 100)
//        )
//        
//        let fileCache = FileCache()
//        
//        try fileCache.add(item: todoItem)
//        try fileCache.add(item: todoItem1)
//        try fileCache.add(item: todoItem2)
//        
//        try! fileCache.save(to: "a.csv", with: .csv)
//        try! fileCache.load(from: "a.csv", with: .csv)
//        var text = fileCache.todoItems[0].text
//        text.removeLast()
//        text.removeFirst()
//        print(text)
//    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
