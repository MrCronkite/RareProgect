//
//  SubscribeCameraViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import Lottie

protocol SubscribeCameraViewControllerDelegate: AnyObject {
    func showMatchesStone(_ isAdView: Bool)
}

final class SubscribeCameraViewController: UIViewController {
    
    var image = UIImage()
    
    weak var delegate: SubscribeCameraViewControllerDelegate?
    var isAdviewed = false
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
    
    @IBOutlet weak var bgViewSearching: UIView!
    @IBOutlet weak var imgSearching: UIImageView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var animeView: UIView!
    
    @IBOutlet weak var btnAd: UIButton!
    @IBOutlet weak var btnSubscribe: UIButton!
    
    @IBOutlet weak var viewAnimateStar: UIView!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var separator: UIView!
    
    let animationView = LottieAnimationView(name: "shine")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        imgSearch.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        separator.layer.cornerRadius = 3
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        blurView.center = self.blurView.center
        blurView.layer.cornerRadius = 14
        blurView.clipsToBounds = true
        
        self.blurView.addSubview(blurView)
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.showMatchesStone(isAdviewed)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func showAd(_ sender: Any) {
        isAdviewed = true
    }
    
    @IBAction func subscribeAd(_ sender: Any) {
    }

}

extension SubscribeCameraViewController {
    private func setupView() {
        bgView.layer.cornerRadius = 20
        imgSearch.contentMode = .scaleAspectFill
        imgSearch.clipsToBounds = true
        imgSearch.layer.cornerRadius = 14
        
        bgViewSearching.layer.cornerRadius = 20
        imgSearching.contentMode = .scaleAspectFill
        imgSearching.clipsToBounds = true
        imgSearching.layer.cornerRadius = 14
        priceView.layer.cornerRadius = 13
        
        btnAd.layer.cornerRadius = 25
        btnSubscribe.layer.cornerRadius = 25
    }
    
    private func setupAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 380, height: 330)
        viewAnimateStar.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnimateStar.addSubview(animationView)
        
        animationView.play()
    }
}

