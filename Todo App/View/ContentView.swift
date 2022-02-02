//
//  ContentView.swift
//  Todo App
//
//  Created by Frannck Villanueva on 13/01/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var theme = ThemeSettings.shared
    
    var themes: [Theme] = themeData
    
    // MARK: - FUNCTIONS
    private func deleteToDo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
    
    // MARK: - BODY
    var body: some View {
        
        NavigationView {
            ZStack {
                List{
                    ForEach(todos, id: \.self) { todo in
                        HStack{
                            
                            Circle()
                                .frame(width: 20, height: 20, alignment: .center)
                                .foregroundColor(colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(.systemGray2), lineWidth: 0.75)
                                )
                        } //: HSTACK
                        .padding(.vertical, 10)
                    } //: LOOP
                    .onDelete(perform: deleteToDo)
                } //: LIST
                .navigationTitle("ToDo")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading:
                        EditButton()
                            .accentColor(themes[theme.themeSettings].themeColor)
                    ,trailing:
                    Button(action: {
                        showingSettingsView.toggle()
                    }, label: {
                        Image(systemName: "paintbrush")
                            .imageScale(.large)
                            .accentColor(themes[theme.themeSettings].themeColor)
                    }) //: BUTTON
                    .sheet(isPresented: $showingSettingsView) {
                        SettingsView().environmentObject(self.iconSettings)
                    }
            )
                // MARK: - NO TODO ITEMS
                if todos.count == 0 {
                    withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        EmptyListView()
                    }
                }
            } //: ZSTACK
            .sheet(isPresented: $showingAddTodoView) {
            AddTodoView().environment(\.managedObjectContext, managedObjectContext)
            }
            .overlay(
                ZStack {
                    
                    Group {
                        Circle()
                            .fill(themes[theme.themeSettings].themeColor)
                            .opacity( animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[theme.themeSettings].themeColor)
                            .opacity( animatingButton ? 0.2 : 0)
                            .scaleEffect(animatingButton ? 1 : 0)
                            .frame(width: 88, height: 88, alignment: .center)
                            
                    } //: GROUP
                    .onAppear{
                        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        //animatingButton = 0.30
                            animatingButton.toggle()
                        }
                    }
                
                    
                    Button(action: {
                        showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                            .accentColor(themes[theme.themeSettings].themeColor)
                        
                    }) //: BUTTON
                 } //: ZSTACK
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                    .drawingGroup()
                , alignment: .bottomTrailing
            )
        } //: NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
