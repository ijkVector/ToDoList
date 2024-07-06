//
//  ImportanceView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

struct ImportanceView: View {
    @Binding var importance: Importance
    
    var body: some View {
        Picker("", selection: $importance) {
            Image(.iconArrowDown).tag(Importance.unimportant)
            Text("нет")
                .font(.system(size: 15, weight: .regular))
                .multilineTextAlignment(.center)
                .tag(Importance.routine)
            Image(.iconExclamationMarks).tag(Importance.important)
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

#Preview {
    ImportanceView(importance: Binding(get: { .routine }, set: { _ in }))
}