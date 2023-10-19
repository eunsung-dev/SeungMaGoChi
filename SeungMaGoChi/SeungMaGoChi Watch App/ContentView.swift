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
    @State private var steps = 0
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                }) {
                    Circle()
                        .fill(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 35, height: 35)
            }
            Button(action: {
                withAnimation(.easeInOut(duration: 1.0)) { // 원하는 애니메이션 지속 시간 설정
                    steps += 1
                }
            }) {
                Image(systemName: steps > 10 ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
            }
            .clipShape(Circle())
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
