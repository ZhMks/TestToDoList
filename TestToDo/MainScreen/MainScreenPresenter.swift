import Foundation
import CoreData

enum AlertViewState {
    case create
    case update
}


protocol IMainScreenView: AnyObject {
    func updateData()
    func showErrorAlert(error: String)
    func showAlertView(state: AlertViewState, model: ToDoModel?)
    func startAnimating()
    func stopAnimating()
    func animateCell()
}

protocol IMainScreenPresenter: AnyObject {
    func initialFetch()
    func viewDidLoad(view: IMainScreenView)
    func showCreateTodoView(state: AlertViewState)
    func addNewTask(text: String, name: String)
    var coredataDatasource: [ToDoModel]? { get }
    func deleteModel(_ model: ToDoModel)
    func updateModel(_ model: ToDoModel, text: String?, name: String?)
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

    }

    func fetchFromNetwork() {
        let string = "https://dummyjson.com/todos"
        interactor.initialFetchData(string: string)
    }

    func showCreateTodoView(state: AlertViewState) {
        view?.showAlertView(state: state, model: nil)
    }

    func addNewTask(text: String, name: String) {
        let date = Date.now
        interactor.addNewToDoModel(text: text, date: date, isCompleted: false, name: name)
    }

    func deleteModel(_ model: ToDoModel) {
        interactor.deleteModel(model)
    }

    func updateModel(_ model: ToDoModel, text: String?, name: String?) {
        interactor.updateModel(model, text: text, name: name, isCompleted: model.isCompleted)
    }
}


extension MainScreenPresenter: IMainScreenInteractorOutput {
    func failureToDelete(error: String) {
        view?.showErrorAlert(error: error)
    }

    func successedFetchCoredata(model: [ToDoModel]) {
        self.coredataDatasource = model
        if !model.isEmpty {
            view?.stopAnimating()
            view?.updateData()
        } else {
            fetchFromNetwork()
        }
    }

    func failureToSave(error: String) {
        view?.showErrorAlert(error: error)
    }

    func successedSavedModel(_ model: ToDoModel) {
        view?.updateData()
    }

    func successedFetch(dataSource: MainResponseModel) {
        self.interactor.initialSave(dataSource, name: nil)        
        self.view?.stopAnimating()
        self.view?.updateData()
        self.view?.animateCell()
    }

    func failureFetch(error: String) {
        self.view?.showErrorAlert(error: error)
    }

}


