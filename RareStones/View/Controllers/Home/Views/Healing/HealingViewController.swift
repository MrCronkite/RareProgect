//
//  HealingViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

final class HealingViewController: UIViewController {
     
    @IBOutlet weak var collectionViewHealing: UICollectionView!
    
    var dataRocks: [RockTagsResult] = []
    let networkStone = NetworkStoneImpl()
    
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
        
        collectionViewHealing.dataSource = self
        collectionViewHealing.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
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
        cell.cellView.priceStone.text = "\(dataRocks[indexPath.row].pricePerCaratTo?.remove$() ?? "0") / crt"
        cell.cellView.id =  dataRocks[indexPath.row].id
        cell.cellView.imageStone.setupImgURL(url:  dataRocks[indexPath.row].image)
        return cell
    }
}

