//
//  CalendarCellView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 06.07.2024.
//

import UIKit

final class CalendarCellView: UICollectionViewCell {
    private let label = UILabel()

    func configure(text: String) {
        style(text: text)
        layout()
    }

    private func style(text: String) {
        layer.cornerRadius = 10
//        layer.backgroundColor = UIColor.systemGray.cgColor
        layer.borderColor = UIColor.customGray.cgColor
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = text
    }

    private func layout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .gray.withAlphaComponent(0.2) : .clear
            layer.borderWidth = isSelected ? 2 : 0
        }
    }
}
