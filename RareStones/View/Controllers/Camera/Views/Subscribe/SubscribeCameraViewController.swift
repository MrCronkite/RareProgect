//
//  SubscribeCameraViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import Lottie
import GoogleMobileAds

protocol SubscribeCameraViewControllerDelegate: AnyObject {
    func showMatchesStone()
}

final class SubscribeCameraViewController: UIViewController {
    
    var image = UIImage()
    
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    weak var delegate: SubscribeCameraViewControllerDelegate?
    
    @IBOutlet weak var priceStone: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleView: UILabel!
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
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleOpen: UILabel!
    @IBOutlet weak var separator: UIView!
    
    let animationView = LottieAnimationView(name: "shine")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
        setupView()
        setupLocalize()
        imgSearch.image = image
        separator.layer.cornerRadius = 3
        
        
        setupAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // delegate?.showMatchesStone(isAdviewed)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func showAd(_ sender: Any) {
        if let rewardedInterAd = rewardedInterstitialAd {
            rewardedInterAd.present(fromRootViewController: self) {
                print("adReward")
            }
        }
    }
    
    @IBAction func subscribeAd(_ sender: Any) {
        let vc = GetPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
        let blurEffect = UIBlurEffect(style: R.Strings.Camera.styles.randomElement()!)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.imgSearching.bounds
        
        imgSearching.addSubview(blurView)
        
        let randomNumberUp = (Int.random(in: (20 / 10)...(200 / 10)) * 10)
        let randomNumbeTo = (Int.random(in: (500 / 10)...(20000 / 10)) * 10)
        priceStone.text = "$\(randomNumberUp) - $\(randomNumbeTo) / ct"
    }
    
    private func setupAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 380, height: 330)
        viewAnimateStar.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnimateStar.addSubview(animationView)
        
        animationView.play()
    }
    
    private func setupLocalize() {
        closeButton.setTitle("", for: .normal)
        titleView.text = "cam_sub_title".localized
        titleView.adjustsFontSizeToFitWidth = true
        titleOpen.text = "cam_sub_title_open".localized
        subtitle.text = "cam_sub_subtitle".localized
        btnAd.setTitle("cam_sub_btn_ad".localized, for: .normal)
        btnSubscribe.setTitle("cam_sub_btn_sub".localized, for: .normal)
    }
    
    private func loadAd() {
        GADRewardedInterstitialAd.load(withAdUnitID: R.Strings.KeyAd.rewardedInterKey,
                                       request: GADRequest()) { ad, error in
            if let error = error {
                self.loadAd()
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            self.rewardedInterstitialAd = ad
            self.rewardedInterstitialAd?.fullScreenContentDelegate = self
        }
    }
}

extension SubscribeCameraViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.showMatchesStone()
        dismiss(animated: true)
    }
}

