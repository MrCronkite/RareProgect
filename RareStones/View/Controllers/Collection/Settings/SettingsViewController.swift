//
//  SettingsViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit
import MessageUI

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak var inviteTxt: UILabel!
    @IBOutlet weak var privacyTxt: UILabel!
    @IBOutlet weak var rateTxt: UILabel!
    @IBOutlet weak var termTxt: UILabel!
    @IBOutlet weak var supportTxt: UILabel!
    
    @IBOutlet weak var inviteView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var supportVIew: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteTxt.greyColor()
        privacyTxt.greyColor()
        rateTxt.greyColor()
        termTxt.greyColor()
        supportTxt.greyColor()
        
        let tapInvite = UITapGestureRecognizer(target: self, action: #selector(invite(_:)))
        inviteView.addGestureRecognizer(tapInvite)
        inviteView.isUserInteractionEnabled = true
        
        let tapRate = UITapGestureRecognizer(target: self, action: #selector(rate(_:)))
        rateView.addGestureRecognizer(tapRate)
        rateView.isUserInteractionEnabled = true
        
        let tapPrivacy = UITapGestureRecognizer(target: self, action: #selector(privacy(_:)))
        privacyView.addGestureRecognizer(tapPrivacy)
        privacyView.isUserInteractionEnabled = true
        
        let tapTerm = UITapGestureRecognizer(target: self, action: #selector(term(_:)))
        termView.addGestureRecognizer(tapTerm)
        termView.isUserInteractionEnabled = true
        
        let tapSupport = UITapGestureRecognizer(target: self, action: #selector(support(_:)))
        supportVIew.addGestureRecognizer(tapSupport)
        supportVIew.isUserInteractionEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func invite(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: inviteView)
        let textToShare = "Привет! Я использую это замечательное приложение!"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func rate(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: rateView)
        if let url = URL(string: "itms-apps://itunes.apple.com/app/idYOUR_APP_ID?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func privacy(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: privacyView)
        guard let url = URL(string: "https://ai-stones.com/privacy.html") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func term(_ sender: UITapGestureRecognizer) {
        animateButtonPressed(view: termView)
        guard let url = URL(string: "https://ai-stones.com/terms.html") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func support(_ sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["vladshima99@gmail.com"])
            mailComposeViewController.setSubject("Stone Detector - Support")
            mailComposeViewController.setMessageBody("Hi", isHTML: false)
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            alert()
        }
    }
    
    private func alert() {
        let alert = UIAlertController(title: "Oops", message: "sending mail is not available", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func animateButtonPressed(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 0.7
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                view.alpha = 1.0
                view.transform = CGAffineTransform.identity
            })
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


