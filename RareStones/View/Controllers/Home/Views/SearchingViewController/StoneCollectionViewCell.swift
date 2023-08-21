//
//  StoneCollectionViewCell.swift
//  RareStones
//
//  Created by admin1 on 10.08.23.
//

import UIKit

final class StoneCollectionViewCell: UICollectionViewCell {
    let cellView: CartStone
    
    override init(frame: CGRect) {
        cellView = CartStone(frame: CGRect(x: 0, y: 0, width: 166, height: 196))
        cellView.titleStone.greyColor()
        cellView.contentMode = .scaleAspectFit
        super.init(frame: frame)
        
        contentView.addSubview(cellView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
