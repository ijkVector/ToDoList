//
//  ColendarViewRepresentable.swift
//  ToDoList
//
//  Created by Иван Дроботов on 06.07.2024.
//

import UIKit
import SwiftUI

struct CalendarViewRepresentable: UIViewControllerRepresentable {
    var store: Store<AppState>
    
    struct Props {
        let items: [TodoItem]
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return MainCalendarViewController(store: store)
    }
}
