//
//  GetPremiumViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit
import GoogleMobileAds

final class GetPremiumViewController: UIViewController {
    
    private var interstitial: GADInterstitialAd?
    
    @IBOutlet weak var txtTile: UILabel!
    @IBOutlet weak var perWeekTile: UILabel!
    
    @IBOutlet weak var subtitle5: UILabel!
    @IBOutlet weak var subtitle4: UILabel!
    @IBOutlet weak var subtitle3: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var bestPriceLable: UILabel!
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var btnOffer: UIButton!
    @IBOutlet weak var skipTxt: UILabel!
    @IBOutlet weak var restoreTxt: UILabel!
    @IBOutlet weak var termTxt: UILabel!
    @IBOutlet weak var privacyPolTxt: UILabel!
    
    @IBOutlet weak var timer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        loadAd()
        TimerManager.shared.startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("TimerTickNotification"), object: nil)
    }
    
    @IBAction func getOffer(_ sender: Any) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
          } else {
            print("Ad wasn't ready")
          }
    }
}

extension GetPremiumViewController {
    private func setupView() {
        txtTile.shadowColor = UIColor.black
        txtTile.shadowOffset = CGSize(width: 2, height: 2)
        perWeekTile.shadowColor = UIColor.black
        perWeekTile.shadowOffset = CGSize(width: 2, height: 2)
        btnOffer.layer.cornerRadius = 25
        imageBg.contentMode = .scaleAspectFill
        
        let tapSkip = UITapGestureRecognizer(target: self, action: #selector(goBack))
        skipTxt.addGestureRecognizer(tapSkip)
        skipTxt.isUserInteractionEnabled = true
        
        let tapRestore = UITapGestureRecognizer(target: self, action: #selector(restore))
        restoreTxt.addGestureRecognizer(tapRestore)
        restoreTxt.isUserInteractionEnabled = true
        
        let tapTermUse = UITapGestureRecognizer(target: self, action: #selector(goTermOfUse))
        termTxt.addGestureRecognizer(tapTermUse)
        termTxt.isUserInteractionEnabled = true
        
        let tapPolicy = UITapGestureRecognizer(target: self, action: #selector(goPolicy))
        privacyPolTxt.addGestureRecognizer(tapPolicy)
        privacyPolTxt.isUserInteractionEnabled = true
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: interval) ?? "00:00:00"
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
    
    private func localize() {
        perWeekTile.text = "pr_week".localized
        perWeekTile.adjustsFontSizeToFitWidth = true
        bestPriceLable.text = "pr_best_price".localized
        bestPriceLable.adjustsFontSizeToFitWidth = true
        subtitle1.text = "onb_free_first".localized
        subtitle2.text = "onb_free_second".localized
        subtitle3.text = "onb_free_third".localized
        subtitle4.text = "onb_free_fourtin".localized
        subtitle5.text = "pr_subtitle".localized
        btnOffer.setTitle("pr_btn".localized, for: .normal)
        restoreTxt.text = "onb_free_restore".localized
        restoreTxt.adjustsFontSizeToFitWidth = true
        termTxt.text = "onb_free_term_us".localized
        termTxt.adjustsFontSizeToFitWidth = true
        privacyPolTxt.text = "onb_free_private".localized
        privacyPolTxt.adjustsFontSizeToFitWidth  = true
        skipTxt.text = "onb_free_skip".localized
    }
    
    @objc func goBack() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    @objc func updateUI() {
        let remainingTime = TimerManager.shared.remainingTime
        let formattedTime = formatTimeInterval(remainingTime)
        timer.text = formattedTime
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

extension GetPremiumViewController: GADFullScreenContentDelegate {
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        dismiss(animated: true)
      }
}
