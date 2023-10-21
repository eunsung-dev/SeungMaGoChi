//
//  PedometerViewModel.swift
//  SeungMaGoChi Watch App
//
//  Created by 최은성 on 2023/04/01.
//

import SwiftUI
import Foundation
import CoreMotion

/*
 [ToDo]
 추후 리팩토링 필요
 */

class PedometerViewModel: ObservableObject {
    let pedometer = CMPedometer()
    let now = Date().toInt()
    
    @AppStorage("beforeDate") var beforeDate: Int = (UserDefaults.standard.integer(forKey: "beforeDate"))
    
    @AppStorage("exp") var exp: Int = (UserDefaults.standard.integer(forKey: "exp"))
    
    var isPedometerAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    func initializePedometer() {
        print("initializePedometer() 호출")
        
        if beforeDate == 0 {
            // 초기값 설정
            beforeDate = now
        }
        else if beforeDate < now {
            saveExp()
        }
        
    }
    
    // MARK: 걷기 경험치 저장하는 메서드
    func saveExp() {
        print("saveExp() 호출")
        if isPedometerAvailable {
            guard let startDate = Calendar.current.date(byAdding: .day, value: now-beforeDate, to: Date()) else { return }
            
            pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
                guard let data = data, error == nil else { return }
                
                self.exp = Int(Double(data.numberOfSteps.intValue) * 0.1) // 걸음 수 저장
                self.updateBeforeDate()
            }
        }
    }
    
    // MARK: 걷기 경험치 초기화하는 메서드
    func clearExp() {
        print("clearExp() 호출")
        
    }
    
    // MARK: beforeDate 업데이트하는 메서드
    func updateBeforeDate() {
        beforeDate = now
    }
}

extension Date {
    func toInt() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return Int(dateFormatter.string(from: self)) ?? -1
    }
}
