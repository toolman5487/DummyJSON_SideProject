//
//  TagPillCarouselView.swift
//  DummyJSONProject
//
//  Created by Willy Hsu on 2025/6/23.
//

import UIKit
import SnapKit

class TagPillCarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var tags: [String]
    private let collectionView: UICollectionView

    init(tags: [String]) {
        self.tags = tags
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        collectionView.contentInset.right = 80
        setupCollectionView()
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagPillCell.self, forCellWithReuseIdentifier: "TagPillCell")
    }

    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setTags(_ tags: [String]) {
        self.tags = tags
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagPillCell", for: indexPath) as! TagPillCell
        cell.configure(with: tags[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tags[indexPath.item]
        let font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let size = (text as NSString).size(withAttributes: [.font: font])
        let width = max(size.width + 24, 120)
        return CGSize(width: width, height: 40)
    }
}
