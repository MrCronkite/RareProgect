//
//  MessageCell.swift
//  RareStones
//
//  Created by admin1 on 16.08.23.
//

import UIKit

protocol MessageCellDelegate: AnyObject {
    func sendText(text: String)
}

final class MessageCell: UICollectionViewCell {
    let viewTextCell: UILabel = {
        let label = UILabel()
        label.greyColor()
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor(hexString: "#C9F0CC")
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    let viewText: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#C9F0CC")
        view.layer.cornerRadius = 15
        return view
    }()
    
    weak var delegate: MessageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCategoryCell()
        
       
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCategoryCell()
    }

    func setupCategoryCell() {
        viewText.addSubview(viewTextCell)
        self.addSubview(viewText)
        viewText.isUserInteractionEnabled = true
        viewText.translatesAutoresizingMaskIntoConstraints = false
        viewTextCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewText.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewText.widthAnchor.constraint(equalToConstant: 215),
            viewText.heightAnchor.constraint(equalToConstant: 54),
            
            viewTextCell.topAnchor.constraint(equalTo: viewText.topAnchor, constant: 10),
            viewTextCell.bottomAnchor.constraint(equalTo: viewText.bottomAnchor, constant: -10),
            viewTextCell.leadingAnchor.constraint(equalTo: viewText.leadingAnchor, constant: 16),
            viewTextCell.trailingAnchor.constraint(equalTo: viewText.trailingAnchor, constant: -16)
        ])
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(selectCell))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap1)
    }
    
    @objc func selectCell() {
        delegate?.sendText(text: viewTextCell.text ?? "")
    }
}
