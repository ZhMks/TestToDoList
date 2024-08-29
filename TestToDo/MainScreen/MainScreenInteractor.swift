import Foundation


protocol IMainScreenInteractorInput: AnyObject {
    func initialFetchData(string: String)
    func addNewToDoModel(text: String, date: Date?, isCompleted: Bool, name: String?)
    func fetchCoreData()
}

protocol IMainScreenInteractorOutput: AnyObject {
    func successedFetch(dataSource: MainResponseModel)
    func failureFetch(error: String)
    func successedSavedModel(_ model: ToDoModel)
    func failureToSave(error: String)
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

    func addNewToDoModel(text: String, date: Date?, isCompleted: Bool, name: String?) {
        coreDataService.save(text: text, date: date, isCompleted: isCompleted, name: name) { [weak self] result in
            switch result {
            case .success(let successSave):
                self?.interactorOutput?.successedSavedModel(successSave)
            case .failure(let failure):
                self?.interactorOutput?.failureToSave(error: failure.localizedDescription)
            }
        }
    }

    func fetchCoreData() {
        guard let modelsArray = coreDataService.modelsArray else { return }
        interactorOutput?.successedFetchCoredata(model: modelsArray)
    }
}


