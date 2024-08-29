import Foundation


protocol IDecoderService: AnyObject {
    func decode(networkData: Data, completion: (Result<MainNetworkModel, Error>) -> Void)
}


final class DecoderService: IDecoderService {
    func decode(networkData: Data, completion: (Result<MainNetworkModel, Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let networkModel = try decoder.decode(MainNetworkModel.self, from: networkData)
            completion(.success(networkModel))
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            completion(.failure(error))
        }
    }
    
    
}
