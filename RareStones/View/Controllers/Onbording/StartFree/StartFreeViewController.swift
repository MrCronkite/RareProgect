//
//  StartFreeViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import Lottie

protocol StartFreeViewControllerDelegate: AnyObject {
    func showButton()
}

final class StartFreeViewController: UIViewController {
    
    @IBOutlet weak var privatePolTxt: UILabel!
    @IBOutlet weak var restoreTxt: UILabel!
    @IBOutlet weak var termUseTxt: UILabel!
    @IBOutlet weak var skipTxt: UILabel!
    
    @IBOutlet weak var viewAnime: UIView!
    @IBOutlet weak var imgViewBg: UIImageView!
    @IBOutlet weak var btnSetFree: UIButton!
    @IBOutlet weak var subtitleText: UILabel!
    let pulseLayer = CALayer()
    let animationView = LottieAnimationView(name: "Animstone4")
    
    weak var delegate: StartFreeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        setupView()
        
        let tapSkip = UITapGestureRecognizer(target: self, action:  #selector(goSkip))
        skipTxt.addGestureRecognizer(tapSkip)
        skipTxt.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.showButton()
        self.btnSetFree.isHidden = false
        setupPulsingAnimation()
        UIView.animate(withDuration: 0.7) {
            self.btnSetFree.backgroundColor = R.Colors.roseBtn
            self.btnSetFree.tintColor = .white
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.7) {
            self.btnSetFree.backgroundColor = .clear
            self.pulseLayer.backgroundColor = UIColor.clear.cgColor
            self.btnSetFree.tintColor = .clear
        }
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @objc func goSkip() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension StartFreeViewController {
    private func setupView() {
        imgViewBg.contentMode = .scaleAspectFill
        
        btnSetFree.backgroundColor = R.Colors.roseBtn
        btnSetFree.layer.cornerRadius = 25
        
        let text = "Open up limitless possibilities"
                let attributeText = NSMutableAttributedString(string: text)
                
        attributeText.addAttribute(.foregroundColor, value: UIColor(hexString: "#4C4752"), range: NSRange(location: 0, length: 7))
                
        subtitleText.attributedText = attributeText
    }
    
    private func setupPulsingAnimation() {
        pulseLayer.bounds = btnSetFree.bounds
        pulseLayer.position = btnSetFree.center
        pulseLayer.cornerRadius = 25
        pulseLayer.backgroundColor = R.Colors.roseBtn.cgColor
        view.layer.insertSublayer(pulseLayer, below: btnSetFree.layer)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 1
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsing")
    }
    
    private func setupAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 343, height: 280)
        viewAnime.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnime.addSubview(animationView)
        animationView.play()
    }
}
