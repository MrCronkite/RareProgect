//
//  AnalyticsEventsLoggerProtocol.swift
//
//

import Foundation

protocol AnalyticsEventsLoggerProtocol {
    func logEvent(event: String)
    func logEvent(event: String, with params: [String: Any])
}

protocol AppEventsLoggerProtocol: AnalyticsEventsLoggerProtocol {}
