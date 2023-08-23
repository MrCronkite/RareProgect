//
//  AiHelperViewController.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit

final class AiHelperViewController: UIViewController {
    
    let networkChat = NetworkChatImpl()
    var idMess = ""
    var messagesBot: [MessageElement] = []
    var counter = 0
    
    var messages = ["Tell me interesting facts about rocks. What stones can be found in my country?", "Which stones are the most expensive in the world?", "What are the most popular stones to buy?"]
    
    let tintImgInactive = UIImage(named: "send")?.withTintColor(R.Colors.purple)
    let tintImgActive = UIImage(named: "send")?.withTintColor(R.Colors.roseBtn)
    
    var lastViewBottomAnchor: NSLayoutYAxisAnchor?
    @IBOutlet weak var scrollHigh: NSLayoutConstraint!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var messageTxtField: UITextField!
    @IBOutlet weak var boxSendMessage: UIView!
    @IBOutlet weak var messageCollection: UICollectionView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var scrollView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        responseMessage(below: avatar.bottomAnchor)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
        scrollHigh.constant = calculateNewInnerViewHeight() + CGFloat(140)
    }
    
    @IBAction func send(_ sender: Any) {
        counter += 1
        if counter >= 4 {
            let vc = GetPremiumViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            if let text = messageTxtField.text, !text.isEmpty, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                
                createTextViewWithText(text, below: lastViewBottomAnchor)
                header.isHidden = false
                
                sendMessage(textMessage: text)
                
                if avatar.isHidden == false{
                    UIView.animate(withDuration: 0.3) {
                        self.avatar.isHidden = true
                    }
                }
                btnSend.isEnabled = false
                btnSend.setImage(tintImgInactive, for: .normal)
                btnCloseText()
            }
        }
        messageTxtField.text = ""
    }
    
    @IBAction func getPremium(_ sender: Any) {
        let vc = StartFreeViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomInset = keyboardSize.height
            
            bottomConstraint.constant = bottomInset-85
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func clearTextField() {
        messageTxtField.text = ""
        updateButtonColor(text: "")
        textFieldDidChange(messageTxtField)
    }
}

