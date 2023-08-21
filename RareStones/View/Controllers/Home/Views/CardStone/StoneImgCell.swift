//
//  StoneImgCell.swift
//  RareStones
//
//  Created by admin1 on 14.08.23.
//

import UIKit

final class StoneImgCell: UICollectionViewCell {
    
    let imgCell: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCategoryCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCategoryCell()
    }
    
    func setupCategoryCell() {
        self.addSubview(imgCell)
        imgCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imgCell.widthAnchor.constraint(equalToConstant: 78),
            imgCell.heightAnchor.constraint(equalToConstant: 78)
        ])
    }
}
