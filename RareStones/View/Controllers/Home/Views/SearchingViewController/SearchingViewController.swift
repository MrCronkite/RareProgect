//
//  SearchingViewController.swift
//  RareStones
//
//  Created by admin1 on 10.08.23.
//

import UIKit
import SDWebImage
import GoogleMobileAds

final class SearchingViewController: UIViewController {
    
    let networkStone = NetworkStoneImpl()
    var rocks: [Element] = []
    var filteredItems: [Element] = []
    
    var adBannerView: GADBannerView!
    let buttonViewAnimate = ButtonView()
    
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewButtonAnimated: UIView!
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var textFiledSearch: UITextField!
    @IBOutlet weak var azButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var priceLowButton: UIButton!
    
    @IBOutlet weak var stoneColectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllStones()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getAllStones()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        azButton.backgroundColor = UIColor(hexString: "#dcdffd")
        priceButton.backgroundColor = UIColor(hexString: "#dcdffd")
        priceLowButton.backgroundColor = UIColor(hexString: "#dcdffd")
        azButton.tintColor = R.Colors.textColor
        priceButton.tintColor = R.Colors.textColor
        priceLowButton.tintColor = R.Colors.textColor
        switch sender.titleLabel?.text {
        case "Price low":
            filteredItems.sort { Int($0.pricePerCaratTo?.remove$() ?? "0") ?? 0 < Int($1.pricePerCaratTo?.remove$() ?? "0") ?? 0 }
            stoneColectionView.reloadData()
        case "A - Z":
            filteredItems.sort { $0.name < $1.name }
            stoneColectionView.reloadData()
        case "Price high":
            filteredItems.sort { Int($0.pricePerCaratTo?.remove$() ?? "0") ?? 0 > Int($1.pricePerCaratTo?.remove$() ?? "0") ?? 0}
            stoneColectionView.reloadData()
        case .none:
            return
        case .some(_):
            return
        }
        
        sender.backgroundColor = R.Colors.active
        sender.tintColor = .white
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    @IBAction func searchingText(_ sender: UITextField) {
        filterContentForSearchText(sender.text)
    }
    
}

extension SearchingViewController {
    private func setupView() {
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 8, y: 10, width: 16, height: 16)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textFiledSearch.frame.height))
        leftPaddingView.addSubview(iconImageView)
        textFiledSearch.leftView = leftPaddingView
        textFiledSearch.leftViewMode = .always
        textFiledSearch.layer.borderColor = UIColor.white.cgColor
        textFiledSearch.backgroundColor = UIColor(hexString: "#ede7fd")
        textFiledSearch.borderStyle = .none
        textFiledSearch.layer.cornerRadius = 10
        textFiledSearch.layer.borderWidth = 1
        textFiledSearch.tintColor = R.Colors.textColor
        textFiledSearch.textColor = R.Colors.textColor
        textFiledSearch.delegate = self
        
        let placeholderText = "Search by stones and minerals"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.Colors.textColor,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        textFiledSearch.attributedPlaceholder = attributedPlaceholder
        
        azButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        priceButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        priceLowButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        [azButton, priceButton, priceLowButton].forEach {
            $0?.backgroundColor = UIColor(hexString: "#dcdffd")
            $0?.layer.cornerRadius = 10
            $0?.tintColor = R.Colors.textColor
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 166, height: 205)
        layout.scrollDirection = .vertical
        stoneColectionView.showsVerticalScrollIndicator = false
        stoneColectionView.backgroundColor = UIColor.clear
        stoneColectionView.collectionViewLayout = layout
        stoneColectionView.contentInset = .init(top: 0, left: 0, bottom: 130, right: 0)
        stoneColectionView.dataSource = self
        stoneColectionView.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(adBannerView)
        adBannerView.adUnitID = R.Strings.KeyAd.bannerAdKey
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
        
        viewButtonAnimated.layer.cornerRadius = 25
        viewButtonAnimated.backgroundColor = .clear
        buttonViewAnimate.delegate = self
        viewButtonAnimated.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        viewButtonAnimated.addSubview(buttonViewAnimate)
        viewButtonAnimated.layer.shadowColor = UIColor.black.cgColor
        viewButtonAnimated.layer.shadowOpacity = 0.3
        viewButtonAnimated.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewButtonAnimated.layer.shadowRadius = 10
        
        buttonClose.setTitle("", for: .normal)
        priceLowButton.setTitle("h_search_high".localized, for: .normal)
        priceLowButton.titleLabel?.textAlignment = .center
        priceButton.titleLabel?.textAlignment = .center
        priceButton.setTitle("h_search_low".localized, for: .normal)
        textFiledSearch.placeholder = "h_search_field".localized
    }
    
    private func addBannerViewToView(_ adbannerView: GADBannerView) {
        adbannerView.translatesAutoresizingMaskIntoConstraints = false
        boxAdView.addSubview(adbannerView)
        boxAdView.addConstraints(
          [NSLayoutConstraint(item: adbannerView,
                              attribute: .centerY,
                              relatedBy: .equal,
                              toItem: boxAdView,
                              attribute: .centerY,
                              multiplier: 1,
                              constant: 0 ),
           NSLayoutConstraint(item: adbannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: boxAdView,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    func getAllStones() {
        networkStone.getStones { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.rocks = data.results
                    self.rocks.shuffle()
                    self.filteredItems = self.rocks
                    self.stoneColectionView.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
                filteredItems = rocks.filter { item in
                    return item.name.lowercased().contains(searchText.lowercased())
                }
            } else {
                filteredItems = rocks
            }
            stoneColectionView.reloadData()
    }
}

extension SearchingViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension SearchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCollectionViewCell", for: indexPath) as! StoneCollectionViewCell
        cell.cellView.titleStone.text = filteredItems[indexPath.row].name
        cell.cellView.imageStone.sd_setImage(with: URL(string: filteredItems[indexPath.row].image ))
        cell.cellView.priceStone.text = "\(filteredItems[indexPath.row].pricePerCaratTo?.remove$() ?? "0") / ct"
        cell.cellView.id = filteredItems[indexPath.row].id
        cell.cellView.delegate = self
        cell.cellView.isButtonSelected = filteredItems[indexPath.row].isFavorite
        if filteredItems[indexPath.row].isFavorite {
            cell.cellView.btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
        } else { cell.cellView.btnHeart.setImage(UIImage(named: "heart"), for: .normal) }
        return cell
    }
}

extension SearchingViewController: CartStoneDelegate {
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

extension SearchingViewController: UITextFieldDelegate {
    
}
