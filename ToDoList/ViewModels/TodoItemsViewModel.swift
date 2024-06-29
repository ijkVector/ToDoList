//
//  TodoItemsViewModel.swift
//  ToDoList
//
//  Created by Иван Дроботов on 29.06.2024.
//

import Foundation

final class TodoItemsViewModel: ObservableObject {
    @Published var todoItems = [TodoItem]()
    
    func add(_ item: TodoItem) {
        guard todoItems.first(where: { $0.id == item.id }) == nil else {
            return
        }
        todoItems.append(item)
    }
    
    func delete(_ item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
    }
    
    func update(_ item: TodoItem) {
        guard let i = todoItems.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        todoItems[i] = item
    }
}
