import Foundation
import CoreData

final class CoreDataService {

    static let shared = CoreDataService()

    private init() {}

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestToDo")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Cannot load PersistentContainer")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func deleObject(model: TodoModel) {
        
    }
}
