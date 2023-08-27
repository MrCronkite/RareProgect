//  FirebaseEventsLogger.swift

import FirebaseAnalytics

class FirebaseEventsLogger: AnalyticsEventsLoggerProtocol {
    private let excludedEvents = [PurchaseEvents.afEventPurchase]
    
    init() {}
    
    func logEvent(event: String) {
        if !excludedEvents.contains(event) {
            Analytics.logEvent(event, parameters: nil)
        }
    }
    
    func logEvent(event: String, with params: [String: Any]) {
        if !excludedEvents.contains(event) {
            Analytics.logEvent(event, parameters: params)
        }
    }
}
