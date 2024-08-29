import UIKit
import CoreData

class MainScreenViewController: UIViewController {

    // MARK: - Properties
    private var presenter: IMainScreenPresenter

    private lazy var mainToDoTable: UITableView = {
        let mainTable = UITableView()
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        return mainTable
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()


    // MARK: - Lifecycle

    init(presenter: IMainScreenPresenter!) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        tuneTableView()
        tuneNavItem()
        presenter.viewDidLoad(view: self)
        initialFetch()
    }

    // MARK: - Funcs

    private func tuneTableView() {
        mainToDoTable.delegate = self
        mainToDoTable.dataSource = self
        mainToDoTable.register(MainScreenTableCell.self, forCellReuseIdentifier: MainScreenTableCell.identifier)
        mainToDoTable.estimatedRowHeight = 44
        mainToDoTable.rowHeight = UITableView.automaticDimension
    }

    private func initialFetch() {
        presenter.initialFetch()
    }

    private func addSubviews() {
        view.addSubview(mainToDoTable)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainToDoTable.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainToDoTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            mainToDoTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            mainToDoTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    private func tuneNavItem() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewToDoItem(_:)))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc func addNewToDoItem(_ sender: UIBarButtonItem) {
        presenter.showCreateTodoView()
    }
}



// MARK: - Presenter Output
extension MainScreenViewController: IMainScreenView {
    
    func startAnimating() {
        view.addSubview(activityIndicator)
        let safeAre = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeAre.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAre.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    

    func showCreateView() {
        let todoView = UIAlertController(title: "Создать активность", message: "Укажите название", preferredStyle: .alert)
        todoView.addTextField { textfield in
            textfield.placeholder = "Введите название"
        }

        todoView.addTextField { textField in
            textField.placeholder = "Введите задание"
        }
        
        let action = UIAlertAction(title: "Запланировать", style: .default) { [weak self] action in
            guard let firstTextField = todoView.textFields?.first, let secondTextfield = todoView.textFields?.last, let taskName = firstTextField.text, let taskText = secondTextfield.text , !taskName.isEmpty, !taskText.isEmpty else { return }
            self?.presenter.addNewTask(text: taskText, name: taskName)
        }

        let cancellAction = UIAlertAction(title: "Отмена", style: .destructive)
        todoView.addAction(action)
        todoView.addAction(cancellAction)
        navigationController?.present(todoView, animated: true)
    }
    
    func updateData() {
        DispatchQueue.main.async {
            self.mainToDoTable.reloadData()
        }
    }

    func showErrorAlert(error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController()
            let alertAction = UIAlertAction(title: error, style: .cancel)
            alert.addAction(alertAction)
            self.navigationController?.present(alert, animated: true)
        }
    }
}

// MARK: - TableView DataSource
extension MainScreenViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter.coredataDatasource?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainScreenTableCell.identifier, for: indexPath) as? MainScreenTableCell else { return UITableViewCell() }
        guard let dataForCell = presenter.coredataDatasource?[indexPath.row] else { return UITableViewCell() }
        cell.updateCellWithCoredataModel(model: dataForCell)
        return cell
    }
    

}

// MARK: - TableView Delegate
extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


