//
//  HeaderFooterCollectionReusableView.swift
//  CollectionViewCompositionalLayout
//
//  Created by Sam Lee iMac24 on 2024/4/1.
//

import UIKit

class HeaderFooterCollectionReusableView: UICollectionReusableView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func fill(with section: Section) {
        switch section {
        case .horizontalScrollSection:
            label.text = "水平滑動"
        case .verticalScrollSection:
            label.text = "垂直滑動"
        case .verticalItemHorizontalScrollSection:
            label.text = "垂直相疊，水平滑動"
        default :
            label.text = "標題"
        }
    }
    
    private func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        backgroundColor = .lightGray
    }

}
