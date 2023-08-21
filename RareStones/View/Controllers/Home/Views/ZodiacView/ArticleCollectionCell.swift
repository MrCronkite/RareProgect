//
//  ActicleCollectionCell.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

final class ArticleCollectionCell: UICollectionViewCell {
    
    let cartArticle: CartArticle
    
    override init(frame: CGRect) {
        cartArticle = CartArticle(frame: CGRect(x: 0, y: 0, width: 363, height: 252))
        cartArticle.nameStone.textColor = R.Colors.darkGrey
        cartArticle.contentMode = .scaleAspectFit
        super.init(frame: frame)
        
        contentView.addSubview(cartArticle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





