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
    
    @IBOutlet weak var boxImgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var percentBox: UIView!
    @IBOutlet weak var cartStone: CartStone!
    @IBOutlet weak var percentTxt: UILabel!
    @IBOutlet weak var collectionOther: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        setupView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(togle(_ :)))
        cartStone.addGestureRecognizer(tap)
        cartStone.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
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
    }
    
    private func setupViewData() {
        guard let data = matchStones else { return }
        imgView.setupImgURL(url: data.image)
        cartStone.imageStone.setupImgURL(url: data.results[0].stone.image)
        cartStone.btnHeart.isHidden = true
        cartStone.titleStone.text = data.results[0].stone.name
        cartStone.priceStone.text = "\(data.results[0].stone.pricePerCaratTo ?? "$0") / crt"
        otherStones = data.results
        collectionOther.reloadData()
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
