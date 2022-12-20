//
//  Task+CoreDataProperties.swift
//  ToDoListTask
//
//  Created by De la Cruz Hernández on 19/12/22.
//
//

import Foundation
import CoreData

extension Task {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    @NSManaged public var date: Date?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
}

extension Task : Identifiable {
}
