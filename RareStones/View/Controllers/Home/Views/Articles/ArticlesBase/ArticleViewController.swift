//
//  ArticleViewController.swift
//  RareStones
//
//  Created by admin1 on 18.08.23.
//

import UIKit

final class ArticleViewController: UIViewController {
    
    var id = ""
    let networkArticle = NetworkArticlesImpl()
    
    var parts: [PartItm] = []
    var stones:  [RelatedStone] = []
    var multiplHeight = 0
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionArticle: UICollectionView!
    @IBOutlet weak var titleMainText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrolView: UIScrollView!
    
    @IBOutlet weak var collectionStones: UICollectionView!
    @IBOutlet weak var titleArticle: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getArticleById()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setupLayer()
        self.viewHeight.constant = CGFloat(multiplHeight + 750)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension ArticleViewController {
    private func setupView() {
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 25
        
        collectionArticle.showsVerticalScrollIndicator = false
        collectionArticle.backgroundColor = .clear
        collectionArticle.dataSource = self
        collectionArticle.delegate = self
        collectionArticle.register(ArticleCellView.self, forCellWithReuseIdentifier: "\(ArticleCellView.self)")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 134, height: 157)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        collectionStones.showsHorizontalScrollIndicator = false
        collectionStones.backgroundColor = UIColor.clear
        collectionStones.collectionViewLayout = layout
        
        collectionStones.dataSource = self
        collectionStones.register(MatchCell.self, forCellWithReuseIdentifier: "MatchCell")
    }
    
    private func getArticleById() {
        networkArticle.getArticlesById(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.parts = data.parts
                    self.stones = data.relatedStones
                    self.titleMainText.text = data.title
                    self.imgView.setupImgURL(url: data.thumbnail)
                    self.titleArticle.text = data.parts[1].text
                    self.collectionArticle.reloadData()
                    self.collectionStones.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    private func calculateHeightForItem(_ item: ArticleCellView, width: CGFloat) -> CGFloat {
        let textHeigh = item.lableTextCell.frame.height
        return textHeigh
    }
}

extension ArticleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionArticle: return parts.count
        case collectionStones: return stones.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionArticle :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ArticleCellView.self)", for: indexPath) as? ArticleCellView else { return UICollectionViewCell() }
            cell.txtView.text = parts[indexPath.row].text
            cell.lableTextCell.text = parts[indexPath.row].title
            cell.configure(with: parts[indexPath.row].title,
                           hasImage: parts[indexPath.row].image == nil ? false : true)
            cell.imgView.setupImgURL(url: parts[indexPath.row].image ?? "")
            return cell
        case collectionStones :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MatchCell.self)", for: indexPath) as? MatchCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.imgView.setupImgURL(url: stones[indexPath.row].image ?? "")
            cell.titleTxt.text = stones[indexPath.row].name
            cell.id = stones[indexPath.row].id
            cell.priceTxt.text = ""
            return cell
        default: return UICollectionViewCell()
        }
        
    }
}

extension ArticleViewController: MatchCellDelegate {
    func showCart(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = parts[indexPath.item].text
        let width = collectionView.frame.width
        let boundingSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textHeight = text.boundingRect(with: boundingSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil).height
        if parts[indexPath.row].image != nil {
            multiplHeight += Int(textHeight + 200)
            return CGSize(width: width, height: textHeight + 210)
        }
        
        if parts[indexPath.row].title == nil {
            multiplHeight += Int(textHeight + 0)
            return CGSize(width: width, height: textHeight)
        } else {
            multiplHeight += Int(textHeight + 20)
            return CGSize(width: width, height: textHeight + 20)
        }
    }
}
