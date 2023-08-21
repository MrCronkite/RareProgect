//
//  BaseViewOnbording.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import Lottie

final class BaseViewOnbording: UIViewController {
    
    @IBOutlet weak var subtitleText: UILabel!
    
    @IBOutlet weak var titleOriginal: UILabel!
    @IBOutlet weak var bgImgView: UIImageView!
    
    @IBOutlet weak var nameStone: UILabel!
    
    var nameAnimation = ""
    
    var animationView = LottieAnimationView()
    
    init(subtitle: String? = nil, nameAnimation: String){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        self.subtitleText.text = subtitle
        self.nameAnimation = nameAnimation
        
        setupAnimation()
        setupTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animationView.stop()
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    private func setupAnimation() {
        animationView = LottieAnimationView(name: nameAnimation)
        animationView.frame = CGRect(x: 0, y: -15, width: 360, height: 346)
        bgImgView.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        bgImgView.addSubview(animationView)
    }
    
    private func setupTitle() {
        if nameAnimation == "anim02" {
            nameStone.isHidden = false
            titleOriginal.isHidden = false
            let text = subtitleText.text ?? ""
            let attributeText = NSMutableAttributedString(string: text)
                    
            attributeText.addAttribute(.foregroundColor, value: R.Colors.active, range: NSRange(location: 40, length: 9))
            subtitleText.attributedText = attributeText
        } else {
            let text = subtitleText.text ?? ""
            let attributeText = NSMutableAttributedString(string: text)
                    
            attributeText.addAttribute(.foregroundColor, value: R.Colors.active, range: NSRange(location: 46, length: 5))
            attributeText.addAttribute(.foregroundColor, value: R.Colors.active, range: NSRange(location: 20, length: 9))
            subtitleText.attributedText = attributeText
        }
    }
    
}
