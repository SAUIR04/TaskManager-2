import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String
    @State private var description: String
    @State private var priority: String
    @State private var dueDate: Date

    let taskToEdit: Task?

    let priorities = ["Low", "Medium", "High"]

    init(taskToEdit: Task?) {
        self.taskToEdit = taskToEdit
        _name = State(initialValue: taskToEdit?.name ?? "")
        _description = State(initialValue: taskToEdit?.taskDescription ?? "")
        _priority = State(initialValue: taskToEdit?.priority ?? "Medium")
        _dueDate = State(initialValue: taskToEdit?.dueDate ?? Date())
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    TextField("Description", text: $description)
                }

                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { priority in
                            Text(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Due Date")) {
                    DatePicker("Select Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationBarTitle(taskToEdit == nil ? "Add Task" : "Edit Task", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveTask()
                }
            )
        }
    }

    private func saveTask() {
        // Проверка на пустое имя
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Task name is empty. Please provide a valid name.")
            return
        }

        if let task = taskToEdit {
            // Обновляем существующую задачу
            task.name = name
            task.taskDescription = description
            task.priority = priority
            task.dueDate = dueDate
        } else {
            // Создаем новую задачу
            let newTask = Task(context: viewContext)
            newTask.id = UUID() // Уникальный ID
            newTask.name = name
            newTask.taskDescription = description
            newTask.priority = priority
            newTask.dueDate = dueDate
        }

        // Сохраняем изменения в Core Data
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
