//
//  TodoItemCellView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

private enum LayoutConstants {

}

struct TodoItemCellView: View {
    var todoItem: TodoItem
    var completeToogle: () -> Void

    var body: some View {
        HStack {
            completeButton
            HStack {
                if todoItem.importance == .important
                    && !todoItem.isDone {
                    Image(.iconExclamationMarks)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(todoItem.text)
                        .lineLimit(3)
                    if let deadline = todoItem.deadline {
                        HStack(spacing: 2) {
                            Image(systemName: "calendar")
                            Text(deadline, style: .date)
                        }
                    }
                }
            }
            Spacer()
            Image(.iconArrowRight)
            if let hexColor = todoItem.hexColor {
                Rectangle()
                    .fill(Color(hex: hexColor))
                    .frame(width: 5, height: 50)
            }

        }
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
    let todoItem = TodoItem(text: "Task1", importance: .important, deadline: .now, hexColor: "#00FE44")
    return TodoItemCellView(todoItem: todoItem) { }
}
