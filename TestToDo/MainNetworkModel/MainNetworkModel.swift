import Foundation


struct MainNetworkModel: Decodable {
    let todoModel: [TodoModel]

    private enum CodingKeys: String, CodingKey {
        case todoModel = "todos"
    }
}


struct TodoModel: Decodable {
    let text: String
    let isCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case text = "todo"
        case isCompleted = "completed"
    }
}


struct MainResponseModel {
    let todoModel: [TodoResponseModel]
}


struct TodoResponseModel {
    let text: String
    let isCompleted: Bool
    let data: Date?
}
