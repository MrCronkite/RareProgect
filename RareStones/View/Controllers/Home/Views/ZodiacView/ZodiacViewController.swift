//
//  ZodiacViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit

final class ZodiacViewController: UIViewController {
    
    var zodiacCategory: [Results] = []
    var zodiacStones: [StoneElement] = []
    
    let networkService = NetworkServicesZodiacImpl()
    
    @IBOutlet weak var heightBoxView: NSLayoutConstraint!
    
    @IBOutlet weak var dataBirdtext: UILabel!
    @IBOutlet weak var elementTxt: UILabel!
    
    @IBOutlet weak var boxZodiac: UIView!
    @IBOutlet weak var imageZodiac: UIImageView!
    @IBOutlet weak var dataBirthText: UILabel!
    @IBOutlet weak var elementText: UILabel!
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var zodiacCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getZodiac()
        getZodiacForId(id: "1")
    }
    
    override func viewWillLayoutSubviews() {
        setupView()
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getZodiac() {
        networkService.getZodiacData() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.zodiacCategory = data.results
                    self.zodiacCollection.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    func getZodiacForId(id: String) {
        networkService.getZodiacInId(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.dataBirthText.text = data.dateRange
                    self.elementText.text = data.element
                    self.imageZodiac.setupImgURL(url: data.image)
                    self.zodiacStones = data.stones
                    self.boxZodiac.isHidden = false
                    self.articleCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ZodiacViewController {
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 88, height: 32)
        layout.scrollDirection = .horizontal
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.itemSize = .init(width: 363, height: 300)
        layout1.scrollDirection = .vertical
        
        zodiacCollection.collectionViewLayout = layout
        zodiacCollection.showsHorizontalScrollIndicator = false
        zodiacCollection.backgroundColor = .clear
        zodiacCollection.dataSource = self
        zodiacCollection.delegate = self
        zodiacCollection.register(ZodiacCollectionCell.self, forCellWithReuseIdentifier: "\(ZodiacCollectionCell.self)")
        
        articleCollectionView.collectionViewLayout = layout1
        articleCollectionView.showsVerticalScrollIndicator = false
        articleCollectionView.backgroundColor = .clear
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.register(ArticleCollectionCell.self, forCellWithReuseIdentifier: "\(ArticleCollectionCell.self)")
        
        elementTxt.greyColor()
        dataBirdtext.greyColor()
        boxZodiac.backgroundColor = R.Colors.blueLight
        boxZodiac.layer.cornerRadius = 20
        boxZodiac.layer.borderWidth = 1
        boxZodiac.layer.borderColor = UIColor.white.cgColor
        imageZodiac.contentMode = .scaleAspectFill
    }
}

extension ZodiacViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case zodiacCollection: return zodiacCategory.count
        case articleCollectionView: return zodiacStones.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case zodiacCollection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ZodiacCollectionCell.self)", for: indexPath) as? ZodiacCollectionCell
            else { return UICollectionViewCell() }
            cell.lableTextCell.text = zodiacCategory[indexPath.row].name
            return cell
        case articleCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ArticleCollectionCell.self)", for: indexPath) as? ArticleCollectionCell
            else { return UICollectionViewCell() }
            cell.cartArticle.delegate = self
            cell.cartArticle.id = zodiacStones[indexPath.row].stone.id
            cell.cartArticle.nameStone.text = zodiacStones[indexPath.row].stone.name
            cell.cartArticle.imgView.setupImgURL(url: zodiacStones[indexPath.row].stone.image)
            cell.cartArticle.textLable.text = zodiacStones[indexPath.row].description
            return cell
        default: return UICollectionViewCell()
        }
    }
}

extension ZodiacViewController: CartArticleDelegate {
    func sendDataStone(idStone: Int) {
        let vc = CartStoneViewController()
        vc.id = idStone
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension ZodiacViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ZodiacCollectionCell else { return }
        cell.isSelected = !cell.isSelected
        getZodiacForId(id: String(indexPath.row + 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ZodiacCollectionCell else { return }
        cell.isSelected = cell.isSelected
    }
}
