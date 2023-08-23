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
    
    @IBOutlet weak var boxImgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var percentBox: UIView!
    @IBOutlet weak var percentTxt: UILabel!
    @IBOutlet weak var collectionOther: UICollectionView!
    
    @IBOutlet weak var containerStoneView: UIView!
    @IBOutlet weak var imageStoneView: UIImageView!
    @IBOutlet weak var lableStone: UILabel!
    @IBOutlet weak var priceStone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        setupView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(togle(_ :)))
        containerStoneView.addGestureRecognizer(tap)
        containerStoneView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
        print(containerStoneView.frame.height)
    }
    
    @IBAction func goToBack(_ sender: Any) {
        showRating()
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
        containerStoneView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerStoneView.layer.shadowOpacity = 0.3
        containerStoneView.layer.shadowRadius = 4
    }
    
    private func setupViewData() {
        guard let data = matchStones else { return }
        imgView.setupImgURL(url: data.image)
        imageStoneView.setupImgURL(url: data.results[0].stone.image)
        lableStone.text = data.results[0].stone.name
        priceStone.text = "\(data.results[0].stone.pricePerCaratTo?.remove$() ?? "$0") / crt"
        otherStones = data.results
        collectionOther.reloadData()
    }
    
    private func showRating() {
        alertController = UIAlertController(title: "Rate the App", message: "Please rate our app", preferredStyle: .alert)
        
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
        
        let constraints = [
            starStackView.centerXAnchor.constraint(equalTo: alertController!.view.centerXAnchor),
            starStackView.topAnchor.constraint(equalTo: alertController!.view.topAnchor, constant: 50),
            starStackView.bottomAnchor.constraint(equalTo: (alertController!.view.bottomAnchor), constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
        
        present(alertController!, animated: true, completion: nil)
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
        cell.priceTxt.text = "$\(otherStones[indexPath.row].stone.pricePerCaratFrom?.remove$() ?? "0") - $\(otherStones[indexPath.row].stone.pricePerCaratTo?.remove$() ?? "0") crt"
        cell.id = otherStones[indexPath.row].stone.id
        cell.delegate = self
        return cell
    }
}
