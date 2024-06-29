//
//  ImportanceView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 29.06.2024.
//

import SwiftUI

struct ImportanceView: View {
    @Binding var importance: Importance
    
    var body: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker("", selection: $importance) {
                Image(.iconArrowDown).tag(Importance.unimportant)
                Text("нет").tag(Importance.routine)
                Image(.iconExclamationMarks).tag(Importance.important)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 10)
            .padding(.bottom, 10)
            .frame(maxWidth: 150)
        }
    }
}

#Preview {
    ImportanceView(importance: Binding(get: {
        return .important } , set: { _ in
        }))
}
