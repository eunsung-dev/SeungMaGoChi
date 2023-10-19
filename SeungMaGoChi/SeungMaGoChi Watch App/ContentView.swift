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
    
    @AppStorage("lastClicked") private var lastClickedInterval: TimeInterval = .zero
    
    @State private var isButtonDisabled = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.setLastClickedDate(date: Date()) // 현재 시간 저장
                    checkButtonStatus()
                }) {
                    Circle()
                        .fill(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 35, height: 35)
                .disabled(isButtonDisabled)
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
        .onAppear(perform:{
             DispatchQueue.main.async{
                  pedometerViewModel.initializePedometer()
             }
         })
        
       
     }

     func setLastClickedDate(date: Date) {
         lastClickedInterval = date.timeIntervalSince1970
     }

     func getLastClickedDate() -> Date {
         return Date(timeIntervalSince1970:lastClickedInterval)
     }

     func checkButtonStatus() {
         let timeSinceLastClick = Date().timeIntervalSince(getLastClickedDate())

         if timeSinceLastClick < 4*60*60 { // 4시간 경과 미만일 경우
             isButtonDisabled = true

             let remainingTime = 4*60*60 - timeSinceLastClick

             DispatchQueue.main.asyncAfter(deadline:.now()+remainingTime) {
                 self.isButtonDisabled=false
             }

         } else{
              isButtonDisabled=false
          }
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
