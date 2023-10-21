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
    
    @AppStorage("lastClicked") private var lastClickedInterval: TimeInterval = .zero
    @AppStorage("exp") var exp: Int = (UserDefaults.standard.integer(forKey: "exp"))
    
    @State private var isButtonDisabled = false
    @State private var characterSource = "characterLv1"
    private let feedSource = "carrot"
    private let backgroundSource = "background"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    exp += 100
                    self.setLastClickedDate(date: Date()) // 현재 시간 저장
                    checkButtonStatus()
                }) {
                    Image(feedSource)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isButtonDisabled)
            }
            Button(action: {
                withAnimation(.easeInOut(duration: 1.0)) { // 원하는 애니메이션 지속 시간 설정
                    exp += 1
                }
            }) {
                Image(characterSource)
                    .resizable()
                    .scaledToFit()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .onAppear(perform:{
            DispatchQueue.main.async{
                pedometerViewModel.initializePedometer()
            }
            checkButtonStatus()
        })
        .onChange(of: exp, perform: { newValue in
            print("newValue: \(newValue)")
            if newValue > 10000 {
                characterSource = "characterLv1"    // [ToDo] 이미지 수정
            }
        })
        .background(
            Image(backgroundSource)
                .resizable()
                .ignoresSafeArea()
        )
        
        
    }
    
    func setLastClickedDate(date: Date) {
        lastClickedInterval = date.timeIntervalSince1970
    }
    
    func getLastClickedDate() -> Date {
        return Date(timeIntervalSince1970:lastClickedInterval)
    }
    
    // MARK: 버튼 활성화 여부 체크하는 메서드
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
