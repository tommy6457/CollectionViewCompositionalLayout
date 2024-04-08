//
//  HorizontalHeaderCollectionReusableView.swift
//  CollectionViewCompositionalLayout
//
//  Created by Sam Lee iMac24 on 2024/4/2.
//

import UIKit

class HorizontalHeaderCollectionReusableView: UICollectionReusableView {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func fill(indexPath: IndexPath) {
        label.text = "row:\(indexPath.row)"
    }
    
    private func configure() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        backgroundColor = .lightGray
    }
    
}
