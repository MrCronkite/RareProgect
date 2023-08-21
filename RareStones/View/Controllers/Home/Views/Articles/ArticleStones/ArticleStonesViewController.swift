//
//  ArticleStonesViewController.swift
//  RareStones
//
//  Created by admin1 on 19.08.23.
//

import UIKit

final class ArticleStonesViewController: UIViewController {
    
    var id = "9"
    var partsCell: [PartItm] = []
    var partsText: [PartItm] = []
    let networkArticle = NetworkArticlesImpl()
    var expandedIndexPaths: Set<IndexPath> = []
    var height = 0
    
    @IBOutlet weak var collectionArticles: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var secondTitleText: UILabel!
    
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var boxTxt: UIView!
    @IBOutlet weak var imgStone: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getArticleById()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func closeVc(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func getArticleById() {
        networkArticle.getArticlesById(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    self.titleText.text = data.title
                    self.imgStone.setupImgURL(url: data.relatedStones[0].image ?? "")
                    data.parts.forEach {
                        if $0.title == nil {
                            self.partsText.append($0)
                        } else { self.partsCell.append($0) }
                    }
                    
                    if self.partsText.count > 1 {
                        self.secondTitleText.text = self.partsText[1].text
                    } else {
                        self.articleText.text = self.partsText[0].text
                    }
                    self.collectionHeight.constant = CGFloat(140 * self.partsCell.count)
                    self.height = Int(self.collectionHeight.constant)
                    self.collectionArticles.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ArticleStonesViewController {
    private func setupView() {
        separator.layer.cornerRadius = 4
        imgStone.layer.cornerRadius = 25
        imgStone.contentMode = .scaleAspectFill
        imgStone.clipsToBounds = true
        boxTxt.layer.cornerRadius = 15
        collectionHeight.isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: Int(collectionArticles.frame.width) - 34, height: 126)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        
        collectionArticles.layer.cornerRadius = 25
        collectionArticles.layer.borderWidth = 1
        collectionArticles.layer.borderColor = UIColor.white.cgColor
        collectionArticles.collectionViewLayout = layout
        collectionArticles.delegate = self
        collectionArticles.dataSource = self
        collectionArticles.register(TipsStoneCell.self, forCellWithReuseIdentifier: "TipsStoneCell")
    }
}

extension ArticleStonesViewController: TipsStoneCellDelegate {
    func buttonTapped(in cell: TipsStoneCell) {
        if let indexPath = collectionArticles.indexPath(for: cell) {
            if let indexPath = collectionArticles.indexPath(for: cell) {
                if expandedIndexPaths.contains(indexPath) {
                    expandedIndexPaths.remove(indexPath)
                } else {
                    expandedIndexPaths.insert(indexPath)
                }
                collectionArticles.reloadItems(at: [indexPath])
            }
            
            let totalExpandedCellHeight = expandedIndexPaths.reduce(0) { (result, indexPath) -> CGFloat in
                return result + (indexPath.row == indexPath.row ? 80 : 0)
                        }
            collectionHeight.constant = CGFloat(height)
            collectionHeight.constant += totalExpandedCellHeight
                        
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ArticleStonesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if expandedIndexPaths.contains(indexPath) {
            return CGSize(width: collectionView.frame.width - 34 , height: 206)
        } else {
            return CGSize(width: collectionView.frame.width - 34, height: 126)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        partsCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsStoneCell", for: indexPath) as? TipsStoneCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.indexCell = indexPath.row
        cell.text.text = partsCell[indexPath.row].text
        cell.titleCell.text = partsCell[indexPath.row].title
        
        cell.isExpanded = expandedIndexPaths.contains(indexPath)
        return cell
    }
}

