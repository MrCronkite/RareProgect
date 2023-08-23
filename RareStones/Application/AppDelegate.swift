//
//  AppDelegate.swift
//  RareStones
//
//  Created by admin1 on 7.08.23.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let networkRegistred = RegistredUser()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if UserDefaults.standard.string(forKey: R.Strings.KeyUserDefaults.token) == nil {
            registredUser()
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "5d4a440af5fcf0c37163629124c85836" ]
        return true
    }
    
    private func registredUser() {
        let credentials = generateUniqueUsernameAndPassword()
        print(credentials.password)
        networkRegistred.registerUser(username: credentials.username,
                                      password: credentials.password) { result in
            switch result {
            case .success(let token): print(token)
                UserDefaults.standard.set(token, forKey: R.Strings.KeyUserDefaults.token)
            case .failure(let error): print(error)
            }
        }
    }
    
    private func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    private func generateUniqueUsernameAndPassword() -> (username: String, password: String) {
        let username = "user_" + generateRandomString(length: 8)
        let password = generateRandomString(length: 12)
        return (username, password)
    }
}

