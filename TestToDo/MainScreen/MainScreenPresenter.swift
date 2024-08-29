import Foundation
import CoreData


protocol IMainScreenView: AnyObject {
    func updateData()
    func showErrorAlert(error: String)
    func showCreateView()
    func startAnimating()
    func stopAnimating()
}

protocol IMainScreenPresenter: AnyObject {
    func initialFetch()
    func viewDidLoad(view: IMainScreenView)
    func showCreateTodoView()
    func addNewTask(text: String, name: String)
    var coredataDatasource: [ToDoModel]? { get }
}

final class MainScreenPresenter: IMainScreenPresenter {

    private let interactor: IMainScreenInteractorInput

    private let router: IMainScreenRouter

    private weak var view: IMainScreenView?
    private(set) var coredataDatasource: [ToDoModel]?

    init(router: IMainScreenRouter, interactor: IMainScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }

    func viewDidLoad(view: IMainScreenView) {
        self.view = view
    }

    func initialFetch() {
        DispatchQueue.main.async {
            self.view?.startAnimating()
        }

        interactor.fetchCoreData()

        if let coredataDatasource = self.coredataDatasource {
            if coredataDatasource.isEmpty {
                let string = "https://dummyjson.com/todos"
                interactor.initialFetchData(string: string)
            } else {
                view?.stopAnimating()
                view?.updateData()
            }
        }
    }

    func showCreateTodoView() {
        view?.showCreateView()
    }

    func addNewTask(text: String, name: String) {
        let date = Date.now
        interactor.addNewToDoModel(text: text, date: date, isCompleted: false, name: name)
    }
}


extension MainScreenPresenter: IMainScreenInteractorOutput {

    func successedFetchCoredata(model: [ToDoModel]) {
        self.coredataDatasource = model
    }

    func failureToSave(error: String) {
        view?.showErrorAlert(error: error)
    }
    
    func successedSavedModel(_ model: ToDoModel) {
        view?.updateData()
    }

    func successedFetch(dataSource: MainResponseModel) {
        for model in dataSource.todoModel {
            self.interactor.addNewToDoModel(text: model.text, date: model.data, isCompleted: model.isCompleted, name: nil)        }
            self.view?.stopAnimating()
            self.view?.updateData()
    }

    func failureFetch(error: String) {
        self.view?.showErrorAlert(error: error)
    }

}


