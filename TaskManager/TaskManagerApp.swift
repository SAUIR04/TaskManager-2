import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
