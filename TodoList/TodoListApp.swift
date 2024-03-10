//
//  TodoListApp.swift
//  TodoList
//
//  Created by Nguyễn Khang Hữu on 09/03/2024.
//

import SwiftUI
import SwiftData
@main
struct TodoListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TodoItem.self])
    }
}
