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
    @IBOutlet weak var viewAnim: UIView!
    @IBOutlet weak var nameStone: UILabel!
    
    var nameAnimation = ""
    var animationView: LottieAnimationView?
    
    init(subtitle: String? = nil, nameAnimation: String){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        nameStone.text = "onb_sub_diamond".localized
        titleOriginal.text = "onb_original".localized
        titleOriginal.adjustsFontSizeToFitWidth = true
        self.subtitleText.text = subtitle?.localized
        self.subtitleText.adjustsFontSizeToFitWidth = true
        self.nameAnimation = nameAnimation
        setupAnimation()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setupLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationView?.frame = CGRect(x: 0, y: 0, width: viewAnim.frame.width, height: viewAnim.frame.height)
    }
    
    private func setupAnimation() {
        animationView = LottieAnimationView(name: nameAnimation)
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = 1.5
        viewAnim.addSubview(animationView!)
        animationView?.play()
    }
    
    private func setupTitle() {
        if nameAnimation == "anim02" {
            nameStone.isHidden = false
            titleOriginal.isHidden = false
            let text = subtitleText.text ?? ""
            let words = text.split(separator: " ")
            
            if words.count >= 2 {
                let atributedWord = words[5]
                
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.foregroundColor, value: R.Colors.active, range: (text as NSString).range(of: String(atributedWord)))
                
                subtitleText.attributedText = attributedText
            }
        } else {
            let text = subtitleText.text ?? ""
            let words = text.split(separator: " ")
            
            if words.count >= 2 {
                let atributedWordThree = words[3]
//                let atributedWordSeven = words[6]
                
                let attributedText = NSMutableAttributedString(string: text)
                attributedText.addAttribute(.foregroundColor, value: R.Colors.active, range: (text as NSString).range(of: String(atributedWordThree)))
                //attributedText.addAttribute(.foregroundColor, value: R.Colors.active, range: (text as NSString).range(of: String(atributedWordSeven)))
                
                subtitleText.attributedText = attributedText
            }
        }
    }
}
