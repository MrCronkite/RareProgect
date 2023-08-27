//
//  CameraViewController.swift
//  RareStones
//
//  Created by admin1 on 8.08.23.
//

import UIKit
import AVFoundation
import Lottie

final class CameraViewController: UIViewController {
    
    var isAccessCamera = false
    var isAdViewed = false
    var isFlash = false
    
    var cameraImg = UIImage()
    var currentPercentage = 0
    var currentIndex = 0
    let networkClass = NetworkClassificationImpl()
    var data: StonePhoto? = nil
    let photoTipsVC = PhotoTipsViewController()
    let capturePhotoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var tapImg: UITapGestureRecognizer?
    
    
    @IBOutlet weak var keepLabel: UILabel!
    @IBOutlet weak var containerText: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleCamera: UILabel!
    @IBOutlet weak var tipsLable: UILabel!
    @IBOutlet weak var buttonShot: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var indetifactionTxt: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var flashBtn: UIImageView!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var imageBtn: UIImageView!
    @IBOutlet weak var flashView: UIView!
    @IBOutlet weak var imgView: UIView!
    @IBOutlet weak var openSettingsBtn: UIButton!
    @IBOutlet weak var separator: UIImageView!
    @IBOutlet weak var boxShadowView: UIView!
    @IBOutlet weak var lookingText: UILabel!
    @IBOutlet weak var percentText: UILabel!
    @IBOutlet weak var presentPhotoView: UIImageView!
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        cameraView.setupLayer()
        videoPreviewLayer?.frame = cameraView.frame
        overlayView.frame = presentPhotoView.frame
        presentPhotoView.addSubview(overlayView)
        mainBtn.isEnabled = true
        tapImg?.isEnabled = true
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func camShot(_ sender: Any) {
        if isAccessCamera {
            mainBtn.isEnabled = false
            tapImg?.isEnabled = false
            DispatchQueue.main.async {
                let settings = AVCapturePhotoSettings()
                if self.isFlash {
                    settings.flashMode = .on
                } else { settings.flashMode = .off }
                self.captureSession.addOutput(self.capturePhotoOutput)
                self.capturePhotoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }
    
    @IBAction func openSettings(_ sender: Any) {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        if captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.stopRunning()
            }
        }
        dismiss(animated: true)
    }
    
    @objc func showTips(_ sender: Any) {
        let vc = PhotoTipsViewController()
        present(vc, animated: true)
    }
}

extension CameraViewController {
    private func setupView() {
        [imgView, flashView].forEach {
            $0?.layer.cornerRadius = 25
            $0?.backgroundColor = R.Colors.purple
        }
        
        let tapFlash = UITapGestureRecognizer(target: self, action: #selector(toggleFlash(_:)))
        flashView.addGestureRecognizer(tapFlash)
        flashView.isUserInteractionEnabled = true
        
        tapImg = UITapGestureRecognizer(target: self, action: #selector(toggleGaller(_:)))
        imgView.addGestureRecognizer(tapImg!)
        imgView.isUserInteractionEnabled = true
        
        let tipsTap = UITapGestureRecognizer(target: self, action: #selector(showTips))
        tipsLable.isUserInteractionEnabled = true
        tipsLable.addGestureRecognizer(tipsTap)
        
        boxShadowView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        boxShadowView.layer.cornerRadius = 13
        boxShadowView.isHidden = false
        lookingText.isHidden = true
        percentText.isHidden = true
        lookingText.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        lookingText.layer.cornerRadius = 13
        lookingText.clipsToBounds = true
        overlayView.isHidden = true
        animateView.isHidden = true
        indetifactionTxt.isHidden = true
    }
    
    private func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.zPosition = -1
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            isAccessCamera = true
            openSettingsBtn.isHidden = true
            separator.isHidden = false
            containerText.isHidden = true
            boxShadowView.isHidden = false
        } catch {
            boxShadowView.isHidden = true
            separator.isHidden = true
            openSettingsBtn.isHidden = false
            containerText.isHidden = false
        }
    }
    
    private func updateLabel() {
        setupAnimation()
        lookingText.text = R.Strings.Camera.loadingText[currentIndex]
        currentIndex = (currentIndex + 1) % R.Strings.Camera.loadingText.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
            self.updateLabel()
        }
    }
    
