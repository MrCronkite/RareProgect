//
//  R.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit

enum R {
    enum Colors {
        static let inactive = UIColor(hexString: "#CBD2E4")
        static let active = UIColor(hexString: "#708FE8")
        static let purple = UIColor(hexString: "#DAD1FB")
        static let textColor = UIColor(hexString: "#746685")
        static let blueLight = UIColor(hexString: "#b1d3ff")
        static let darkGrey = UIColor(hexString: "#4C4752")
        static let whiteBlue = UIColor(hexString: "#dce5fd")
        static let roseBtn = UIColor(hexString: "#BD82FF")
    }
    
    
    enum Images {
        static var banner = UIImage(named: "advBanner")
        static var downArrow = UIImage(named: "downArrow")
    }
    
    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .home : return "Home"
                case .detection : return "Detection"
                case .collection : return "History"
                case .aihelper : return "Ai Helper"
                }
            }
        }
        enum Camera {
            static let loadingText = ["Looking for a match", "Preparing a description", "Determine the cost per carat"]
        }
        enum KeyAd {
            static let bannerAdKey = "ca-app-pub-3940256099942544/2934735716"
        }
        enum KeyUserDefaults {
            static let token = "TokenKey"
        }
    }
    
    enum ImagesBar {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .home : return UIImage(named: "home")
                case .detection : return UIImage(named: "detection")
                case .collection : return UIImage(named: "collection")
                case .aihelper : return UIImage(named: "chat")
                }
            }
        }
    }
    
    enum Font {
        static func helvetica(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
        }
    }
}
