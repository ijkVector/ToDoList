//
//  Store.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import Foundation
import FileCacheUtil

typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State

// MARK: - States
protocol ReduxState { }

struct AppState: ReduxState {
    var itemsState = ItemsState()
}

struct ItemsState: ReduxState {
    var items: [TodoItem] = [
        TodoItem(text: "Задача1", importance: .important),
        TodoItem(text: "Задача2", importance: .basic),
        TodoItem(text: "Задача3", importance: .low)
    ]
}

struct DetailViewColorState: ReduxState {
    var isColorAvailable: Bool = false
    var isColorPickerShow: Bool = false
}

// MARK: - Actions
protocol Action { }

struct AddItemAction: Action {
    let item: TodoItem
}

struct RemoveItemAction: Action {
    let item: TodoItem
}

struct EditItemAction: Action {
    let item: TodoItem
}

struct DoneItemAction: Action {
    let item: TodoItem
}

struct DetailViewColorAction: Action {

}

final class Store<StoreState: ReduxState>: ObservableObject {

    private let reducer: Reducer<StoreState>
    @Published private(set) var state: StoreState

    init(reducer: @escaping Reducer<StoreState>, state: StoreState) {
        self.reducer = reducer
        self.state = state
    }

    func dispathc(action: Action) {
        state = reducer(state, action)
    }
}
