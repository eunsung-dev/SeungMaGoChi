//
//  PedometerViewModel.swift
//  SeungMaGoChi Watch App
//
//  Created by 최은성 on 2023/04/01.
//

import SwiftUI
import Foundation
import CoreMotion

class PedometerViewModel: ObservableObject {
    let pedometer = CMPedometer()
    @AppStorage("startDate") var startDate: String = (UserDefaults.standard.string(forKey: "startDate") ?? "")

    @Published var steps: Int?
    
    var isPedometerAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    func initializePedometer() {
        print("initializePedometer() 호출")
        guard let date = startDate.toDate() else { return }
//            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return }
        print("date: \(date)")
        if isPedometerAvailable {
            print("isPedometerAvailable check")
            guard let date = startDate.toDate() else { return }
            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return }
            print("date: \(date)")
            print("startDate: \(startDate)")
            pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
                guard let data = data, error == nil else { return }
                
                self.steps = data.numberOfSteps.intValue
            }
        }
    }
}

extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
