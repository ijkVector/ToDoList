//
//  ItemReducer.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import Foundation
import CocoaLumberjackSwift
import FileCacheUtil

let fileCache = FileCache<TodoItem>(todoItems: [])
enum FileNames {
    static let jsonName = "TodoItems.json"
    static let csvName = "TodoItems.csv"
}

func itemReducer(_ state: ItemsState, _ action: Action) -> ItemsState {
    var state = state
    switch action {
    case let action as AddItemAction:
        state.items.append(action.item)
        do {
            try fileCache.save(to: FileNames.jsonName)
        } catch {
            let message = DDLogMessageFormat(stringLiteral: error.localizedDescription)
            DDLogError(message)
        }
        DDLogInfo("Append todo with id: \(action.item.id)")
    case let action as RemoveItemAction:
        state.items.removeAll { $0.id == action.item.id }
        fileCache.removeItem(by: action.item.id)
        DDLogInfo("Romove todo with id \(action.item.id)")
    case let action as DoneItemAction:
        if let i = state.items.firstIndex(where: { $0.id == action.item.id }) {
            state.items[i] = action.item
            DDLogInfo("Done todo with id \(action.item.id)")
        }
    default:
        break
    }
    return state
}
