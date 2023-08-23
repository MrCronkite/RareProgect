//
//  HomeViewController.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit
import Lottie
import StoreKit
import GoogleMobileAds

final class HomeViewController: UIViewController {
    
    var article: [Other] = []
    var articleAll: [Other] = []
    
    var originalArticle: [Other] = []
   
    let networkArticle = NetworkArticlesImpl()
    var adBannerView: GADBannerView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var articleTableView: UITableView!
    
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var originalCollection: UICollectionView!
    @IBOutlet weak var artLable: UILabel!
    @IBOutlet weak var btnTitle: UILabel!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var titleTextAll: UILabel!
    @IBOutlet weak var titleTextHealing: UILabel!
    @IBOutlet weak var titleZodiac: UILabel!
    @IBOutlet weak var titleRare: UILabel!
    @IBOutlet weak var titleOriginal: UILabel!
    @IBOutlet weak var subtitleAll: UILabel!
    @IBOutlet weak var subtitleHealing: UILabel!
    @IBOutlet weak var subtitleZodiac: UILabel!
    @IBOutlet weak var subtitleRare: UILabel!
    
    @IBOutlet weak var viewHight: NSLayoutConstraint!
    @IBOutlet weak var tableHigh: NSLayoutConstraint!
    @IBOutlet weak var zodiacView: UIView!
    @IBOutlet weak var rareView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var healing: UIView!
    
    let buttonViewAnimate = ButtonView()
    @IBOutlet weak var viewBtn: UIView!
    
    @IBOutlet weak var rollUpBtn: UIButton!
    @IBOutlet weak var seeAllBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
        
        setupView()
        
