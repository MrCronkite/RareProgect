//
//  RareStoneViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

final class RareStoneViewController: UIViewController {
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rareColletion: UICollectionView!
    @IBOutlet weak var titleRare: UILabel!
    var dataRocks: [RockTagsResult] = []
    
    let networkStone = NetworkStoneImpl()
    let buttonViewAnimate = ButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getRareStone()
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension RareStoneViewController {
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 166, height: 205)
        layout.scrollDirection = .vertical
        rareColletion.showsVerticalScrollIndicator = false
        rareColletion.backgroundColor = UIColor.clear
        rareColletion.collectionViewLayout = layout
        rareColletion.contentInset = .init(top: 0, left: 0, bottom: 90, right: 0)
        rareColletion.dataSource = self
        rareColletion.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        backButton.setTitle("", for: .normal)
        titleRare.text = "h_title_rare".localized
        
        buttonContainer.layer.cornerRadius = 25
        buttonContainer.backgroundColor = .clear
        buttonViewAnimate.delegate = self
        buttonContainer.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        buttonContainer.addSubview(buttonViewAnimate)
        buttonContainer.layer.shadowColor = UIColor.black.cgColor
        buttonContainer.layer.shadowOpacity = 0.2
        buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        buttonContainer.layer.shadowRadius = 10
    }
    
    private func getRareStone() {
        networkStone.getStonesByTag(tag: "1") { result in
            switch result {
            case.success(let data): 
                DispatchQueue.main.async {
                    self.dataRocks = data.results
                    self.rareColletion.reloadData()
                }
                
            case.failure(let error): print(error)
            }
        }
    }
}

extension RareStoneViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension RareStoneViewController: CartStoneDelegate {
    func deleteFromCollection() {
        print("")
    }
    
    func openStone(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension RareStoneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataRocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCollectionViewCell", for: indexPath) as! StoneCollectionViewCell
        cell.cellView.delegate = self
        cell.cellView.titleStone.text = dataRocks[indexPath.row].name
        cell.cellView.priceStone.text = "\(dataRocks[indexPath.row].pricePerCaratTo?.remove$() ?? "0") / ct"
        cell.cellView.id =  dataRocks[indexPath.row].id
        cell.cellView.imageStone.setupImgURL(url:  dataRocks[indexPath.row].image)
        return cell
    }
}






