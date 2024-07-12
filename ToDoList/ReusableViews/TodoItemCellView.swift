//
//  TodoItemCellView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

struct TodoItemCellView: View {
    var todoItem: TodoItem
    var completeToogle: () -> Void

    var body: some View {
        let isImportant = todoItem.importance == .important
        let isUnimportant = todoItem.importance == .unimportant
        HStack {
            completeButton
            if !todoItem.isDone {
                if isImportant {
                    Image(.iconExclamationMarks)
                } else if isUnimportant {
                    Image(.iconArrowDown)
                }
            }

            VStack(alignment: .leading) {
                Text(todoItem.text)
                    .strikethrough(todoItem.isDone)
                    .lineLimit(3)
                if let deadline = todoItem.deadline {
                    HStack {
                        Image(systemName: "calendar")
                        Text(deadline, style: .date)
                    }
                    .foregroundStyle(.labelSecondary)
                }
            }

            Spacer()

            Image(.iconArrowRight)
            if let hexColor = todoItem.hexColor {
                Rectangle()
                    .fill(Color(hex: hexColor))
                    .frame(width: 5)
            }

        }
        .padding()
    }

    private var completeButton: some View {
        let isImportant = todoItem.importance == .important

        return Button(action: completeToogle) {
            if !todoItem.isDone {
                Image(isImportant ? .iconPropHighPriority : .iconPropOff)
            } else {
                Image(.iconPropOn)
            }
        }
    }
}

#Preview {
    let todoItem = TodoItem(text: "Hello", importance: .important, deadline: .now, hexColor: "#00FE44")
    return TodoItemCellView(todoItem: todoItem) { }
}
