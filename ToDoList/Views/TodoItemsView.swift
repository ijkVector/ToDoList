//
//  ContentView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 17.06.2024.
//

import SwiftUI

struct TodoItemsView: View {
    @StateObject var viewModel = TodoItemsViewModel()
    var body: some View {
        VStack {
            Image(.iconArrowDown)
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .foregroundColor(Color.customRed)
        }
        .padding()
    }
}

#Preview {
    TodoItemsView()
}
