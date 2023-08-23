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
    
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var imgViewBg: UIImageView!
    @IBOutlet weak var btnWatch: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    
    weak var delegate: SubDetectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        loadAd()
        view.setupLayer()
    }
    @IBAction func closeVc(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func watchAd(_ sender: Any) {
        self.rewardedInterstitialAd?.present(fromRootViewController: self) {
            _ = self.rewardedInterstitialAd?.adReward
        }
    }
    
    @IBAction func goSub(_ sender: Any) {
            let vc = StartFreeViewController()
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
    }
    
    private func loadAd() {
        GADRewardedInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/6978759866",
                                       request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            
            self.rewardedInterstitialAd = ad
            let options = GADServerSideVerificationOptions()
            options.customRewardString = "SAMPLE_CUSTOM_DATA_STRING"
            self.rewardedInterstitialAd!.serverSideVerificationOptions = options
            self.rewardedInterstitialAd?.fullScreenContentDelegate = self
        }
    }
}

extension SubDetectorViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        delegate?.showAdd()
        dismiss(animated: true)
    }
}



