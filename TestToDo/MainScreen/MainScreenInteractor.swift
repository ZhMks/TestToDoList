import Foundation


protocol IMainScreenInteractorInput: AnyObject {
    func initialFetchData(string: String)
    func initialSave(_ model: MainResponseModel, name: String?)
    func fetchCoreData()
    func deleteModel(_ model: ToDoModel)
    func updateModel(_ model: ToDoModel, text: String?, name: String?, isCompleted: Bool)
    func addNewToDoModel(text: String?, date: Date, isCompleted: Bool, name: String?)
}

protocol IMainScreenInteractorOutput: AnyObject {
    func successedFetch(dataSource: MainResponseModel)
    func failureFetch(error: String)
    func failureToSave(error: String)
    func failureToDelete(error: String)
    func successedFetchCoredata(model: [ToDoModel])
}

final class MainScreenInteractor: IMainScreenInteractorInput {

    weak var interactorOutput: IMainScreenInteractorOutput?

    private let dataSourceService: IMainDataSource
    private let coreDataService: CoreDataModelService


    init(dataSourceService: IMainDataSource, coredataService: CoreDataModelService) {
        self.dataSourceService = dataSourceService
        self.coreDataService = coredataService
    }

    func initialFetchData(string: String) {
        dataSourceService.initialFetchData(string: string) { [weak self] result in
            switch result {
            case .success(let decodedModel):
                self?.interactorOutput?.successedFetch(dataSource: decodedModel)
            case .failure(let failure):
                self?.interactorOutput?.failureFetch(error: failure.localizedDescription)
            }
        }
    }

    func initialSave(_ model: MainResponseModel, name: String?) {
        coreDataService.initialSave(model, name: name) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchCoreData()
            case .failure(let failure):
                self?.interactorOutput?.failureToSave(error: failure.localizedDescription)
            }
        }
    }

    func addNewToDoModel(text: String?, date: Date, isCompleted: Bool, name: String?) {
        coreDataService.addNewToDoModel(name: name, text: text, isCompleted: isCompleted, date: date)
        fetchCoreData()
    }

    func fetchCoreData() {
        guard let modelsArray = coreDataService.modelsArray else { return }
        interactorOutput?.successedFetchCoredata(model: modelsArray)
    }

    func deleteModel(_ model: ToDoModel) {
        coreDataService.delete(model: model) { result in
            switch result {
            case .success(_):
                fetchCoreData()
            case .failure(let failure):
                interactorOutput?.failureToDelete(error: failure.descritpion)
            }

        }
    }

    func updateModel(_ model: ToDoModel, text: String?, name: String?, isCompleted: Bool) {
        coreDataService.update(coredataModel: model, text: text, name: name, isCompleted: isCompleted)
        fetchCoreData()
    }
}


