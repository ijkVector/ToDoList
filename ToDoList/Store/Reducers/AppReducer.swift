//
//  AppReducer.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import Foundation

func appReducer(_ state: AppState, _ action: Action) -> AppState {
    var state = state
    state.itemsState = itemReducer(state.itemsState, action)
    return state
}
