//
//  MathcViewController.swift
//  RareStones
//
//  Created by admin1 on 15.08.23.
//

import UIKit

final class MatchViewController: UIViewController {
    
    var matchStones: StonePhoto? = nil
    var otherStones: [StoneClassificationResultModel] = []
    var alertController: UIAlertController?
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var boxImgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var percentBox: UIView!
    @IBOutlet weak var percentTxt: UILabel!
    @IBOutlet weak var collectionOther: UICollectionView!
    
    @IBOutlet weak var otherLable: UILabel!
    @IBOutlet weak var upToText: UILabel!
    @IBOutlet weak var matchText: UILabel!
    @IBOutlet weak var containerStoneView: UIView!
    @IBOutlet weak var imageStoneView: UIImageView!
    @IBOutlet weak var lableStone: UILabel!
    @IBOutlet weak var priceStone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        setupView()
        localize()
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(togle(_ :)))
        containerStoneView.addGestureRecognizer(tap)
        containerStoneView.isUserInteractionEnabled = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                self.showRating()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupPulsingAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func togle(_ sender: UITapGestureRecognizer) {
        let vc = CartStoneViewController()
        vc.id = matchStones?.results[0].stone.id ?? 0
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func starButtonTapped(_ sender: UIButton) {
//        if let appURL = URL(string: "itms-apps://itunes.apple.com/app/ВАШ_ID_ПРИЛОЖЕНИЯ?mt=8&action=write-review") {
//                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
//                }

        dismiss(animated: true)
    }
}

extension MatchViewController{
    func setupView() {
        boxImgView.layer.cornerRadius = 20
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 14
        percentBox.layer.cornerRadius = 43
        percentTxt.text = "\(Int.random(in: 86...98))%"
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 134, height: 157)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        collectionOther.showsHorizontalScrollIndicator = false
        collectionOther.backgroundColor = UIColor.clear
        collectionOther.collectionViewLayout = layout
        
        collectionOther.dataSource = self
        collectionOther.register(MatchCell.self, forCellWithReuseIdentifier: "MatchCell")
        
        imageStoneView.clipsToBounds = true
        imageStoneView.layer.cornerRadius = 12
        imageStoneView.contentMode = .scaleAspectFill
        containerStoneView.layer.cornerRadius = 16
    
        containerStoneView.layer.shadowColor = UIColor.black.cgColor
        containerStoneView.layer.shadowOffset = CGSize(width: 0, height: 7)
        containerStoneView.layer.shadowOpacity = 0.3
        containerStoneView.layer.shadowRadius = 5
    }
    
    private func setupViewData() {
        guard let data = matchStones else { return }
        DispatchQueue.main.async {
            self.imgView.setupImgURL(url: data.image)
            self.imageStoneView.setupImgURL(url: data.results[0].stone.image)
            self.lableStone.text = data.results[0].stone.name
            self.priceStone.text = "\(data.results[0].stone.pricePerCaratTo?.remove$() ?? "$0") / ct"
            self.otherStones = data.results
            self.collectionOther.reloadData()
        }
        
    }
    
    private func localize() {
        closeButton.setTitle("", for: .normal)
        titleLable.text = "cam_title_match".localized
        subtitle.text = "cam_subtitle_match".localized
        matchText.text = "cam_match".localized
        matchText.adjustsFontSizeToFitWidth = true
        otherLable.text = "cam_other_match".localized
        upToText.text = "h_up_to".localized
    }
    
    private func showRating() {
        alertController = UIAlertController(title: "cam_alert_title".localized, message: "cam_alert_subtitle".localized, preferredStyle: .alert)
        
        let starStackView = UIStackView()
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        starStackView.axis = .horizontal
        starStackView.alignment = .center
        starStackView.spacing = 10
        
        for _ in 1...5 {
            let starButton = UIButton(type: .custom)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            starButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            starButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            starStackView.addArrangedSubview(starButton)
        }
        
        alertController?.view.addSubview(starStackView)
        
        let cancelAction = UIAlertAction(title: "cam_lable_mathc".localized, style: .cancel, handler: nil)
            alertController?.addAction(cancelAction)
        
        let constraints = [
            starStackView.centerXAnchor.constraint(equalTo: alertController!.view.centerXAnchor),
            starStackView.topAnchor.constraint(equalTo: alertController!.view.topAnchor, constant: 20),
            starStackView.bottomAnchor.constraint(equalTo: (alertController!.view.bottomAnchor), constant: -20),
            starStackView.heightAnchor.constraint(equalToConstant: 130)
        ]
        NSLayoutConstraint.activate(constraints)
        
        present(alertController!, animated: true, completion: nil)
    }
    
    private func setupPulsingAnimation() {
        let pulseLayer = CALayer()
        pulseLayer.frame = containerStoneView.bounds
        pulseLayer.cornerRadius = 16
        pulseLayer.backgroundColor = UIColor.clear.cgColor
        pulseLayer.borderWidth = 12
        pulseLayer.borderColor = UIColor.white.cgColor
        pulseLayer.zPosition = -1
        containerStoneView.layer.insertSublayer(pulseLayer, below: containerStoneView.layer)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.8
        animation.fromValue = 0.9
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulseLayer.add(animation, forKey: "pulsing")
    }
}

extension MatchViewController: MatchCellDelegate {
    func showCart(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension MatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        otherStones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath) as? MatchCell else {
            return UICollectionViewCell()
        }
        
        cell.titleTxt.text = otherStones[indexPath.row].stone.name
        cell.imgView.setupImgURL(url: otherStones[indexPath.row].stone.image)
        cell.priceTxt.text = "$\(otherStones[indexPath.row].stone.pricePerCaratFrom?.remove$() ?? "0") - $\(otherStones[indexPath.row].stone.pricePerCaratTo?.remove$() ?? "0") ct"
        cell.id = otherStones[indexPath.row].stone.id
        cell.delegate = self
        return cell
    }
}
