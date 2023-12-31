//
//  DetectionViewController.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit
import CoreMotion
import CoreLocation

final class DetectionViewController: UIViewController{
    
    var percent = 0
    var isAdViewed = false
    let motionManager = CMMotionManager()
    
    @IBOutlet weak var lableSubtitle: UILabel!
    @IBOutlet weak var lableText: UILabel!
    @IBOutlet weak var polygon: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var stackView: UIView!
    
    @IBOutlet weak var box1: UILabel!
    @IBOutlet weak var box2: UILabel!
    @IBOutlet weak var box3: UILabel!
    
    @IBOutlet weak var subtitle1: UILabel!
    @IBOutlet weak var subtitle2: UILabel!
    @IBOutlet weak var subtitle3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localiz()
    }
    
    override func viewWillLayoutSubviews() {
        setupView()
        view.setupLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isAdViewed = false
        motionManager.stopMagnetometerUpdates()
    }
    
    @IBAction func detect(_ sender: Any) {
        if isAdViewed {
            setupDetector()
        } else {
            let vc = SubDetectorViewController()
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    private func setupDetector() {
        performActionWithDelay(delay: 4)
        if motionManager.isMagnetometerAvailable {
            motionManager.magnetometerUpdateInterval = 0.08
            motionManager.startMagnetometerUpdates(to: OperationQueue.main) { (magnetometerData, error) in
                if let data = magnetometerData {
                    let magneticField = data.magneticField
                    let magneticFieldY = abs(magneticField.x / 10 - 10)
                    let clampedValue = min(100, max(0, magneticFieldY))
                    
                    self.percent = Int(clampedValue)
                    self.handleReceivedValue(clampedValue)
                    self.lableText.text = "\(Int(clampedValue))%"
                }
            }
        } else {
            alert()
        }
    }
    
    private func localiz() {
        lableSubtitle.text = "detect_sub_text".localized
        lableSubtitle.adjustsFontSizeToFitWidth = true
        subtitle1.text = "detect_first_text".localized
        subtitle2.text = "detect_second_text".localized
        subtitle3.text = "detect_therd_text".localized
        btnStart.setTitle("detect_btn_start".localized, for: .normal)
        
    }
}

extension DetectionViewController {
    private func setupView() {
        btnStart.backgroundColor = R.Colors.roseBtn
        btnStart.layer.cornerRadius = 25
        lableSubtitle.greyColor()
        stackView.backgroundColor = R.Colors.whiteBlue
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.white.cgColor
        
        [box1, box2, box3].forEach { $0?.backgroundColor = R.Colors.roseBtn
            $0?.layer.cornerRadius = 8
        }
        [subtitle1, subtitle2, subtitle3].forEach {
            $0?.greyColor()
        }
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func alert() {
        let alert = UIAlertController(title: "Oops", message: "The compass is not available on this device.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    private func interpolateValue(_ value: CGFloat, from: CGFloat, to: CGFloat, minAngle: CGFloat, maxAngle: CGFloat) -> CGFloat {
        let normalizedValue = (value - from) / (to - from)
        let angleRange = maxAngle - minAngle
        return minAngle + normalizedValue * angleRange
    }
    
    private func updateImageRotation(angle: CGFloat) {
        polygon.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    private func handleReceivedValue(_ value: CGFloat) {
        let angle = interpolateValue(value, from: 0, to: 100, minAngle: 0, maxAngle: .pi)
        updateImageRotation(angle: angle)
    }
    
    private func performActionWithDelay(delay: TimeInterval) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            if self.percent < 10 {
                DispatchQueue.main.async {
                    self.makeBlurEffect()
                }
                print("Received number: \(self.percent)")
            } else {
                print("Number not received within \(delay) seconds")
            }
        }
    }
    
    private func makeBlurEffect() {
        let vc = BlurViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        motionManager.stopMagnetometerUpdates()
    }
}

extension DetectionViewController: SubDetectorViewControllerDelegate {
    func showAdd() {
        isAdViewed = true
    }
}






