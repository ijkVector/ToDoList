//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Иван Дроботов on 17.06.2024.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let store = Store(reducer: appReducer, state: AppState())
    var body: some Scene {
        WindowGroup {
            TodoItemsView().environmentObject(store)
        }
    }
}
