//
//  ItemReducer.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import Foundation

func itemReducer(_ state: ItemsState, _ action: Action) -> ItemsState {
    var state = state
    switch action {
    case let action as AddItemAction:
        state.items.append(action.item)
    case let action as RemoveItemAction:
        state.items.removeAll{ $0.id == action.item.id }
    case let action as DoneItemAction:
        if let i = state.items.firstIndex(of: action.item) {
            state.items[i] = action.item
        }
    default:
        break
    }
    return state
}
