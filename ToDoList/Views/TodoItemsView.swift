//
//  TodoItemsView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

struct TodoItemsView: View {
    @State var isPresented: Bool = false
    @State var currentItem: TodoItem?
    @EnvironmentObject var store: Store<AppState>
    
    struct Props {
        //props
        let items: [TodoItem]
        
        //dispatch
        let onItemAdded: (TodoItem) -> Void
        let onItemRemove: (TodoItem) -> Void
    }
    
    private func map(state: ItemsState) -> Props {
        Props(items: state.items, onItemAdded: { item in
            store.dispathc(action: AddItemAction(item: item))
        }, onItemRemove: { item in
            store.dispathc(action: RemoveItemAction(item: item))
        })
    }
    
    var body: some View {
        let prop = map(state: store.state.itemsState)
        
        VStack {
            List(prop.items, id: \.id) { item in
                Button {
                    currentItem = item
                } label: {
                    TodoItemCellView(todoItem: item, completeToogle: {})
                }
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        if let currentItem {
                            prop.onItemRemove(currentItem)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(Color.customRed)
                    
                    Button(action: {
                        currentItem = item
                    }, label: {
                        Image(systemName: "info.circle.fill")
                    })
                    .tint(Color.customGray)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    
                    Button(action: {
                        
                    }, label: {
                        Image(.iconPropOn)
                    })
                    .tint(Color.customGreen)
                }
            }
            Button("Add") {
                isPresented = true
            }
        }.sheet(isPresented: $isPresented, content: {
            DetailView()
        })
    }
}

#Preview {
    let store = Store(reducer: appReducer, state: AppState())
    return TodoItemsView().environmentObject(store)
}
