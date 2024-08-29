import UIKit

final class MainScreenTableCell: UITableViewCell {

    static let identifier = String.id

    // MARK: - Properties
    private lazy var todoDate: UILabel = {
        let todoDate = UILabel()
        todoDate.font = UIFont.systemFont(ofSize: 12)
        todoDate.textAlignment = .left
        todoDate.translatesAutoresizingMaskIntoConstraints = false
        return todoDate
    }()

    private lazy var todoText: UILabel = {
        let todoText = UILabel()
        todoText.font = UIFont.boldSystemFont(ofSize: 16)
        todoText.numberOfLines = 0
        todoText.textAlignment = .left
        todoText.translatesAutoresizingMaskIntoConstraints = false
        return todoText
    }()

    private lazy var todoButton: UIButton = {
        let todoButton = UIButton(type: .system)
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        todoButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        todoButton.tintColor = .systemBlue
        return todoButton
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    
    func updateCellWithCoredataModel(model: ToDoModel) {
        todoText.text = model.text
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let stringFromDate = formatter.string(from: model.date ?? .now)
        todoDate.text = stringFromDate
    }

    private func addSubviews() {
        contentView.addSubview(todoText)
        contentView.addSubview(todoDate)
        contentView.addSubview(todoButton)
    }

    private func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            todoText.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            todoText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            todoText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),

            todoDate.topAnchor.constraint(equalTo: todoText.bottomAnchor, constant: 10),
            todoDate.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            todoDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            todoDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15),

            todoButton.centerYAnchor.constraint(equalTo: todoText.centerYAnchor),
            todoButton.leadingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 5),
            todoButton.heightAnchor.constraint(equalToConstant: 60),
            todoButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}


extension String {
    static let id = "MainScreenTableCell"
}
