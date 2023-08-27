//
//  FacebookLogger.swift
//
//

import Foundation
import FBSDKLoginKit

class FacebookLogger: AnalyticsEventsLoggerProtocol {
    private let excludedEvents = [
        PurchaseEvents.afEventPurchase
    ]
    
    func logEvent(event: String) {
        if !excludedEvents.contains(event) {
            AppEvents.shared.logEvent(AppEvents.Name(event))
        }
    }
    
    func logEvent(event: String, with params: [String: Any]) {
        if !excludedEvents.contains(event) {
            let parameters: [AppEvents.ParameterName: Any] = Dictionary(uniqueKeysWithValues: params.map { key, value in
                (AppEvents.ParameterName(key), value)
            })
            AppEvents.shared.logEvent(AppEvents.Name(event), parameters: parameters)
        }
    }
}
