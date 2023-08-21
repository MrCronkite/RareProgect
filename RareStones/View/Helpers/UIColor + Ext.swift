//
//  UIColor + Ext.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UILabel {
    func greyColor() {
        self.textColor = R.Colors.textColor
    }
}

extension String {
    func remove$() -> String {
        let cleanedString = self.replacingOccurrences(of: "[\\$,\\s]", with: "", options: .regularExpression)
            return cleanedString
    }
}

extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
    
    func setupLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor(hexString: "#dbcffa").cgColor, UIColor(hexString: "#edf2fe").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.zPosition = -2
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIImageView {
    func setupImgURL(url: String) {
        self.sd_setImage(with: URL(string: url))
    }
}

class CustomRoundedTextView: UITextView {
    override func layoutSubviews() {
            super.layoutSubviews()
            
            layer.cornerRadius = 15
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 0, height: 0))
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
}

class CustomRequestTextView: UITextView {
    override func layoutSubviews() {
            super.layoutSubviews()
            
            layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomRight], cornerRadii: CGSize(width: 0, height: 0))
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
        }
}



