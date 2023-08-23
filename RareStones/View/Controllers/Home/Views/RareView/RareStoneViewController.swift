//
//  RareStoneViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

final class RareStoneViewController: UIViewController {
    
    @IBOutlet weak var rareColletion: UICollectionView!
    
    var dataRocks: [RockTagsResult] = []
    
    let networkStone = NetworkStoneImpl()
    
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
        
        rareColletion.dataSource = self
        rareColletion.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
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
        cell.cellView.priceStone.text = "\(dataRocks[indexPath.row].pricePerCaratTo?.remove$() ?? "0") / crt"
        cell.cellView.id =  dataRocks[indexPath.row].id
        cell.cellView.imageStone.setupImgURL(url:  dataRocks[indexPath.row].image)
        return cell
    }
}






