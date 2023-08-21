//
//  Timer.swift
//  RareStones
//
//  Created by admin1 on 17.08.23.
//

import Foundation

class TimerManager {
    static let shared = TimerManager()
    
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    
    var remainingTime: TimeInterval {
        return max(30 * 60 - elapsedTime, 0)
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func timerTick() {
        elapsedTime += 1
        
        NotificationCenter.default.post(name: Notification.Name("TimerTickNotification"), object: nil)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

