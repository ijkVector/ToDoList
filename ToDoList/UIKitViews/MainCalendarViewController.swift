//
//  CalendarViewController.swift
//  ToDoList
//
//  Created by Иван Дроботов on 06.07.2024.
//

import UIKit

final class MainCalendarViewController: UIViewController {
    private var store: Store<AppState>
    private var sections: [(String, [TodoItem])] = [("28 июня", [TodoItem(text: "Some text", importance: .routine)])]

    struct Props {
        var items: [TodoItem]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private lazy var containerCollectinView: ContainerCollectionView = {
        let coontaiverCollectinView = ContainerCollectionView(daysStore: [])
        containerCollectinView.backgroundColor = .red
        return containerCollectinView
    }()

    private lazy var tableView: UITableView = {
        let tableView  = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.register(ItemCellView.self, forCellReuseIdentifier: "\(ItemCellView.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.contentInset.bottom = 500
        tableView.backgroundColor = .green
        return tableView
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iconPlusButton"), for: [.normal])
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        return button
    }()

    init(store: Store<AppState>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tappedButton() {

    }

    private func layout() {
        containerCollectinView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerCollectinView)
        view.addSubview(tableView)
        view.addSubview(addButton)

        NSLayoutConstraint.activate([

            containerCollectinView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerCollectinView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerCollectinView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerCollectinView.heightAnchor.constraint(equalToConstant: 80),

            tableView.topAnchor.constraint(equalTo: containerCollectinView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            addButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }
}

extension MainCalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ItemCellView.self)", for: indexPath) as? ItemCellView else { return UITableViewCell() }
        cell.configure(text: sections[indexPath.section].1[indexPath.row].text)
        return cell
    }

}

extension MainCalendarViewController: UITableViewDelegate {

}

extension MainCalendarViewController: TabelCellDelegate {
    func tappedItem(at ind: Int) {
        tableView.scrollToRow(at: IndexPath(item: 0, section: ind), at: .top, animated: true)
    }
}