        TimerManager.shared.startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("TimerTickNotification"), object: nil)
        
        let tapZodiac = UITapGestureRecognizer(target: self, action: #selector(goToZodiac(_:)))
        zodiacView.addGestureRecognizer(tapZodiac)
        zodiacView.isUserInteractionEnabled = true
        
        let tapRare = UITapGestureRecognizer(target: self, action: #selector(goToRare(_:)))
        rareView.addGestureRecognizer(tapRare)
        rareView.isUserInteractionEnabled = true
        
        let tapHealing = UITapGestureRecognizer(target: self, action: #selector(goToHealing(_:)))
        healing.addGestureRecognizer(tapHealing)
        healing.isUserInteractionEnabled = true
        
        let tapAllStones = UITapGestureRecognizer(target: self, action: #selector(goToAll(_:)))
        allView.addGestureRecognizer(tapAllStones)
        allView.isUserInteractionEnabled = true
        
        let tapGetPremium = UITapGestureRecognizer(target: self, action: #selector(goPremium))
        btnTitle.addGestureRecognizer(tapGetPremium)
        btnTitle.isUserInteractionEnabled = true
        
//        let vc = OnbordingViewController()
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        setupLayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [zodiacView, rareView, allView, healing].forEach {
            setupGradient(view: $0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
         getArticlesPinned()
    }
    
    @objc func updateUI() {
        let remainingTime = TimerManager.shared.remainingTime
        let formattedTime = formatTimeInterval(remainingTime)
        timeTitle.text = formattedTime
    }
    
    @objc func goPremium() {
        let vc = GetPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func goToZodiac(_ sender: UITapGestureRecognizer) {
        let vc = ZodiacViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func goToRare(_ sender: UITapGestureRecognizer) {
        let vc = RareStoneViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func goToHealing(_ sender: UITapGestureRecognizer) {
        let vc = HealingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func goToAll(_ sender: UITapGestureRecognizer) {
        let vc = SearchingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func seeAllTable(_ sender: Any) {
        rollUpBtn.isHidden = false
        seeAllBtn.isHidden = true
        tableHigh.constant = 1340
        article = articleAll
        articleTableView.reloadData()
        viewHight.constant = 2300
    }
    
    @IBAction func rollUpTable(_ sender: Any) {
        seeAllBtn.isHidden = false
        rollUpBtn.isHidden = true
        tableHigh.constant = 270
        article = []
        article.append(articleAll[0])
        article.append(articleAll[1])
        articleTableView.reloadData()
        viewHight.constant = 1250
    }
}

extension HomeViewController {
    private func setupView() {
        scrolView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.isHidden = true
        navBar.backgroundColor = R.Colors.purple
        btnView.layer.cornerRadius = 15
        btnView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#DDCDFA").cgColor, UIColor(hexString: "#CEDBFD" ).cgColor, UIColor(hexString: "#FFFFFF").cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = btnView.bounds
        gradientLayer.zPosition = -1
        btnView.layer.addSublayer(gradientLayer)
        btnTitle.textColor = R.Colors.darkGrey
        btnTitle.text = "Get Premium"
        
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 8, y: 8, width: 16, height: 16)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: searchTextField.frame.height))
        leftPaddingView.addSubview(iconImageView)
        searchTextField.leftView = leftPaddingView
        searchTextField.leftViewMode = .always
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.backgroundColor = UIColor(hexString: "#ede7fd")
        searchTextField.borderStyle = .none
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 1
        searchTextField.tintColor = R.Colors.textColor
        searchTextField.textColor = R.Colors.textColor
        searchTextField.delegate = self
        
        bannerView.backgroundColor = UIColor(hexString: "#708fe7")
        bannerView.layer.cornerRadius = 25
        subtitleAll.greyColor()
        subtitleRare.greyColor()
        subtitleZodiac.greyColor()
        subtitleHealing.greyColor()
        artLable.textColor = R.Colors.darkGrey
        titleOriginal.textColor = R.Colors.darkGrey
        
        [titleTextAll, titleTextHealing, titleZodiac, titleRare].forEach { $0?.textColor = UIColor(hexString: "#4C4752") }
        
        [zodiacView, rareView, allView, healing].forEach {
            $0?.backgroundColor = R.Colors.whiteBlue
            $0?.layer.cornerRadius = 25
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.sendSubviewToBack($0!)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 170, height: 170)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        originalCollection.showsHorizontalScrollIndicator = false
        originalCollection.backgroundColor = UIColor.clear
        originalCollection.collectionViewLayout = layout
        
        originalCollection.dataSource = self
        originalCollection.delegate = self
        originalCollection.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        articleTableView.backgroundColor = .clear
        articleTableView.showsVerticalScrollIndicator = false
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.rowHeight = UITableView.noIntrinsicMetric
        articleTableView.separatorStyle = .none
        articleTableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
        
        buttonViewAnimate.delegate = self
        viewBtn.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        viewBtn.addSubview(buttonViewAnimate)
        
        adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        addBannerViewToView(adBannerView)
        adBannerView.adUnitID = R.Strings.KeyAd.bannerAdKey
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
    }
    
    private func setupLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [UIColor(hexString: "#ddcdfa").cgColor, UIColor(hexString: "#d1ddfe").cgColor, UIColor(hexString: "#f2f6ff").cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        mainView.layer.insertSublayer(gradientLayer, at: 0)
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
    
    private func setupGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#f1f2fe").cgColor, UIColor(hexString: "#e2e4fd").cgColor, R.Colors.blueLight.cgColor, UIColor(hexString: "#e2e4fd").cgColor, UIColor(hexString: "#f1f2fe").cgColor]
        gradientLayer.locations = [0.0, 0.1, 0.5, 0.9, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = view.bounds
        gradientLayer.zPosition = -1
        
        view.layer.addSublayer(gradientLayer)
        view.clipsToBounds = true
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: interval) ?? "0:00:00"
    }
    
    private func getArticlesPinned() {
        networkArticle.getArticlesStonesPinned { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.article = []
                    self.seeAllBtn.isHidden = false
                    self.rollUpBtn.isHidden = true
                    self.tableHigh.constant = 270
                    self.viewHight.constant = 1250
                    self.article.append(data.pinned[1])
                    self.article.append(data.pinned[0])
                    self.articleAll = data.pinned
                    self.articleTableView.reloadData()
                    self.originalArticle = data.other
                    self.originalCollection.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }
}

extension HomeViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.titleText.text = article[indexPath.row].title
        cell.imageViewBase.setupImgURL(url: article[indexPath.row].thumbnail)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController()
        vc.id = String(article[indexPath.row].id)
        present(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        originalArticle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.cellView.lableText.text = originalArticle[indexPath.row].title
        cell.cellView.imageView.setupImgURL(url: originalArticle[indexPath.row].thumbnail)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ArticleStonesViewController()
        vc.id = String(originalArticle[indexPath.row].id)
        present(vc, animated: true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = SearchingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
