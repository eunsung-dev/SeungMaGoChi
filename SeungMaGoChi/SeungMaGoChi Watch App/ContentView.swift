//
//  ContentView.swift
//  SeungMaGoChi Watch App
//
//  Created by 최은성 on 2023/04/01.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @ObservedObject var pedometerViewModel = PedometerViewModel()
//    @AppStorage("firstExe") var firstExe: Bool = UserDefaults.standard.bool(forKey: "firstExe")
    @AppStorage("startDate") var startDate: String = (UserDefaults.standard.string(forKey: "startDate") ?? "")
    // 날짜는 계속해서 앱 처음 실행했을 때로 고정
    // 경험치는 계속해서 같은 걸음도 누적되겠지? 그럼 이걸 차이를 계산할 필요가 있을까?
    // 단순히 같은 작업을 수행해도 무리는 안될거같은데
    var body: some View {
        VStack {
            Text(pedometerViewModel.steps != nil ? "\(pedometerViewModel.steps!) steps" : "")
            Text(String(startDate))
        }
        .padding()
        .onAppear {
            startDate = ""
            print("before startDate: \(String(startDate))")
            if startDate == "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                startDate = dateFormatter.string(from: Date())
                print("\(Date())")
                print("startDate: \(startDate)")
                DispatchQueue.main.async {
                    pedometerViewModel.initializePedometer()
                }
            }
            print("after startDate: \(String(startDate))")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