    private func setupAnimation() {
        let animationView = LottieAnimationView(name: "diamond")
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animateView.center = animationView.center
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animateView.backgroundColor = .clear
        animationView.backgroundColor = .clear
        animateView.addSubview(animationView)
        animationView.play()
    }
    
    private func updatePercent() {
        percentText.isHidden = false
        percentText.text = "\(currentPercentage)%"
        if currentPercentage < 100 {
            currentPercentage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                self.updatePercent()
            }
        } else {
            currentPercentage = 0
            presentPhotoView.image = UIImage()
            lookingText.isHidden = true
            percentText.isHidden = true
            separator.isHidden = false
            boxShadowView.isHidden = false
            animateView.isHidden = true
            overlayView.isHidden = true
            indetifactionTxt.isHidden = true
            showViewAdd()
        }
    }
    
    private func sendPhoto(image: UIImage) {
        let resizedImage = image.resized(to: CGSize(width: 200, height: 280))
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.5) else { return }
        networkClass.sendImageData(image: imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.data = data
                    self.showViewMatchesStone()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.showViewMatchesStone()
                }
            }
        }
    }
    
    private func showViewAdd() {
        let vcSub = SubscribeCameraViewController()
        vcSub.image = cameraImg
        vcSub.delegate = self
        present(vcSub, animated: true)
    }
    
    private func showViewMatchesStone() {
        let vc = NotFoundViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.image = cameraImg
        if data != nil {
            let vc = MatchViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.matchStones = data
            present(vc, animated: true)
        } else {
            present(vc, animated: true)
        }
    }
    
    private func localize() {
        buttonShot.setTitle("", for: .normal)
        buttonClose.setTitle("", for: .normal)
        indetifactionTxt.text = "cam_identification".localized
        titleCamera.text = "cam_settings_title".localized
        subtitle.text = "cam_settings_subtitle".localized
        subtitle.adjustsFontSizeToFitWidth = true
        openSettingsBtn.setTitle("cam_settings_button".localized, for: .normal)
        keepLabel.text = "cam_keep_text".localized
        keepLabel.adjustsFontSizeToFitWidth = true
        tipsLable.text = "cam_photo_tips".localized
        tipsLable.adjustsFontSizeToFitWidth = true
    }
    
    @objc func toggleFlash(_ sender: UITapGestureRecognizer) {
        if isAccessCamera {
            if let captureDevice = AVCaptureDevice.default(for: .video) {
                do {
                    try captureDevice.lockForConfiguration()
                    if captureDevice.hasTorch {
                        if captureDevice.isTorchActive {
                            captureDevice.torchMode = .off
                            flashBtn.image = UIImage(named: "cam3")
                            isFlash = false
                        } else {
                            try captureDevice.setTorchModeOn(level: 1.0)
                            flashBtn.image = UIImage(named: "camOff")
                            isFlash = true
                        }
                    }
                    captureDevice.unlockForConfiguration()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func toggleGaller(_ sender: UITapGestureRecognizer) {
        if isAccessCamera {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension CameraViewController: SubscribeCameraViewControllerDelegate {
    func showMatchesStone() {
        sendPhoto(image: cameraImg)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
            presentPhotoView.image = capturedImage
            presentPhotoView.contentMode = .scaleAspectFill
            boxShadowView.isHidden = true
            separator.isHidden = true
            lookingText.isHidden = false
            overlayView.isHidden = false
            animateView.isHidden = false
            indetifactionTxt.isHidden = false
            updateLabel()
            updatePercent()
            cameraImg = capturedImage
        }
        captureSession.removeOutput(output)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cameraImg = selectedImage
            presentPhotoView.image = selectedImage
            presentPhotoView.contentMode = .scaleAspectFill
            boxShadowView.isHidden = true
            separator.isHidden = true
            lookingText.isHidden = false
            overlayView.isHidden = false
            animateView.isHidden = false
            indetifactionTxt.isHidden = false
            updateLabel()
            updatePercent()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
