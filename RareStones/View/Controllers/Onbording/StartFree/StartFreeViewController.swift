//
//  StartFreeViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import Lottie
import GoogleMobileAds

protocol StartFreeViewControllerDelegate: AnyObject {
    func showButton()
}

final class StartFreeViewController: UIViewController {
    
    var animation: LottieAnimationView?
    let pulseLayer = CALayer()
    weak var delegate: StartFreeViewControllerDelegate?
    private var interstitial: GADInterstitialAd?
    
    @IBOutlet weak var viewAnimateContainer: UIView!
    @IBOutlet weak var privatePolTxt: UILabel!
    @IBOutlet weak var restoreTxt: UILabel!
    @IBOutlet weak var termUseTxt: UILabel!
    @IBOutlet weak var skipTxt: UILabel!
    
    @IBOutlet weak var btnSetFree: UIButton!
    @IBOutlet weak var freeLableFaive: UILabel!
    @IBOutlet weak var freeLableFourtin: UILabel!
    @IBOutlet weak var freeLableThird: UILabel!
    @IBOutlet weak var freeLableSecond: UILabel!
    @IBOutlet weak var freeLableFirst: UILabel!
    @IBOutlet weak var subtitleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupAnimation()
        loadAd()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.showButton()
        self.btnSetFree.isHidden = false
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
        animation!.frame = viewAnimateContainer.bounds
        setupPulsingAnimation()
        view.setupLayer()
    }
    
    @IBAction func getOffer(_ sender: Any) {
    }
}

extension StartFreeViewController {
    private func setupView() {
        btnSetFree.backgroundColor = R.Colors.roseBtn
        btnSetFree.layer.cornerRadius = 25
        
        let text = subtitleText.text ?? ""
        let words = text.split(separator: " ")
        
        if words.count >= 2 {
            let atributedWord = words[0]
            print(atributedWord)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.foregroundColor, value: R.Colors.darkGrey, range: (text as NSString).range(of: String(atributedWord)))
            
            subtitleText.attributedText = attributedText
        }
        
        let tapSkip = UITapGestureRecognizer(target: self, action:  #selector(goSkip))
        skipTxt.addGestureRecognizer(tapSkip)
        skipTxt.isUserInteractionEnabled = true
        
        let tapRestore = UITapGestureRecognizer(target: self, action: #selector(restore))
        restoreTxt.addGestureRecognizer(tapRestore)
        restoreTxt.isUserInteractionEnabled = true
        
        let tapTermUse = UITapGestureRecognizer(target: self, action: #selector(goTermOfUse))
        termUseTxt.addGestureRecognizer(tapTermUse)
        termUseTxt.isUserInteractionEnabled = true
        
        let tapPolicy = UITapGestureRecognizer(target: self, action: #selector(goPolicy))
        privatePolTxt.addGestureRecognizer(tapPolicy)
        privatePolTxt.isUserInteractionEnabled = true
    }
    
    private func localize() {
        subtitleText.text = "onb_sub_third".localized
        subtitleText.adjustsFontSizeToFitWidth = true
        freeLableFirst.text = "onb_free_first".localized
        freeLableSecond.text = "onb_free_second".localized
        freeLableThird.text = "onb_free_third".localized
        freeLableFourtin.text = "onb_free_fourtin".localized
        freeLableFaive.text = "onb_free_faive".localized
        btnSetFree.setTitle("onb_free_btn".localized, for: .normal)
        restoreTxt.text = "onb_free_restore".localized
        restoreTxt.adjustsFontSizeToFitWidth = true
        termUseTxt.text = "onb_free_term_us".localized
        privatePolTxt.text = "onb_free_private".localized
        privatePolTxt.adjustsFontSizeToFitWidth = true
        skipTxt.text = "onb_free_skip".localized
    }
    
    private func setupPulsingAnimation() {
        pulseLayer.bounds = btnSetFree.bounds
        pulseLayer.position = btnSetFree.center
        pulseLayer.cornerRadius = 25
        pulseLayer.backgroundColor = R.Colors.roseBtn.cgColor
        view.layer.insertSublayer(pulseLayer, below: btnSetFree.layer)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsing")
    }
    
    private func setupAnimation() {
        animation = .init(name: "Animstone4")
        animation?.contentMode = .scaleAspectFit
        animation?.loopMode = .loop
        animation?.animationSpeed = 1.5
        viewAnimateContainer.addSubview(animation!)
        animation?.play()
    }
    
    private func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: R.Strings.KeyAd.interKey,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                loadAd()
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    @objc func goSkip() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    @objc func restore() {
    }
    
    @objc func goTermOfUse() {
        guard let url = URL(string: R.Strings.Links.terms) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
    
    @objc func goPolicy() {
        guard let url = URL(string: R.Strings.Links.privacy) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: nil)
        }
    }
}

extension StartFreeViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        dismiss(animated: true)
    }
}