extension AiHelperViewController {
    private func setupView() {
        header.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: messageTxtField.frame.height))
        messageTxtField.leftView = leftPaddingView
        messageTxtField.leftViewMode = .always
        messageTxtField.backgroundColor = .white
        messageTxtField.borderStyle = .none
        messageTxtField.layer.cornerRadius = 10
        messageTxtField.tintColor = .gray
        messageTxtField.attributedPlaceholder = NSAttributedString(string: "Message", attributes: placeholderAttributes)
        messageTxtField.textColor = .black
        messageTxtField.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 215, height: 54)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9
        
        messageCollection.collectionViewLayout = layout
        messageCollection.showsHorizontalScrollIndicator = false
        messageCollection.backgroundColor = .clear
        messageCollection.dataSource = self
        messageCollection.register(MessageCell.self, forCellWithReuseIdentifier: "\(MessageCell.self)")
        
        header.layer.shadowColor = UIColor.black.cgColor
        header.layer.shadowOpacity = 0.1
        header.layer.shadowOffset = CGSize(width: 0, height: 4)
        header.layer.shadowRadius = 1
    }
    
    func btnCloseText() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 30, height: messageTxtField.frame.height)
        let viewRight = UIView(frame: CGRect(x:0, y: 0, width: 40, height: messageTxtField.frame.height))
        viewRight.addSubview(clearButton)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        messageTxtField.rightView = viewRight
        messageTxtField.rightViewMode = .whileEditing
        
        messageTxtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let clearButton = (textField.rightView)?.subviews.first as? UIButton {
            clearButton.isHidden = textField.text?.isEmpty ?? true
        }
    }
    
    func createTextViewWithText(_ text: String, below anchor: NSLayoutYAxisAnchor?) {
        let textView = CustomRoundedTextView()
        textView.text = text
        textView.isEditable = false
        textView.textAlignment = .left
        textView.backgroundColor = UIColor(hexString: "#BD82FF")
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.sizeToFit()
        
        scrollView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: anchor ?? scrollView.safeAreaLayoutGuide.topAnchor, constant: 10),
            textView.widthAnchor.constraint(lessThanOrEqualToConstant: 310)
        ])
        
        lastViewBottomAnchor = textView.bottomAnchor
        let bottomOffset = CGPoint(x: 0, y: calculateNewInnerViewHeight()-100)
        scroll.setContentOffset(bottomOffset, animated: true)
        responseLoadMessage(below: lastViewBottomAnchor)
    }
    
    func responseMessage(below anchor: NSLayoutYAxisAnchor?) {
        let textViewReq = CustomRequestTextView()
        textViewReq.isEditable = false
        textViewReq.textAlignment = .left
        textViewReq.backgroundColor = .white
        textViewReq.font = UIFont.systemFont(ofSize: 16)
        textViewReq.textColor = .black
        textViewReq.isScrollEnabled = false
        textViewReq.translatesAutoresizingMaskIntoConstraints = false
        textViewReq.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textViewReq.sizeToFit()
        
        scrollView.addSubview(textViewReq)
        
        NSLayoutConstraint.activate([
            textViewReq.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textViewReq.topAnchor.constraint(equalTo: anchor ?? scrollView.safeAreaLayoutGuide.topAnchor, constant: 10),
            textViewReq.widthAnchor.constraint(lessThanOrEqualToConstant: 310),
        ])
        
        lastViewBottomAnchor = textViewReq.bottomAnchor
        
        if self.messagesBot.count == 0 {
            textViewReq.text = "Hi, welcome to The Stone Recognizer. I'm your cheerful sidekick - the gnome Doc 👋 You can always contact me with a question related to stones, crystals and minerals. I am a real expert in this business. You can find out more about how I can be helpful in the tips💡 What would you like to know about?"
        } else if self.messagesBot.count == 2 {
            textViewReq.text = self.messagesBot[1].text
            let bottomOffset = CGPoint(x: 0, y: calculateNewInnerViewHeight()-100)
            scroll.setContentOffset(bottomOffset, animated: true)
        }
        
        btnSend.isEnabled = true
        btnSend.setImage(tintImgActive, for: .normal)
    }
    
    func calculateNewInnerViewHeight() -> CGFloat {
            var totalHeight: CGFloat = 0
            for subview in scrollView.subviews {
                totalHeight += subview.intrinsicContentSize.height
            }
            return totalHeight
        }
    
    func responseLoadMessage(below anchor: NSLayoutYAxisAnchor?) {
        let textViewReq = CustomRequestTextView()
        textViewReq.isEditable = false
        textViewReq.textAlignment = .left
        textViewReq.backgroundColor = .white
        textViewReq.font = UIFont.systemFont(ofSize: 16)
        textViewReq.textColor = .black
        textViewReq.isScrollEnabled = false
        textViewReq.translatesAutoresizingMaskIntoConstraints = false
        textViewReq.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textViewReq.sizeToFit()
        
        scrollView.addSubview(textViewReq)
        textViewReq.text = "..."
        NSLayoutConstraint.activate([
            textViewReq.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textViewReq.topAnchor.constraint(equalTo: anchor ?? scrollView.safeAreaLayoutGuide.topAnchor, constant: 10),
            textViewReq.widthAnchor.constraint(lessThanOrEqualToConstant: 310)
        ])
    }
    
    func sendMessage(textMessage: String) {
        networkChat.sendMessage(textMessage: textMessage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.idMess = String(data.id)
                    self.getMessage()
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    func getMessage() {
        networkChat.getMessage(id: idMess) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    if data.messages.count == 1 {
                        self.getMessage()
                    } else {
                        self.messagesBot = data.messages
                        self.responseMessage(below: self.lastViewBottomAnchor)
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
}

extension AiHelperViewController: MessageCellDelegate {
    func sendText(text: String) {
        btnCloseText()
        messageTxtField.text = text
        btnSend.setImage(tintImgActive, for: .normal)
        if let index = messages.firstIndex(of: text) {
            messages.remove(at: index)
        }
        messageCollection.reloadData()
        if messages.count == 0 {
            collectionHeight.constant = 0
            messageCollection.isHidden = true
        }
    }
}

extension AiHelperViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MessageCell.self)", for: indexPath) as? MessageCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.viewTextCell.text = messages[indexPath.row]
        return cell
    }
}

extension AiHelperViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        updateButtonColor(text: newText)
        return true
    }
    
    func updateButtonColor(text: String) {
        if text.isEmpty {
            btnSend.setImage(tintImgInactive, for: .normal)
        } else {
            btnCloseText()
            btnSend.setImage(tintImgActive, for: .normal)
        }
    }
}
