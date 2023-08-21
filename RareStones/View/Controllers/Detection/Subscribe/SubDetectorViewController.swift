//
//  SubDetectorViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit

final class SubDetectorViewController: UIViewController {
    
    @IBOutlet weak var imgViewBg: UIImageView!
    @IBOutlet weak var btnWatch: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    @IBAction func closeVc(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func watchAd(_ sender: Any) {
    }
    
    @IBAction func goSub(_ sender: Any) {
    }
}

extension SubDetectorViewController {
    private func setupView() {
        imgViewBg.contentMode = .scaleAspectFill
        btnSub.layer.cornerRadius = 25
        btnWatch.layer.cornerRadius = 25
    }
}
