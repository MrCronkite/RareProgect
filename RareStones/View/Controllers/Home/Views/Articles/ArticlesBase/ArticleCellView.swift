//
//  ArticleCellView.swift
//  RareStones
//
//  Created by admin1 on 18.08.23.
//

import UIKit

final class ArticleCellView: UICollectionViewCell {
    
    var topValueConstraint = 25
    var topValueConstraintImg = 180
    
    let lableTextCell: UILabel = {
        let lable = UILabel()
        lable.textColor = R.Colors.darkGrey
        lable.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    let txtView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 16)
        view.isScrollEnabled = false
        view.textColor = R.Colors.textColor
        view.backgroundColor = .clear
        view.textContainerInset = .zero
        view.isEditable = false
        return view
    }()
    
    let imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        return view
    }()
    
    var isTextEmpty: Bool = false {
        didSet {
            updateConstraints()
        }
    }
    
    var isImageEmpty: Bool = false {
            didSet {
                updateConstraints()
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setupCategoryCell()
        
        if isTextEmpty {
            lableTextCell.isHidden = true
            lableTextCell.text = ""
            topValueConstraint = 0
        } else {
            lableTextCell.isHidden = false
        }
        
       if isImageEmpty {
            topValueConstraintImg = 0
       } else {
           topValueConstraintImg = 180
       }
    }
    
    
    func configure(with text: String?, hasImage: Bool) {
            isTextEmpty = text == nil || text?.isEmpty == true
            isImageEmpty = !hasImage
            lableTextCell.text = text
    }
    
    func setupCategoryCell() {
        self.addSubview(lableTextCell)
        self.addSubview(txtView)
        self.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        txtView.translatesAutoresizingMaskIntoConstraints = false
        lableTextCell.translatesAutoresizingMaskIntoConstraints = false
        lableTextCell.contentMode = .scaleAspectFill
        lableTextCell.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imgView.heightAnchor.constraint(equalToConstant: CGFloat(topValueConstraintImg)),
            
            lableTextCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            lableTextCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lableTextCell.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 5),
            lableTextCell.heightAnchor.constraint(equalToConstant: 20),
            
            txtView.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: CGFloat(topValueConstraint)),
            txtView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            txtView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            txtView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
