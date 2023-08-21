//
//  CollectionViewController.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    var alertController: UIAlertController?
    
    @IBOutlet weak var boxBtnView: UIView!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var boxText: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var btncamera: UIView!
    @IBOutlet weak var titleTxt: UILabel!
    
    let networkStone = NetworkStoneImpl()
    let networkClass = NetworkClassificationImpl()
    var isHistory = true
    
    var stonesWishList: [WishlistResult] = []
    var historyColletion: [HistoryResult] = []
    
    let btn = ButtonView()
    
    @IBOutlet weak var stonesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getHistory()
        
        btnFirst.addTarget(self, action: #selector(btnTogle(_:)), for: .touchUpInside)
        btnSecond.addTarget(self, action: #selector(btnTogle(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(openAllStones(_:)))
        btncamera.addGestureRecognizer(tap)
        btncamera.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHistory()
        isHistory = true
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        btnSecond.backgroundColor = .clear
        btnSecond.tintColor = R.Colors.textColor
        btnFirst.backgroundColor = R.Colors.roseBtn
        btnFirst.tintColor = .white
        btn.isHidden = false
        getHistory()
    }
    
    
    @IBAction func goToSettings(_ sender: Any) {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func btnTogle(_ sender: UIButton) {
        btnFirst.backgroundColor = .clear
        btnFirst.tintColor = R.Colors.textColor
        btnSecond.backgroundColor = .clear
        btnSecond.tintColor = R.Colors.textColor
        
        sender.tintColor = .white
        sender.backgroundColor = R.Colors.roseBtn
        animateButtonPressed(view: sender)
        if sender.titleLabel?.text == "History" {
            isHistory = true
            getHistory()
            btn.isHidden = false
        } else {
            isHistory = false
            getStonesWhislist()
        }
    }
     
    @objc func openAllStones(_ sender: UITapGestureRecognizer) {
       let vc = SearchingViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension CollectionViewController {
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        boxBtnView.backgroundColor = UIColor(hexString: "#DAD1FB")
        boxBtnView.layer.cornerRadius = 30
        boxBtnView.layer.borderWidth = 1
        boxBtnView.layer.borderColor = UIColor.white.cgColor
        boxBtnView.clipsToBounds = true
        btnFirst.layer.cornerRadius = 26
        btnSecond.layer.cornerRadius = 26
        btnSecond.backgroundColor = .clear
        btnSecond.tintColor = R.Colors.textColor
        btnFirst.backgroundColor = R.Colors.roseBtn
        btnFirst.tintColor = .white
        
        btncamera.layer.cornerRadius = 23
        btncamera.backgroundColor = R.Colors.roseBtn
        boxText.backgroundColor = .clear
        subtitle.greyColor()
        
        btn.delegate = self
        btncamera.frame = btn.frame
        btn.setupAnimation()
        btncamera.addSubview(btn)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 166, height: 205)
        layout.scrollDirection = .vertical
        stonesCollection.showsVerticalScrollIndicator = false
        stonesCollection.backgroundColor = UIColor.clear
        stonesCollection.collectionViewLayout = layout
        
        stonesCollection.dataSource = self
        stonesCollection.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        if stonesWishList.count > 0 {
            boxText.isHidden = true
        }
    }
    
    private func animateButtonPressed(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.alpha = 0.7
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in
            UIView.animate(withDuration: 0.1, animations: {
                view.alpha = 1.0
                view.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func getStonesWhislist() {
        networkStone.getWashList() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.count > 0 {
                        self.btn.isHidden = false
                        self.stonesWishList = data.results
                        self.stonesCollection.reloadData()
                        self.titleTxt.text = ""
                        self.subtitle.text = ""
                    } else {
                        self.stonesWishList = []
                        self.titleTxt.text = "Your wish list is empty"
                        self.subtitle.text = "To add a stone to the wish list click on the heart icon in the stone card"
                        self.btn.isHidden = true
                        self.stonesCollection.reloadData()
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    private func getHistory() {
        networkClass.getClassificationHistory { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.count > 0 {
                        self.historyColletion = data.results
                        self.stonesCollection.reloadData()
                        self.titleTxt.text = ""
                        self.subtitle.text = ""
                    } else {
                        self.titleTxt.text = "Your history is empty"
                        self.subtitle.text = "Take advantage of the recognition feature to add to your history"
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
    
   private func showActivityIndicator() {
            alertController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
       let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.startAnimating()
            alertController?.view.addSubview(activityIndicator)
            
            let constraints = [
                activityIndicator.centerXAnchor.constraint(equalTo: alertController!.view.centerXAnchor),
                activityIndicator.topAnchor.constraint(equalTo: alertController!.view.topAnchor, constant: 40),
                activityIndicator.heightAnchor.constraint(equalToConstant: 70),
                activityIndicator.bottomAnchor.constraint(equalTo: alertController!.view.bottomAnchor, constant: 10)
            ]
            NSLayoutConstraint.activate(constraints)
            
            present(alertController!, animated: true, completion: nil)
        }
        
       private func hideActivityIndicator() {
           DispatchQueue.main.async {
               self.alertController?.dismiss(animated: true, completion: nil)
               self.alertController = nil
           }
        }
}

extension CollectionViewController: CartStoneDelegate {
    func openStone(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func deleteFromCollection() {
        showActivityIndicator()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5){
            self.getStonesWhislist()
            self.hideActivityIndicator()
        }
    }
}

extension CollectionViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isHistory {
            return historyColletion.count
        } else {
            return  stonesWishList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCollectionViewCell", for: indexPath) as! StoneCollectionViewCell
        cell.cellView.delegate = self
        if isHistory {
            cell.cellView.titleStone.text = historyColletion[indexPath.row].results[0].stone.name
            cell.cellView.btnHeart.isHidden = true
            cell.cellView.imageStone.setupImgURL(url: historyColletion[indexPath.row].image)
            cell.cellView.priceStone.text = "\(historyColletion[indexPath.row].results[0].stone.pricePerCaratTo?.remove$() ?? "0") / crt"
            cell.cellView.id = historyColletion[indexPath.row].results[0].stone.id
            return cell
        } else {
            cell.cellView.isButtonSelected = true
            cell.cellView.btnHeart.isHidden = false
            cell.cellView.btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
            cell.cellView.imageStone.setupImgURL(url: stonesWishList[indexPath.row].stone.image)
            cell.cellView.priceStone.text = "\(stonesWishList[indexPath.row].stone.pricePerCaratTo?.remove$() ?? "0") / crt"
            cell.cellView.titleStone.text = stonesWishList[indexPath.row].stone.name
            cell.cellView.id = stonesWishList[indexPath.row].stone.id
            return cell
        }
    }
}

