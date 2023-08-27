//
//  ZodiacViewController.swift
//  RareStones
//
//  Created by admin1 on 11.08.23.
//

import UIKit
import Lottie
import GoogleMobileAds

final class ZodiacViewController: UIViewController {
    
    var zodiacCategory: [Results] = []
    var zodiacStones: [StoneElement] = []
    let networkService = NetworkServicesZodiacImpl()
    let buttonViewAnimate = ButtonView()
    var adBannerView: GADBannerView!
    
    @IBOutlet weak var dataOfBirthLable: UILabel!
    @IBOutlet weak var titleZodiac: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var heightBoxView: NSLayoutConstraint!
    @IBOutlet weak var elementTxt: UILabel!
    @IBOutlet weak var boxZodiac: UIView!
    @IBOutlet weak var imageZodiac: UIImageView!
    @IBOutlet weak var dataBirthText: UILabel!
    @IBOutlet weak var elementText: UILabel!
    @IBOutlet weak var zodiacCollection: UICollectionView!
    @IBOutlet weak var stoneTableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        getZodiac()
        getZodiacForId(id: "1")
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
        boxZodiac.setupGradient()
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
                    self.stoneTableView.reloadData()
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
        
        stoneTableView.contentInset = .init(top: 0, left: 0, bottom: 130, right: 0)
        stoneTableView.backgroundColor = .clear
        stoneTableView.showsVerticalScrollIndicator = false
        stoneTableView.dataSource = self
        stoneTableView.delegate = self
        stoneTableView.rowHeight = UITableView.noIntrinsicMetric
        stoneTableView.separatorStyle = .none
        stoneTableView.register(StoneZodiacCell.self, forCellReuseIdentifier: "\(StoneZodiacCell.self)")
        
        elementTxt.greyColor()
        dataOfBirthLable.greyColor()
        boxZodiac.backgroundColor = R.Colors.blueLight
        boxZodiac.layer.cornerRadius = 20
        boxZodiac.layer.borderWidth = 1
        boxZodiac.layer.borderColor = UIColor.white.cgColor
        imageZodiac.contentMode = .scaleAspectFill
        
        viewButton.layer.cornerRadius = 25
        viewButton.backgroundColor = .clear
        buttonViewAnimate.delegate = self
        viewButton.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        viewButton.addSubview(buttonViewAnimate)
        viewButton.layer.shadowColor = UIColor.black.cgColor
        viewButton.layer.shadowOpacity = 0.2
        viewButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewButton.layer.shadowRadius = 10
        
        adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(adBannerView)
        adBannerView.adUnitID = R.Strings.KeyAd.bannerAdKey
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
    }
    
    private func addBannerViewToView(_ adbannerView: GADBannerView) {
        adbannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.addSubview(adbannerView)
        bannerView.addConstraints(
            [NSLayoutConstraint(item: adbannerView,
                                attribute: .centerY,
                                relatedBy: .equal,
                                toItem: bannerView,
                                attribute: .centerY,
                                multiplier: 1,
                                constant: -10 ),
             NSLayoutConstraint(item: adbannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: bannerView,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    private func localize() {
        backButton.setTitle("", for: .normal)
        elementTxt.text = "h_zodiac_element".localized
        dataOfBirthLable.text = "h_dataofbirth".localized
        titleZodiac.text = "h_zodiac_title".localized
    }
}

extension ZodiacViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension ZodiacViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        zodiacStones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(StoneZodiacCell.self)", for: indexPath) as? StoneZodiacCell else { return UITableViewCell()}
        cell.imageStoneView.setupImgURL(url: zodiacStones[indexPath.row].stone.image)
        cell.nameStone.text = zodiacStones[indexPath.row].stone.name
        cell.titleStone.text = zodiacStones[indexPath.row].description
        cell.selectionStyle = .none
        return cell
    }
}

extension ZodiacViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = zodiacStones[indexPath.row].description
        let cellWidth = tableView.frame.width
        let height = TipsStoneCell.calculateCellHeight(for: item, width: cellWidth)
        return height + 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CartStoneViewController()
        vc.id = zodiacStones[indexPath.row].stone.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension ZodiacViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        zodiacCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ZodiacCollectionCell.self)", for: indexPath) as? ZodiacCollectionCell
        else { return UICollectionViewCell() }
        cell.lableTextCell.text = zodiacCategory[indexPath.row].name
        return cell
    }
}

extension ZodiacViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
