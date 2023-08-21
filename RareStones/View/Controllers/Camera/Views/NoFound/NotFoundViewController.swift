//
//  NotFoundViewController.swift
//  RareStones
//
//  Created by admin1 on 13.08.23.
//

import UIKit

final class NotFoundViewController: UIViewController {
    
    var image = UIImage()
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var btnRetake: UIButton!
    @IBOutlet weak var btnPhotoTips: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainImageView.image = image
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func goRetake(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func goPhotoTips(_ sender: Any) {
        let vc = PhotoTipsViewController()
        present(vc, animated: true)
    }
}

extension NotFoundViewController {
    private func setupView() {
        mainImageView.layer.cornerRadius = 20
        mainImageView.layer.borderWidth = 8
        mainImageView.layer.borderColor = UIColor.white.cgColor
        mainImageView.contentMode = .scaleAspectFill
        
        subtitle.greyColor()
        btnRetake.backgroundColor = R.Colors.roseBtn
        btnRetake.layer.cornerRadius = 25
        btnPhotoTips.backgroundColor = R.Colors.purple
        btnPhotoTips.layer.cornerRadius = 25
    }
}
 
