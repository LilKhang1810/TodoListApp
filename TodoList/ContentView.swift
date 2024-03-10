//
//  ContentView.swift
//  TodoList
//
//  Created by Nguyễn Khang Hữu on 09/03/2024.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \TodoItem.deadline) var todos : [TodoItem]
    @State var showAddTodoItem: Bool = false
    @State var tasksCompleted: Int = 0
    
    var body: some View {
        NavigationStack{
            HStack(alignment:.center,spacing:20){
                HeaderFrame(title:"Have Finished", total: tasksCompleted, img: "checkmark.circle.fill")
                HeaderFrame(title: "Total Task", total: todos.count, img: "list.bullet.below.rectangle")
            }
            .frame(maxWidth: .infinity)
            .padding()
            List{
                ForEach(todos){todo in
                    TodoItemFrame(todo: todo, tasksCompleted: $tasksCompleted)
                }
                
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        context.delete(todos[index])
                    }
                })
            }
            .listStyle(.inset)
            .navigationTitle("To-do list")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                if !todos.isEmpty{
                    Button("Add to-do item",systemImage: "plus"){
                        showAddTodoItem = true
                    }
                }
            }
            .sheet(isPresented: $showAddTodoItem, content: {
                AddItemTodoView()
            })
            .overlay {
                if todos.isEmpty{
                    ContentUnavailableView(label: {
                        Label("No To-do Item", systemImage: "pencil.and.list.clipboard")
                    }, description: {
                        Text("Add new todo item, and start your day!")
                    }, actions: {
                        Button(action: {showAddTodoItem = true}) {
                            Text("Add to-do item")
                        }
                    })
                }
            }
        }
        
    }
}
struct TodoItemFrame: View {
    let todo: TodoItem
    @Binding var tasksCompleted : Int
    var body: some View {
        HStack{
            Text(todo.deadline,format: .dateTime.month(.abbreviated).day())
                .frame(width: 70,alignment: .leading)
                .foregroundColor(todo.done ? Color(.systemGray):Color(.black))
            Text(todo.name)
                .foregroundColor(todo.done ? Color(.systemGray):Color(.black))
            Spacer()
            
            Button(action: {
                todo.done.toggle()
                if todo.done{
                    tasksCompleted += 1
                }
                else{
                    tasksCompleted -= 1
                }
            }, label: {
                Image(systemName: todo.done ? "checkmark.circle.fill":"circle")
                    .foregroundColor(.green)
            })
        }
    }
}
struct AddItemTodoView: View {
    @State private var name: String = ""
    @State private var deadline: Date = .now
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    var body: some View {
        NavigationStack{
            Form{
                TextField("Add new todo item", text: $name)
                DatePicker("Deadline Date", selection: $deadline,displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            .navigationTitle("New Todo Item")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save"){
                        let todo = TodoItem(name: name, done: false, deadline: deadline)
                        context.insert(todo)
                        dismiss()
                    }
                }
            }
        }
    }
}
#Preview {
    ContentView()
}

struct HeaderFrame: View {
    let title: String
    let total: Int
    let img: String
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.system(size: 20))
                .bold()
            Spacer()
            HStack{
                Text("\(total)")
                    .font(.system(size: 20))
                Spacer()
                Image(systemName: img)
            }
        }
        .padding()
        .frame(maxWidth: 170)
        .frame(height: 100)
        .background(Color(.white))
        .cornerRadius(20)
        .shadow(radius: 10, x:5,y:5)
    }
}
