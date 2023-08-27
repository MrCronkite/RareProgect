//
//  SubDetectorViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import GoogleMobileAds

protocol SubDetectorViewControllerDelegate: AnyObject {
    func showAdd()
}

final class SubDetectorViewController: UIViewController {
    
    private var rewardedInterstitialAd: GADRewardedInterstitialAd?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var imgViewBg: UIImageView!
    @IBOutlet weak var btnWatch: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    
    weak var delegate: SubDetectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    @IBAction func closeVc(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func watchAd(_ sender: Any) {
        if let rewardedInterAd = rewardedInterstitialAd {
            rewardedInterAd.present(fromRootViewController: self) {
                print("adReward")
            }
        }
    }
    
    @IBAction func goSub(_ sender: Any) {
            let vc = GetPremiumViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
    }
}

extension SubDetectorViewController {
    private func setupView() {
        imgViewBg.contentMode = .scaleAspectFill
        btnSub.layer.cornerRadius = 25
        btnWatch.layer.cornerRadius = 25
        separator.layer.cornerRadius = 2
        
        self.btnSub.makeAnimationButton(self.btnSub)
        self.btnWatch.makeAnimationButton(self.btnWatch)
        titleLable.text = "detect_sub_title".localized
        subtitle.text = "detect_sub_subtitle".localized
        btnSub.setTitle("cam_sub_btn_sub".localized, for: .normal)
        btnWatch.setTitle("cam_sub_btn_ad".localized, for: .normal)
        closeButton.setTitle("", for: .normal)
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

extension SubDetectorViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.showAdd()
        dismiss(animated: true)
    }
}



