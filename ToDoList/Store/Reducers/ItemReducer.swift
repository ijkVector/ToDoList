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
//        state.items.map { print($0.text) }
//        print(state.items.count)
    case let action as RemoveItemAction:
        state.items.removeAll{ $0.id == action.item.id }
//        print(state.items)
    case let action as DoneItemAction:
        if let i = state.items.firstIndex(where: { $0.id == action.item.id }) {
            state.items[i] = action.item
//            print(state.items)
        }
    default:
        break
    }
    return state
}
