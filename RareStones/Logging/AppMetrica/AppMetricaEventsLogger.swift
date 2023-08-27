//
//  AppMetricaEventsLogger.swift
//
//

import Foundation
import YandexMobileMetrica

class AppMetricaEventsLogger: AnalyticsEventsLoggerProtocol {
    private let excludedEvents = [
        PurchaseEvents.afEventPurchase
    ]
    private let profile = YMMMutableUserProfile()
        
    init() {}
    
    func logEvent(event: String) {
        if !excludedEvents.contains(event) {
            YMMYandexMetrica.reportEvent(event, onFailure: nil)
        }
    }
    
    func logEvent(event: String, with params: [String: Any]) {
        if !excludedEvents.contains(event) {
            YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: nil)
        }
    }
    
    func logAttributes(gender: GenderType? = nil,
                       age: Int? = nil,
                       weight: Int? = nil,
                       height: Int? = nil,
                       measurementSystem: UnitSystem? = nil) {
        var attributes = [YMMUserProfileUpdate]()
        if let gender = gender {
            switch gender {
            case .female:
                attributes.append(YMMProfileAttribute.gender().withValue(YMMGenderType.female))
            case .male:
                                    attributes.append(YMMProfileAttribute.gender().withValue(YMMGenderType.male))
            }
        }
        if let age = age {
            attributes.append(YMMProfileAttribute.birthDate().withAge(UInt(age)))
        }
        if let weight = weight {
            attributes.append(YMMProfileAttribute.customNumber("weight").withValueIfUndefined(Double(weight)))
        }
        if let height = height {
            attributes.append(YMMProfileAttribute.customNumber("height").withValueIfUndefined(Double(height)))
        }
        if let measurementSystem = measurementSystem {
            attributes.append(YMMProfileAttribute.customString("units").withValueIfUndefined(measurementSystem.rawValue))
        }
        profile.apply(from: attributes)
        
        YMMYandexMetrica.report(profile, onFailure: nil)
    }
}
