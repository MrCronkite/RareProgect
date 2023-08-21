//
//  GetPremiumViewController.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import UIKit

final class GetPremiumViewController: UIViewController {
    
    @IBOutlet weak var txtTile: UILabel!
    @IBOutlet weak var perWeekTile: UILabel!
    
    @IBOutlet weak var btnOffer: UIButton!
    @IBOutlet weak var skipTxt: UILabel!
    @IBOutlet weak var restoreTxt: UILabel!
    @IBOutlet weak var termTxt: UILabel!
    @IBOutlet weak var privacyPolTxt: UILabel!
    
    @IBOutlet weak var timer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        TimerManager.shared.startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("TimerTickNotification"), object: nil)
        
        let tapSkip = UITapGestureRecognizer(target: self, action: #selector(goBack))
        skipTxt.addGestureRecognizer(tapSkip)
        skipTxt.isUserInteractionEnabled = true
    }
    
    @IBAction func getOffer(_ sender: Any) {
    }
    
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    @objc func updateUI() {
        let remainingTime = TimerManager.shared.remainingTime
        let formattedTime = formatTimeInterval(remainingTime)
        timer.text = formattedTime
    }
}

extension GetPremiumViewController {
    private func setupView() {
        txtTile.shadowColor = UIColor.black
        txtTile.shadowOffset = CGSize(width: 2, height: 2)
        perWeekTile.shadowColor = UIColor.black
        perWeekTile.shadowOffset = CGSize(width: 2, height: 2)
        btnOffer.layer.cornerRadius = 25
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: interval) ?? "00:00:00"
    }
}
