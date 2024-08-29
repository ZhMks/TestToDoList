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

    func deleObject(model: ToDoModel, completion: (Result<Bool, Error>) -> Void) {
        do {
            let objectToDelete = try context.existingObject(with: model.objectID)
            context.delete(objectToDelete)
            try context.save()
            completion(.success(true))
        } catch {
            print("Failed to delete object: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
