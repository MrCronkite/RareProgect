//
//  AppEventsLogger.swift
//
//

import Foundation

class AppEventsLogger {
    private let loggers: [AnalyticsEventsLoggerProtocol] = [
        FirebaseEventsLogger(),
        AppsEventsFlyerLogger(),
        FacebookLogger(),
        AppMetricaEventsLogger()
    ]
    
    static let shared = AppEventsLogger()
    
    private init() {}
}

extension AppEventsLogger: AppEventsLoggerProtocol {
    func logEvent(event: String) {
        loggers.forEach { $0.logEvent(event: event)}
        print("Event sent: \(event)")
    }
    
    func logEvent(event: String, with params: [String: Any]) {
        loggers.forEach { $0.logEvent(event: event, with: params)}
        print("Event sent: \(event), \(params)")
    }
}
