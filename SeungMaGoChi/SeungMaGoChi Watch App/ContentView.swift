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
    var body: some View {
        VStack {
            Text(pedometerViewModel.steps != nil ? "\(pedometerViewModel.steps!) steps" : "")
        }
        .padding()
        .onAppear {
                DispatchQueue.main.async {
                    pedometerViewModel.initializePedometer()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
