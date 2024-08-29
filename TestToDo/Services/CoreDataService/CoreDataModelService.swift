import Foundation

enum CustomError: Error {
    case failedSave

    var descritpion: String {
        switch self {
        case .failedSave:
            return "Не удалось сохранить модель"
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

    func save(text: String, date: Date?, isCompleted: Bool, name: String?, completion: @escaping (Result<ToDoModel, CustomError>) -> Void) {
        if checkExistedModel(text: text) {
            return
        } else {
            let newModelToSave = ToDoModel(context: coreDataService.context)
            newModelToSave.name = name == nil ? "Новая задача": name
            newModelToSave.text = text
            newModelToSave.date = date
            newModelToSave.isCompleted = isCompleted
            coreDataService.saveContext()
            completion(.success(newModelToSave))
        }
        initalFetch()
    }

    func checkExistedModel(text: String) -> Bool {
        print(text)
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

    func update(coredataModel: ToDoModel, text: String) {
        guard let modelsArray = self.modelsArray else { return }
        guard let firstModel = modelsArray.first(where: { $0.text == coredataModel.text }) else { return }
        firstModel.text = text
        coreDataService.saveContext()
        initalFetch()
    }

    func delete(model: TodoModel) {
        guard let index = modelsArray?.firstIndex(where: { $0.text == model.text }) else { return }
        modelsArray?.remove(at: index)
        coreDataService.saveContext()
        initalFetch()
    }

}
