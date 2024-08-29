import UIKit

protocol IDidTapButton: AnyObject {
    func didTapButton(_ model: ToDoModel?)
}

final class MainScreenTableCell: UITableViewCell {

    static let identifier = String.id

    private var model: ToDoModel?

    weak var delegate: IDidTapButton?

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
        todoText.font = UIFont.systemFont(ofSize: 16)
        todoText.numberOfLines = 0
        todoText.textAlignment = .left
        todoText.translatesAutoresizingMaskIntoConstraints = false
        return todoText
    }()

    private lazy var todoName: UILabel = {
        let todoText = UILabel()
        todoText.font = UIFont.boldSystemFont(ofSize: 16)
        todoText.numberOfLines = 0
        todoText.textAlignment = .left
        todoText.translatesAutoresizingMaskIntoConstraints = false
        return todoText
    }()

    private lazy var completeToDo: UIButton = {
        let todoButton = UIButton(type: .system)
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        todoButton.tintColor = .systemBlue
        todoButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
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
        self.model = model
        todoName.text = model.name
        todoText.text = model.text
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let stringFromDate = formatter.string(from: model.date ?? .now)
        todoDate.text = stringFromDate
        switch model.isCompleted {
        case true:
            completeToDo.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        case false:
            completeToDo.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        }
    }

    private func addSubviews() {
        contentView.addSubview(todoName)
        contentView.addSubview(todoText)
        contentView.addSubview(todoDate)
        contentView.addSubview(completeToDo)
    }

    private func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            todoName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            todoName.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            todoName.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),

            todoText.topAnchor.constraint(equalTo: todoName.bottomAnchor, constant: 10),
            todoText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            todoText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),

            todoDate.topAnchor.constraint(equalTo: todoText.bottomAnchor, constant: 10),
            todoDate.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            todoDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -120),
            todoDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -35),

            completeToDo.centerYAnchor.constraint(equalTo: todoText.centerYAnchor),
            completeToDo.leadingAnchor.constraint(equalTo: todoText.trailingAnchor, constant: 40),
            completeToDo.heightAnchor.constraint(equalToConstant: 30),
            completeToDo.widthAnchor.constraint(equalToConstant: 30)

        ])
    }

    @objc func didTapButton(_ sender: UIButton) {
        self.model?.isCompleted.toggle()
        switch sender.backgroundImage(for: .normal) {
        case UIImage(systemName: "circle"):
            completeToDo.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal)
        case UIImage(systemName: "circle.fill"):
            completeToDo.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        default:
            completeToDo.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        }
        delegate?.didTapButton(self.model)
    }
}


extension String {
    static let id = "MainScreenTableCell"
}
