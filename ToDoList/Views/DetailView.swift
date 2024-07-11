//
//  AddItemView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var store: Store<AppState>
    
    @State private var text: String = ""
    @State private var importance: Importance = .routine
    @State private var isDeadlineAvailable: Bool = false
    @State private var isCalendarAvailable: Bool = false
    @State private var deadline: Date = Date.nextDay
    @State private var isDone: Bool = false
    @State private var createdAt: Date?
    @State private var changedAt: Date?
    @State private var isColorAvailable: Bool = false
    @State private var hexColor: Color = Color.white
    
    @Environment(\.dismiss) private var dismiss
    
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
        
        NavigationStack {
            ScrollView {
                VStack {
                    textFieldView
                    VStack(spacing: 0) {
                        importanceView
                        Divider()
                        colorView
                        if isColorAvailable {
                            Divider()
                            PaletteView(currentColor: $hexColor)
                        }
                        Divider()
                        deadlineView
                        if isCalendarAvailable && isDeadlineAvailable {
                            DeadlineCalendarView(deadline: $deadline)
                            Spacer()
                        }
                    }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(Color.customWhite)
                        )
                    
                    Button(action: {
                        prop.onItemRemove(TodoItem(text: text, importance: importance))
                    }, label: {
                        Text("Удалить")
                            .foregroundStyle(text.isEmpty ? Color.customGray : Color.customRed)
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                        
                    })
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(Color.customWhite)
                    )
                    .disabled(text.isEmpty)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .background(Color.backPrimary)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        prop.onItemAdded(TodoItem(text: text, importance: .routine, hexColor: hexColor.asHexString))
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
    
    private var textFieldView: some View {
        TextField("Что надо сделать ?", text: $text, axis: .vertical)
            .lineLimit(5...100)
            .frame(minHeight: 120)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.customWhite)
            )
    }
    
    private var featuresView: some View {
        VStack(spacing: 0) {
            importanceView
            Divider()
            colorView
            if isColorAvailable {
                Divider()
                PaletteView(currentColor: $hexColor)
            }
            Divider()
            deadlineView
            if isCalendarAvailable && isDeadlineAvailable {
                DeadlineCalendarView(deadline: $deadline)
                Spacer()
            }
        }
    }
    
    private var importanceView: some View {
        HStack {
            Text("Важность")
                .padding()
            Spacer()
            ImportanceView(importance: $importance)
                .frame(width: 180)
        }
        .frame(height: 56)
        .background(Color.customWhite)
    }
    
    private var colorView: some View {
        HStack {
            VStack(spacing: 1) {
                Text("Цвет")
                    .padding()
                if isColorAvailable, let hexColor = hexColor.asHexString {
                    HStack {
                        Text(hexColor)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
            }
            Toggle("", isOn:
                    $isColorAvailable.animation(.linear))
        }
        .frame(height: 56)
        .background(Color.customWhite)
    }
    
    private var deadlineView: some View {
//        HStack {
//            VStack(spacing: 1) {
//                Text("Сделать до")
//                    .padding()
//                if isDeadlineAvailable {
//                    Button(deadline.deadlineAsString) {
//                        withAnimation {
//                            isCalendarAvailable.toggle()
//                        }
//                    }
//                }
//                
//                if isCalendarAvailable {
//                    DeadlineCalendarView(deadline: $deadline)
//                }
//            }
//            
//            Toggle("", isOn: $isDeadlineAvailable.animation(.linear))
//        }
//        .frame(height: 90)
//        .background(Color.customWhite)
        
        Toggle(isOn: $isDeadlineAvailable.animation()) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Сделать до")
                if isDeadlineAvailable {
                    Button(deadline.deadlineAsString) {
                        withAnimation {
                            isCalendarAvailable.toggle()
                        }
                    }
                }
            }
            .padding()
        }
        .frame(height: 56)
    }
}

#Preview {
    let store = Store(reducer: appReducer, state: AppState())
    return DetailView().environmentObject(store)
}
