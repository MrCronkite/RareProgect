//
//  CartStone.swift
//  RareStones
//
//  Created by admin1 on 10.08.23.
//

import UIKit

protocol CartStoneDelegate: AnyObject {
   func deleteFromCollection()
   func openStone(id: Int)
}

final class CartStone: UIView {
    
    let networkStone = NetworkStoneImpl()
    
    var id = 0
    
    @IBOutlet weak var imageStone: UIImageView!
    @IBOutlet weak var titleStone: UILabel!
    @IBOutlet weak var priceStone: UILabel!
    
    @IBOutlet weak var btnHeart: UIButton!
    
    var isButtonSelected = false
    
    weak var delegate: CartStoneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(openStoneCard(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isButtonSelected.toggle()
        
        if isButtonSelected {
            sender.setImage(UIImage(named: "fillheart"), for: .normal)
            if id != 0 {
                networkStone.makePostRequestWashList(id: id)
            }
        } else {
            sender.setImage(UIImage(named: "heart"), for: .normal)
            networkStone.deleteStoneFromWishlist(stoneID: id)
            delegate?.deleteFromCollection()
        }
    }
    
    @objc func openStoneCard(_ sender: UITapGestureRecognizer) {
        delegate?.openStone(id: id)
    }
}

extension CartStone {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "CartStone") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        view.backgroundColor = UIColor(hexString: "#e5edfe")
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        imageStone.contentMode = .scaleAspectFill
        imageStone.clipsToBounds = true
        imageStone.layer.cornerRadius = 12
        
        btnHeart.layer.cornerRadius = 16

        btnHeart.layer.shadowColor = UIColor.black.cgColor
        btnHeart.layer.shadowOpacity = 0.2
        btnHeart.layer.shadowOffset = CGSize(width: 2, height: 2)
        btnHeart.layer.shadowRadius = 4
        btnHeart.backgroundColor = .white
    }
}
