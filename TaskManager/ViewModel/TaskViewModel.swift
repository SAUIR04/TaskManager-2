import Foundation
import CoreData
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []  // Барлық тапсырмалар
    private let viewContext = PersistenceController.shared.container.viewContext  // Core Data контексті
    
    init() {
        fetchTasks()  // Инициализация кезінде деректерді жүктеу
    }

    /// ✅ **Core Data-дан барлық тапсырмаларды жүктеу**
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)
        request.sortDescriptors = [sortDescriptor]

        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("❌ Error fetching tasks: \(error)")
        }
    }

    /// ✅ **Жаңа тапсырма қосу**
    func addTask(name: String, description: String?, dueDate: Date?, priority: String?) {
        let newTask = Task(context: viewContext)
        newTask.id = UUID()
        newTask.name = name
        newTask.taskDescription = description
        newTask.dueDate = dueDate
        newTask.priority = priority ?? "Medium"
        newTask.isComleted = false
        
        saveContext()
    }

    /// ✅ **Тапсырманы өзгерту**
    func editTask(task: Task, name: String, description: String?, dueDate: Date?, priority: String?) {
        task.name = name
        task.taskDescription = description
        task.dueDate = dueDate
        task.priority = priority
        saveContext()
    }

    /// ✅ **Тапсырманың орындалу статусын өзгерту**
    func toggleCompletion(for task: Task) {
        task.isComleted.toggle()
        saveContext()
    }

    /// ✅ **Тапсырманы өшіру**
    func deleteTask(task: Task) {
        viewContext.delete(task)
        saveContext()
    }

    /// ✅ **Барлық тапсырмаларды өшіру**
    func deleteAllTasks() {
        tasks.forEach(viewContext.delete)
        saveContext()
    }

    /// ✅ **Core Data-дағы өзгерістерді сақтау**
    private func saveContext() {
        do {
            try viewContext.save()
            fetchTasks()  // Өзгерістерден кейін деректерді жаңарту
        } catch {
            print("❌ Error saving context: \(error)")
        }
    }
}
