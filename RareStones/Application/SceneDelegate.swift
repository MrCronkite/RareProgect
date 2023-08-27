//
//  SceneDelegate.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appopenAD: GADAppOpenAd?
    var lastActiveViewController: UIViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let lastActiveViewController = lastActiveViewController {
            //appopenAD?.present(fromRootViewController: lastActiveViewController)
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        loadAppOpenAd()
        if let rootViewController = window?.rootViewController,
           let presentedViewController = rootViewController.presentedViewController {
            lastActiveViewController = presentedViewController
        } else {
            lastActiveViewController = window?.rootViewController
        }
    }
    
    private func loadAppOpenAd(){
        GADAppOpenAd.load(withAdUnitID: R.Strings.KeyAd.appOpenAdKey,
                          request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            
            self.appopenAD = ad
            //self.appopenAD?.fullScreenContentDelegate = self
        }
    }
}

