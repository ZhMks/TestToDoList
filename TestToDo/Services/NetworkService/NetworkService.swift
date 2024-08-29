import Foundation

enum NetworkServiceErrors: String, Error {
case pageNotFound
    case internalServerError
    case unknownError

    var description: String {
        switch self {
        case .pageNotFound:
            return "Страница не найдена"
        case .internalServerError:
            return "Ошибка сервера"
        case .unknownError:
            return "Неизвестная ошибка"
        }
    }
}


protocol INetworkService: AnyObject {
    func fetchData(urlString: String, completion: @escaping(Result<Data, NetworkServiceErrors>) -> Void)
}


final class NetworkService: INetworkService {

    func fetchData(urlString: String, completion: @escaping (Result<Data, NetworkServiceErrors>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in

            if error != nil {
                completion(.failure(.unknownError))
            }

            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        completion(.success(data))
                    }
                case 404:
                    completion(.failure(.pageNotFound))
                case 502:
                    completion(.failure(.internalServerError))
                default:
                    completion(.failure(.unknownError))
                }
            }
        }.resume()
    }
    

}

