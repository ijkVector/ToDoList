//
//  TodoItemsView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI
import FileCacheUtil

struct TodoItemsView: View {
    @State var isPresented: Bool = false
    @State var currentItem: TodoItem?
    @EnvironmentObject var store: Store<AppState>

    struct Props {
        // props
        let items: [TodoItem]

        // dispatch
        let onItemAdded: (TodoItem) -> Void
        let onItemRemove: (TodoItem) -> Void
        let onItemDone: (TodoItem) -> Void
    }

    private func map(state: ItemsState) -> Props {
        Props(items: state.items, onItemAdded: { item in
            store.dispathc(action: AddItemAction(item: item))
        }, onItemRemove: { item in
            store.dispathc(action: RemoveItemAction(item: item))
        }, onItemDone: { item in
            store.dispathc(action: DoneItemAction(item: item))
        })
    }

    var body: some View {
        let prop = map(state: store.state.itemsState)

        NavigationStack {
            ZStack(alignment: .bottom) {
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

                            }, label: {
                                Image(systemName: "info.circle.fill")
                            })
                            .tint(Color.customGray)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {

                            Button(action: {
                                if let currentItem {
                                    let newItem = TodoItem(todoItem: currentItem)
                                    prop.onItemDone(newItem)
                                }
                            }, label: {
                                Image(.iconPropOn)
                            })
                            .tint(Color.customGreen)
                        }
                    }
                }
                .navigationTitle("Мои дела")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        NavigationLink {
//                            CalendarViewRepresentable(store: store)
                        } label: {
                            Image(systemName: "calendar.circle.fill")
                        }
                    }
                }
                Button {
                    isPresented = true
                } label: {
                    Image(.iconPlusButton)
                }
            }
        }
        .sheet(isPresented: $isPresented, content: {
            DetailView()
        })
    }
}

#Preview {
    let store = Store(reducer: appReducer, state: AppState())
    return TodoItemsView().environmentObject(store)
}
