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
    
    var isAccess = false
    
    var cameraImg = UIImage()
    
    let networkClass = NetworkClassificationImpl()
    
    var data: StonePhoto? = nil
    
    @IBOutlet weak var indetifactionTxt: UILabel!
    var texts = ["Looking for a match", "Preparing a description", "Determine the cost per carat"]
    var currentPercentage = 0
    var currentIndex = 0
    let regiserUser = RegistredUser()
    let network = NetworkServicesZodiacImpl()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    deinit {
        print("eitdfssd")
    }
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var flashBtn: UIImageView!
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var imageBtn: UIImageView!
    
    @IBOutlet weak var flashView: UIView!
    @IBOutlet weak var imgView: UIView!
    
    @IBOutlet weak var openSettingsBtn: UIButton!
    @IBOutlet weak var separator: UIImageView!
    @IBOutlet weak var subtextSeparator: UIView!
    @IBOutlet weak var text: UIImageView!
    
    @IBOutlet weak var boxShadowView: UIView!
    @IBOutlet weak var lookingText: UILabel!
    @IBOutlet weak var percentText: UILabel!
    
    @IBOutlet weak var presentPhotoView: UIImageView!
    let photoTipsVC = PhotoTipsViewController()
    
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        cameraView.setupLayer()
        overlayView.frame = presentPhotoView.frame
        presentPhotoView.addSubview(overlayView)
        if !captureSession.isRunning {
            setupCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    @IBAction func camShot(_ sender: Any) {
        if isAccess {
            let capturePhotoOutput = AVCapturePhotoOutput()
            captureSession.addOutput(capturePhotoOutput)
            
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            capturePhotoOutput.capturePhoto(with: settings, delegate: self)
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
    
    @IBAction func showPhotoTips(_ sender: Any) {
        let vc = PhotoTipsViewController()
        present(vc, animated: true)
    }
    
    @objc func toggleFlash(_ sender: UITapGestureRecognizer) {
        if isAccess {
            if let captureDevice = AVCaptureDevice.default(for: .video) {
                do {
                    try captureDevice.lockForConfiguration()
                    
                    if captureDevice.hasTorch {
                        if captureDevice.isTorchActive {
                            captureDevice.torchMode = .off
                            flashBtn.image = UIImage(named: "cam3")
                        } else {
                            try captureDevice.setTorchModeOn(level: 1.0)
                            flashBtn.image = UIImage(named: "camOff")
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
        if isAccess {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension CameraViewController {
    private func setupView() {
        [imgView, flashView].forEach {
            $0?.layer.cornerRadius = 25
            $0?.backgroundColor = R.Colors.purple
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFlash(_:)))
        flashView.addGestureRecognizer(tap)
        flashView.isUserInteractionEnabled = true
        
        let tapImg = UITapGestureRecognizer(target: self, action: #selector(toggleGaller(_:)))
        imgView.addGestureRecognizer(tapImg)
        imgView.isUserInteractionEnabled = true
        
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
            if captureSession.isRunning == false {
                captureSession.removeInput(input)
            }
            captureSession.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = cameraView.frame
            videoPreviewLayer?.zPosition = -1
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            isAccess = true
            openSettingsBtn.isHidden = true
            separator.isHidden = false
            subtextSeparator.isHidden = true
            text.isHidden = true
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraOutputQueue"))
            captureSession.addOutput(output)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateLabel() {
        setupAnimation()
        lookingText.text = texts[currentIndex]
        currentIndex = (currentIndex + 1) % texts.count
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
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        networkClass.sendImageData(image: imageData) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.data = data
                    }
                case .failure(let error):
                    print(error)
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
}

extension CameraViewController: SubscribeCameraViewControllerDelegate {
    func showMatchesStone(_ isAdView: Bool) {
        let vc = NotFoundViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.image = cameraImg
        
        if isAdView {
            if data != nil {
                let vc = MatchViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.matchStones = data
                present(vc, animated: true)
            } else {
                present(vc, animated: true)
            }
        }
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
            sendPhoto(image: capturedImage)
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
            sendPhoto(image: selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
}
