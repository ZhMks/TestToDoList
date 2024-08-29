import Foundation

protocol IMainDataSource: AnyObject {
    var networkService: INetworkService { get set }
    var decoderService: IDecoderService { get set }
    func initialFetchData(string: String, completion: @escaping(Result<MainResponseModel, Error>) -> Void)
}

final class MainDataSourceService: IMainDataSource {

    // MARK: - Properties

    var networkService: INetworkService
    var decoderService: IDecoderService

    // MARK: - Lifecycle
    init(networkService: INetworkService, decoderService: IDecoderService) {
        self.networkService = networkService
        self.decoderService = decoderService
    }

    // MARK: - Funcs
    func initialFetchData(string: String, completion: @escaping(Result<MainResponseModel, Error>) -> Void) {
        networkService.fetchData(urlString: string) { [weak self] result in
            switch result {
            case .success(let success):

                self?.decoderService.decode(networkData: success, completion: { result in
                    switch result {
                    case .success(let networkModel):
                        let date = Date()
                        let todoResponseModel = networkModel.todoModel.map { networkToDo in
                            return TodoResponseModel(text: networkToDo.text, isCompleted: networkToDo.isCompleted, data: date)
                        }
                        let mainResponseModel = MainResponseModel(todoModel: todoResponseModel)
                        completion(.success(mainResponseModel))
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                })
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

}
