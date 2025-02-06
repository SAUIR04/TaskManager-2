//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Sauirbay Seidulla on 26.12.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dueDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var isComleted: Bool
    @NSManaged public var priority: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var id: UUID?

}

extension Task : Identifiable {

}
