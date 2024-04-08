//
//  ViewController.swift
//  CollectionViewCompositionalLayout
//
//  Created by Sam Lee iMac24 on 2024/4/1.
//

import UIKit

enum Section: Int, CaseIterable {
    
    case horizontalScrollSection = 0
    case verticalScrollSection = 1
    case verticalItemHorizontalScrollSection = 2
    
    func getNumbersOfItem() -> Int {
        switch self {
        case .horizontalScrollSection:
            return 12
        case .verticalScrollSection:
            return 10
        case .verticalItemHorizontalScrollSection:
            return 11
        }
    }
}

class ViewController: UIViewController {
    
    struct Constants {
        static let verticalItemHorizontalScrollWidth = (UIScreen.current?.bounds.size.width ?? 0) - padding * 2
        static let padding: CGFloat = 20.0
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = creatLayout()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "VerticalHeaderView")
    }
    
    private func creatLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .horizontalScrollSection:
                return self.createHorizontalScrollSection()
            case .verticalScrollSection:
                return self.createVerticalScrollSection()
            case .verticalItemHorizontalScrollSection:
                return self.createVerticalItemHorizontalScrollSection()
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return section.getNumbersOfItem()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: "VerticalHeaderView", for: indexPath) as! HeaderFooterCollectionReusableView
        guard let section = Section(rawValue: indexPath.section) else {
            header.label.text = "Header section:\(indexPath.section) row:\(indexPath.row)"
            return header
        }
        header.fill(with: section)
        return header
    }
}
//MARK: - creat section
extension ViewController {
    private func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(44.0),
                                               heightDimension: .absolute(44.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: nil, top: nil, trailing: .fixed(10.0), bottom: nil)
        //一頁顯示3個
        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        // 設定 header 的大小
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        // 負責描述 supplementary item 的物件
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top,
                                                                     absoluteOffset: CGPoint(x: 0, y: 0))
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        //item 顯示前會觸發，可在此更改layout
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    private func createVerticalScrollSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(54.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .none
        // 設定 header 的大小
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        // 負責描述 supplementary item 的物件
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top,
                                                                     absoluteOffset: CGPoint(x: 0, y: 0))
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        return section
    }
    
    private func createVerticalItemHorizontalScrollSection() -> NSCollectionLayoutSection {
        // 提供三種不同形狀的 item
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let layoutSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(65))
        let item2 = NSCollectionLayoutItem(layoutSize: layoutSize2)
        let layoutSize3 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(85))
        let item3 = NSCollectionLayoutItem(layoutSize: layoutSize3)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(Constants.verticalItemHorizontalScrollWidth),
                                               heightDimension: .absolute(205))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item2, item3])
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10.0
        
        // 設定 header 的大小
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        // 負責描述 supplementary item 的物件
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top,
                                                                     absoluteOffset: CGPoint(x: 0, y: 0))
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        
        return section
    }
}
