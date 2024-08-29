import Foundation

enum CustomError: Error {
    case failedSave
    case failedToDelete

    var descritpion: String {
        switch self {
        case .failedSave:
            return "Не удалось сохранить модель"
        case .failedToDelete:
            return "Не удалось удалить модель"
        }
    }
}


final class CoreDataModelService {
    private(set) var modelsArray: [ToDoModel]?
    let coreDataService = CoreDataService.shared

    init() {
        initalFetch()
    }

    private func initalFetch() {
        let fetchRequest = ToDoModel.fetchRequest()
        do {
            modelsArray = try coreDataService.context.fetch(fetchRequest)
        } catch {
            modelsArray = []
            print(error.localizedDescription)
        }
    }

    func initialSave(_ model: MainResponseModel, name: String?, completion: @escaping (Result<Bool, CustomError>) -> Void) {
        for todoModel in model.todoModel {
            if checkExistedModel(text: todoModel.text) {
                return
            } else {
                let newModelToSave = ToDoModel(context: coreDataService.context)
                newModelToSave.name = name == nil ? "Новая задача": name
                newModelToSave.text = todoModel.text
                newModelToSave.date = todoModel.data
                newModelToSave.isCompleted = todoModel.isCompleted
            }
        }
        coreDataService.saveContext()
        initalFetch()
        completion(.success(true))
    }

    func addNewToDoModel(name: String?, text: String?, isCompleted: Bool, date: Date) {
        if checkExistedModel(text: text!) {
            return
        } else {
            let newModelToSave = ToDoModel(context: coreDataService.context)
            newModelToSave.name = name == nil ? "Новая задача": name
            newModelToSave.text = text
            newModelToSave.date = date
            newModelToSave.isCompleted = isCompleted
            coreDataService.saveContext()
            initalFetch()
        }
    }

    func checkExistedModel(text: String) -> Bool {
        guard let modelsArray = self.modelsArray else { return false }
        if modelsArray.isEmpty {
            return false
        } else {
            for model in modelsArray {
                if model.text == text {
                    return true
                }
            }
        }
        return false
    }

    func update(coredataModel: ToDoModel, text: String?, name: String?, isCompleted: Bool) {
        guard let modelsArray = self.modelsArray else { return }
        guard let firstModel = modelsArray.first(where: { $0 === coredataModel }) else { return }

        if let text = text, !text.isEmpty {
            firstModel.text = text
        }

        if let name = name, !name.isEmpty {
            firstModel.name = name
        }

        firstModel.isCompleted = isCompleted

        coreDataService.saveContext()
        initalFetch()
    }

    func delete(model: ToDoModel, completion: (Result<Bool, CustomError>) -> Void) {
        coreDataService.deleObject(model: model) { result in
            switch result {
            case .success(_):
                coreDataService.saveContext()
                initalFetch()
                completion(.success(true))
            case .failure(let failure):
                assertionFailure(failure.localizedDescription)
                completion(.failure(.failedToDelete))
            }
        }
    }

}
