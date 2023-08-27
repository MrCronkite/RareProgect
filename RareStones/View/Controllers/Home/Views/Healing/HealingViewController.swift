//
//  HealingViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

final class HealingViewController: UIViewController {
    
    var dataRocks: [RockTagsResult] = []
    let networkStone = NetworkStoneImpl()
    let buttonView = ButtonView()
     
    @IBOutlet weak var collectionViewHealing: UICollectionView!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var titleHealing: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getHealingStone()
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension HealingViewController {
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 166, height: 205)
        layout.scrollDirection = .vertical
        collectionViewHealing.showsVerticalScrollIndicator = false
        collectionViewHealing.backgroundColor = UIColor.clear
        collectionViewHealing.collectionViewLayout = layout
        collectionViewHealing.contentInset = .init(top: 0, left: 0, bottom: 90, right: 0)
        collectionViewHealing.dataSource = self
        collectionViewHealing.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        backButton.setTitle("", for: .normal)
        titleHealing.text = "h_title_healing".localized
        
        buttonContainer.layer.cornerRadius = 25
        buttonContainer.backgroundColor = .clear
        buttonView.delegate = self
        buttonContainer.frame = buttonView.frame
        buttonView.setupAnimation()
        buttonContainer.addSubview(buttonView)
        buttonContainer.layer.shadowColor = UIColor.black.cgColor
        buttonContainer.layer.shadowOpacity = 0.2
        buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        buttonContainer.layer.shadowRadius = 10
    }
    
    private func getHealingStone() {
        networkStone.getStonesByTag(tag: "2") { result in
            switch result {
            case.success(let data): 
                DispatchQueue.main.async {
                    self.dataRocks = data.results
                    self.collectionViewHealing.reloadData()
                }
                
            case.failure(let error): print(error)
            }
        }
    }
}

extension HealingViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension HealingViewController: CartStoneDelegate {
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

extension HealingViewController: UICollectionViewDataSource {
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

