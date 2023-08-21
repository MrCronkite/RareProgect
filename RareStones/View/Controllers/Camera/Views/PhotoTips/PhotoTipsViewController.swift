//
//  PhotoTipsViewController.swift
//  RareStones
//
//  Created by admin1 on 10.08.23.
//

import UIKit

final class PhotoTipsViewController: UIViewController {
     
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var textRoole: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnGo: UIButton!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
     }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToCame(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension PhotoTipsViewController {
    private func setupView() {
        titleText.textColor = R.Colors.darkGrey
        tintView.layer.cornerRadius = 3
        bgView.layer.cornerRadius = 25
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.white.cgColor
        bgView.backgroundColor = .white
        textRoole.greyColor()
        btnGo.backgroundColor = R.Colors.roseBtn
        btnGo.layer.cornerRadius = 25
    }
}
