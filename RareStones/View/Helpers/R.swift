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
                case .home : return "tab_home".localized
                case .detection : return "tab_detection".localized
                case .collection : return "tab_history".localized
                case .aihelper : return "tab_Ai_helper".localized
                }
            }
        }
        enum Camera {
            static let loadingText = ["cam_pt_looking_1".localized, "cam_pt_looking_2".localized, "cam_pt_looking_3".localized]
            static let styles: [UIBlurEffect.Style] = [.dark, .extraLight, .prominent, .systemChromeMaterial, .systemThinMaterialLight, .systemMaterial, .systemUltraThinMaterialDark, .regular, .systemChromeMaterial, .systemUltraThinMaterialLight]
        }
        
        enum AiHelper {
            static let message = "helper_mess".localized
            static var questions = ["helper_question1".localized,
                                    "helper_question2".localized,
                                    "helper_question3".localized]
        }
        
        enum KeyAd {
            static let bannerAdKey = "ca-app-pub-3940256099942544/2934735716"
            static let rewardedInterKey = "ca-app-pub-3940256099942544/6978759866"
            static let appOpenAdKey = "ca-app-pub-3940256099942544/4411468910"
            static let interKey = "ca-app-pub-3940256099942544/4411468910"
        }
        
        enum KeyUserDefaults {
            static let token = "TokenKey"
        }
         
        enum Links {
            static let privacy = "https://ai-stones.com/privacy.html"
            static let terms = "https://ai-stones.com/terms.html"
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
