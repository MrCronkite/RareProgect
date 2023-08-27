//
//  AppsEventsFlyerLogger.swift
//
//

import Foundation
import AppsFlyerLib

class AppsEventsFlyerLogger: AnalyticsEventsLoggerProtocol {
    private let excludedEvents = [String]()
    private let lib = AppsFlyerLib.shared()
    
    func logEvent(event: String) {
        if !excludedEvents.contains(event) {
            lib.logEvent(event, withValues: nil)
        }
    }
    
    func logEvent(event: String, with params: [String: Any]) {
        func logEvent(event: String, with params: [String: Any]) {
            if !excludedEvents.contains(event) {
                lib.logEvent(event, withValues: params)
            }
        }
    }
}
