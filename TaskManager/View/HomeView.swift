import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    @State private var showingAddTaskView = false
    @State private var taskToEdit: Task?
    @State private var searchText: String = ""
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode") // Состояние темы
    @Binding var isLoggedIn: Bool

    var body: some View {
        NavigationView {
            VStack {
                // Поле поиска
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Список задач
                List {
                    ForEach(filteredTasks(), id: \.id) { task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.name ?? "Untitled")
                                    .font(.headline)
                                if let dueDate = task.dueDate {
                                    Text("Due: \(dueDate, formatter: taskDateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            Button(action: {
                                taskToEdit = task // Устанавливаем задачу для редактирования
                                showingAddTaskView = true
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .navigationTitle("Things to do")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        taskToEdit = nil // Новый режим добавления задачи
                        showingAddTaskView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: { isLoggedIn = false }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            isDarkMode.toggle()
                            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
                        }) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .font(.title2)
                                .foregroundColor(isDarkMode ? .yellow : .blue)
                        }
                        Button(action: deleteAllTasks) { // Кнопка удаления всех задач
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddTaskView) {
                AddTaskView(taskToEdit: taskToEdit)
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) // Подключаем светлый/тёмный режим
    }

    private func filteredTasks() -> [Task] {
        if searchText.isEmpty {
            return Array(tasks)
        } else {
            return tasks.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Функция для удаления всех задач
    private func deleteAllTasks() {
        withAnimation {
            tasks.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let taskDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
