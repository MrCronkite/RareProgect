//
//  CartStoneViewController.swift
//  RareStones
//
//  Created by admin1 on 14.08.23.
//

import UIKit

final class CartStoneViewController: UIViewController {
    
    var dataRock: RockID? = nil
    var titleDiscription: [String] = []
    var heightCell: [CGFloat] = []
    var article: [Other?] = []
    
    var id = 0
    let networkStone = NetworkStoneImpl()
    var expandedIndexPaths: Set<IndexPath> = []

    var isButtonSelected = false
    
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var collectionDescription: UICollectionView!
    @IBOutlet weak var boxImg: UIView!
    @IBOutlet weak var stoneImgView: UIImageView!
    @IBOutlet weak var borderImg: UIView!
    @IBOutlet weak var nameStone: UILabel!
    @IBOutlet weak var costStone: UILabel!
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var collectionImgStone: UICollectionView!
    
    @IBOutlet weak var hardnesTxt: UILabel!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var formulaTxt: UILabel!
    @IBOutlet weak var colorTxt: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var healingTeg: UILabel!
    @IBOutlet weak var rareTeg: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataStone()
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
        setupView()
    }
    
    @IBAction func goToRoot(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func openGallery(_ sender: Any) {
        let vc = GaleryViewController()
        vc.photos = dataRock?.photos ?? []
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func saveStone(_ sender: UIButton) {
        isButtonSelected.toggle()
        
        if isButtonSelected {
            sender.setImage(UIImage(named: "fillheart"), for: .normal)
            if id != 0 {
                networkStone.makePostRequestWashList(id: id)
            }
        } else {
            sender.setImage(UIImage(named: "heart"), for: .normal)
            networkStone.deleteStoneFromWishlist(stoneID: id)
        }
    }
}

extension CartStoneViewController {
    private func setupView() {
        boxImg.layer.cornerRadius = 30
        boxImg.clipsToBounds = true
        stoneImgView.contentMode = .scaleAspectFill
        borderImg.backgroundColor = UIColor(hexString: "#708FE8").withAlphaComponent(0.7)
        btnHeart.layer.cornerRadius = 16
        colorTxt.adjustsFontSizeToFitWidth = true
        formulaTxt.adjustsFontSizeToFitWidth = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 78, height: 78)
        layout.scrollDirection = .horizontal
        
        collectionImgStone.collectionViewLayout = layout
        collectionImgStone.showsHorizontalScrollIndicator = false
        collectionImgStone.backgroundColor = .clear
        collectionImgStone.dataSource = self
        collectionImgStone.register(StoneImgCell.self, forCellWithReuseIdentifier: "\(StoneImgCell.self)")
        
        btnSeeAll.layer.cornerRadius = 20
        btnSeeAll.backgroundColor = UIColor(hexString: "#708FE8").withAlphaComponent(0.7)
        otherView.layer.cornerRadius = 25
        otherView.layer.borderWidth = 1
        otherView.layer.borderColor = UIColor.white.cgColor
        healingTeg.layer.cornerRadius = 15
        healingTeg.clipsToBounds = true
        rareTeg.clipsToBounds = true
        rareTeg.layer.cornerRadius = 15
        
        let secondLayout = UICollectionViewFlowLayout()
        secondLayout.itemSize = .init(width: Int(collectionDescription.frame.width), height: 206)
        secondLayout.scrollDirection = .vertical
        secondLayout.minimumLineSpacing = 12
        
        collectionDescription.backgroundColor = .clear
        collectionDescription.collectionViewLayout = secondLayout
        collectionDescription.dataSource = self
        collectionDescription.delegate = self
        collectionDescription.register(TipsStoneCell.self, forCellWithReuseIdentifier: "TipsStoneCell")
        
        articleTableView.backgroundColor = .clear
        articleTableView.showsVerticalScrollIndicator = false
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.rowHeight = UITableView.noIntrinsicMetric
        articleTableView.separatorStyle = .none
        articleTableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
    }
    
    private func calculateCollectionHeight() {
        var collectionHeight = 0
        if heightCell.count >= 2 {
            collectionHeight += Int(heightCell[1] + heightCell[0]) + 32
        } else if heightCell.count < 2 {
            collectionHeight += Int(heightCell[0]) + 32
        }
        self.collectionHeight.constant = CGFloat(collectionHeight)
        self.collectionDescription.reloadData()
    }
    
    private func setupDataView() {
        guard let rock = dataRock else { return }
        nameStone.text = rock.name
        stoneImgView.setupImgURL(url: rock.image)
        costStone.text = "$\(rock.pricePerCaratFrom?.remove$() ?? "0") - $\(rock.pricePerCaratTo?.remove$() ?? "0") / carat"
        formulaTxt.text = rock.chemicalFormula
        hardnesTxt.text = rock.hardness
        colorTxt.text = rock.colors
        isButtonSelected = rock.isFavorite
        if rock.description != "" {
            titleDiscription.append(rock.description)
        }
        if let health = rock.healthRisks, !health.isEmpty {
            titleDiscription.append(health)
        }
        collectionDescription.reloadData()
        if rock.isFavorite {
            btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
        }
        rock.tags.forEach {
            switch $0.name {
            case "Healing": self.healingTeg.isHidden = false
            case "Rare": self.rareTeg.isHidden = false
            default: return
            }
        }
    }
    
    private func getDataStone() {
        networkStone.getStoneById(id: String(id)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.dataRock = data
                    self.article = data.articles
                    self.setupDataView()
                    if self.article.count == 0 {
                        self.bottomConstraint.constant = 20
                        self.titleArticle.isHidden = true
                        self.articleTableView.isHidden = true
                    } else if self.article.count >= 2 {
                        self.bottomConstraint.constant = 500
                    }
                    self.collectionImgStone.reloadData()
                    self.articleTableView.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
}

extension CartStoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.titleText.text = article[indexPath.row]!.title
        cell.imageViewBase.setupImgURL(url: article[indexPath.row]!.thumbnail)
        return cell
    }
}

extension CartStoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController()
        vc.id = String(article[indexPath.row]!.id)
        present(vc, animated: true)
    }
}

extension CartStoneViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = titleDiscription[indexPath.row]
        let cellWidth = collectionView.frame.width - 32
        let height = TipsStoneCell.calculateCellHeight(for: item, width: cellWidth) + 50
        heightCell.append(height)
        print(height)
        if titleDiscription.count == heightCell.count { calculateCollectionHeight() }
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionDescription: return titleDiscription.count
        case collectionImgStone: return 4
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionDescription:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TipsStoneCell.self)" , for: indexPath) as? TipsStoneCell else { return UICollectionViewCell() }
            cell.text.text = titleDiscription[indexPath.row]
            if indexPath.row == 0 {
                cell.titleCell.text = "Description"
            } else {
                cell.titleCell.text = "Healing risks"
            }
            return cell
        case collectionImgStone:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(StoneImgCell.self)" , for: indexPath) as? StoneImgCell else { return UICollectionViewCell() }
            cell.imgCell.setupImgURL(url: (dataRock?.photos[indexPath.row].image) ?? "")
            return cell
        default: return UICollectionViewCell()
        }
    }
}

