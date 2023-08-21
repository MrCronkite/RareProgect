//
//  StartViewController.swift
//  RareStones
//
//  Created by admin1 on 19.08.23.
//

import UIKit
import Lottie

final class StartViewController: UIViewController {
    
    let imageNames = ["ston1", "ston2", "ston3", "ston4"]
    var currentImageIndex = 0
    var timer: Timer?
    var secondsElapsed = 0
    
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var imageAnimated: UIImageView!
    @IBOutlet weak var viewAnimated: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBG.contentMode = .scaleAspectFill
        setupAnimation()
        startImageAnimation()
    }
    
    @objc func changeImage() {
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
              let imageName = imageNames[currentImageIndex]
              
              UIView.transition(with: imageAnimated, duration: 0.5, options: .transitionCrossDissolve, animations: {
                  self.imageAnimated.image = UIImage(named: imageName)
              }, completion: nil)
              
              secondsElapsed += 1
              
              if secondsElapsed >= 8 {
                  timer?.invalidate()
                  let vc = OnbordingViewController()
                  vc.modalPresentationStyle = .fullScreen
                  present(vc, animated: true)
              }
    }
    
    private func startImageAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }
    
    private func setupAnimation() {
        let animationView = LottieAnimationView(name: "shine")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        viewAnimated.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        viewAnimated.addSubview(animationView)
        animationView.play()
    }
}
