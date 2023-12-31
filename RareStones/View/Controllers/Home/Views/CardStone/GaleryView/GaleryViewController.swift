//
//  GaleryViewController.swift
//  RareStones
//
//  Created by admin1 on 14.08.23.
//

import UIKit

final class GaleryViewController: UIViewController {
    
    var photos: [PhotoId] = []
    
    var imageIndex = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionImg: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        imgView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        imgView.addGestureRecognizer(swipeRight)
                
        imgView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToRoot(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
            if sender.direction == .left {
                imageIndex = (imageIndex + 1) % photos.count
            } else if sender.direction == .right {
                imageIndex = (imageIndex - 1 + photos.count) % photos.count
            }
            
        imgView.setupImgURL(url: photos[imageIndex].image)
        }
}

extension GaleryViewController {
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 22, height: 42)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        collectionImg.collectionViewLayout = layout
        collectionImg.showsHorizontalScrollIndicator = false
        collectionImg.backgroundColor = .clear
        collectionImg.dataSource = self
        collectionImg.delegate = self
        collectionImg.register(ImgCell.self, forCellWithReuseIdentifier: "\(ImgCell.self)")
        
        imgView.contentMode = .scaleAspectFill
        imgView.setupImgURL(url: photos[0].image)
        backButton.setTitle("", for: .normal)
    }
}
 
extension GaleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImgCell.self)", for: indexPath) as? ImgCell else {
            return UICollectionViewCell()}
        cell.viewImgCell.setupImgURL(url: photos[indexPath.row].image)
        return cell
    }
}

extension GaleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imgView.setupImgURL(url: photos[indexPath.row].image)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImgCell else { return }
        cell.isSelected = !cell.isSelected
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImgCell else { return }
        cell.isSelected = cell.isSelected
    }
}
