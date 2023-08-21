//
//  TipsStoneCell.swift
//  RareStones
//
//  Created by admin1 on 19.08.23.
//

import UIKit

protocol TipsStoneCellDelegate: AnyObject {
    func buttonTapped(in cell: TipsStoneCell)
}

final class TipsStoneCell: UICollectionViewCell {
    
    var isExpanded: Bool = false {
           didSet {
               if isExpanded {
                   showBtn.setTitle("Roll up", for: .normal)
               } else {
                   showBtn.setTitle("See more", for: .normal)
               }
           }
       }
    
    var indexCell = 0
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var showBtn: UIButton!
    
    weak var delegate: TipsStoneCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @IBAction func showText(_ sender: Any) {
        delegate?.buttonTapped(in: self)
    }
}

extension TipsStoneCell {
    private func setupView() {
        guard let view = self.loadViewFromNib(nibName: "TipsStoneCell") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.clipsToBounds = true
    }
}
