//
//  DeadlineCalendarView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 05.07.2024.
//

import SwiftUI

struct DeadlineCalendarView: View {
    @Binding var deadline: Date

    var body: some View {
        DatePicker("", selection: $deadline, in: Date()..., displayedComponents: [.date]).environment(\.locale, Locale.init(identifier: "ru_Ru"))
            .datePickerStyle(.graphical)
    }
}

#Preview {
    DeadlineCalendarView(deadline: Binding(get: { .now }, set: { _ in }))
}
