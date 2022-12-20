//
//  TaskDataManager.swift
//  ToDoListTask
//
//  Created by De la Cruz Hernández on 19/12/22.
//

import Foundation
import CoreData

class TaskDataManager{
    private var tasks : [Task] = []
    private var context : NSManagedObjectContext
    
    init(context : NSManagedObjectContext){
        self.context = context
    }
    
    func fecth() {
        do{
            self.tasks = try self.context.fetch(Task.fetchRequest())
        }catch{
            print("Error:", error)
        }
    }
    
    func fecthWithPredicate(searchValue : String) {
        do{
            let fetchRequestWP = NSFetchRequest<Task>(entityName: "Task")
            fetchRequestWP.predicate = NSPredicate(format: "title = %@", searchValue)
            print(fetchRequestWP)
            self.tasks = try self.context.fetch(fetchRequestWP)
            print(tasks)
        }catch{
            print("Error:", error)
        }
    }
    
    func fecthWithCompountPredicate(title : String = "", notes: String = "", date : Date? = nil, date2 : Date? = nil) {
        var predicates : [NSPredicate] = []
        if !(title.isEmpty) {
            predicates.append(NSPredicate(format: "title LIKE %@", title))
        }
        if !(notes.isEmpty) {
            predicates.append(NSPredicate(format: "note LIKE %@", notes))
        }
        if (date != nil && date2 == nil) {
            predicates.append(NSPredicate(format: "date >= %@", date! as NSDate))
        }
        if (date != nil && date2 != nil) {
            predicates.append(NSPredicate(format: "date <= %@ and date >= %@",date2! as NSDate,date! as NSDate))
        }
        if (date == nil && date2 != nil) {
            predicates.append(NSPredicate(format: "date <= %@", date2! as NSDate))
        }
        let compountPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        do{
            let fetchRequestWCP = NSFetchRequest<Task>(entityName: "Task")
            fetchRequestWCP.predicate = compountPredicate
            self.tasks = try self.context.fetch(fetchRequestWCP)
        }catch{
            print("Error:", error)
        }
    }
    
    func getTask(at index : Int) -> Task {
        return tasks[index]
    }
    func countTask() -> Int {
        return tasks.count
    }
    func pushTask(newtask : Task){
        tasks.append(newtask)
    }
}
