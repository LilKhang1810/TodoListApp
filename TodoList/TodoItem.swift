//
//  TodoItem.swift
//  TodoList
//
//  Created by Nguyễn Khang Hữu on 09/03/2024.
//

import Foundation
import SwiftData
@Model
class TodoItem{
    var name: String
    var done: Bool
    var deadline: Date
    init(name: String, done: Bool,deadline: Date) {
        self.name = name
        self.done = done
        self.deadline = deadline
    }
}
