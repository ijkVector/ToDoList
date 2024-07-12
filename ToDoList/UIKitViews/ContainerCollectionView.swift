//
//  ContainerCollectionView.swift
//  ToDoList
//
//  Created by Иван Дроботов on 07.07.2024.
//

import Foundation
import UIKit

protocol TabelCellDelegate: AnyObject {
    func tappedItem(at ind: Int)
}

final class ContainerCollectionView: UIView {

    weak var delegate: TabelCellDelegate?
    var daysStore: [String] = [String]()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collecitonView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collecitonView.register(CalendarCellView.self, forCellWithReuseIdentifier: "\(CalendarCellView.self)")
        collecitonView.delegate = self
        collecitonView.dataSource = self
        return collecitonView
    }()

    init(daysStore: [String]) {
        self.daysStore = daysStore
        super.init(frame: .zero)
        style()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        backgroundColor = .systemGray
    }

    private func layout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func scrollToActualItem(at ind: Int) {
        let indexPath = IndexPath(item: ind, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension ContainerCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tappedItem(at: indexPath.item)
    }
}

extension ContainerCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize { CGSize(width: 60, height: 60) }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets { UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) }
}

extension ContainerCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysStore.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CalendarCellView.self)", for: indexPath) as? CalendarCellView else {
            return UICollectionViewCell()
        }
        cell.configure(text: daysStore[indexPath.item])
        return cell
    }
}
