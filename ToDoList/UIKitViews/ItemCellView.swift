//
//  ItemCellView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 06.07.2024.
//

import UIKit

final class ItemCellView: UITableViewCell {

    private let label = UILabel()
    private let point = UIView()

    func configure(text: String) {
        style(text: text)
        layout()
    }

    private func style(text: String) {
        label.text = text
        label.numberOfLines = 3
        point.layer.cornerRadius = 5
        point.layer.masksToBounds = true
    }

    private func layout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        point.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(point)

        NSLayoutConstraint.activate([

            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: point.leadingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            point.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            point.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            point.heightAnchor.constraint(equalToConstant: 8),
            point.widthAnchor.constraint(equalToConstant: 8),
            point.centerYAnchor.constraint(equalTo: centerYAnchor)

        ])
    }
}
