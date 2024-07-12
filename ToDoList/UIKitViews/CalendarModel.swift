//
//  CalendarModel.swift
//  ToDoList
//
//  Created by Иван Дроботов on 06.07.2024.
//

import SwiftUI
import UIKit

struct CalendarModel {
    @EnvironmentObject var store: Store<AppState>

    private func map(state: ItemsState) -> Props {
        Props(items: state.items, onItemAdded: { item in
            store.dispathc(action: AddItemAction(item: item))
        }, onItemRemove: { item in
            store.dispathc(action: RemoveItemAction(item: item))
        })
    }

    struct Props {
        // props
        let items: [TodoItem]

        // dispatch
        let onItemAdded: (TodoItem) -> Void
        let onItemRemove: (TodoItem) -> Void
    }

    var prop: Props?

    mutating func setUP() {
        self.prop = map(state: store.state.itemsState)
    }
}
