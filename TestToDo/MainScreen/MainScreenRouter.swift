import UIKit


protocol IMainScreenRouter: AnyObject {
   static func createViewController() -> UIViewController
}

final class MainScreenRouter: IMainScreenRouter {

    weak var viewController: UIViewController?

    static func createViewController() -> UIViewController {

        let networkService = NetworkService()
        let decoderService = DecoderService()
        let coreModelService = CoreDataModelService()
        let dataSource = MainDataSourceService(networkService: networkService, decoderService: decoderService)
        let interactor = MainScreenInteractor(dataSourceService: dataSource, coredataService: coreModelService)
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(router: router, interactor: interactor)
        let view = MainScreenViewController(presenter: presenter)

        router.viewController =  view
        interactor.interactorOutput = presenter

        return view
    }
    
}
