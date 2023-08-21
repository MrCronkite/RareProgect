//
//  CartArticle.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

protocol CartArticleDelegate: AnyObject {
    func sendDataStone(idStone: Int)
}


final class CartArticle: UIView {
    
    var id = 0
    let networkStone = NetworkStoneImpl()
    
    @IBOutlet weak var borderImg: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLable: UILabel!
    
    @IBOutlet weak var nameStone: UILabel!
    @IBOutlet weak var costText: UILabel!
    
    weak var delegate: CartArticleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @IBAction func goToCartStone(_ sender: Any) {
        delegate?.sendDataStone(idStone: id)
    }
}

extension CartArticle {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "CartArticle") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        self.backgroundColor = .clear
        borderImg.layer.cornerRadius = 15
        borderImg.backgroundColor = UIColor(hexString: "#708fe7")
        
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        
        containerView.backgroundColor = R.Colors.blueLight
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 1
        
        textLable.backgroundColor = .clear
        textLable.greyColor()
        
        nameStone.textColor = R.Colors.darkGrey
        costText.greyColor()
    }
}
