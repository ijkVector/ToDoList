//
//  DeadlineView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 29.06.2024.
//

import SwiftUI

struct DeadlineView: View {
    @Binding var deadline: Date
    
    var body: some View {
        DatePicker("", selection: $deadline, in: Date()..., displayedComponents: .date)
            .environment(\.locale, Locale(identifier: ""))
            .datePickerStyle(.graphical)
            .clipped()
    }
}

#Preview {
    DeadlineView(deadline: Binding(get: {
        return Date(timeIntervalSince1970: 100) } , set: { _ in
        }))
}
