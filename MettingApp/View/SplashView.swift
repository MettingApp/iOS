//
//  SplashView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isSplash: Bool = false
    @State private var opacity: Bool = false
    var body: some View {
        NavigationStack {
            if !isSplash {
                splash
                    .fadeInOut($opacity)
            } else {
                HomeView(viewModel: .init(container: .init(services: Services())))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isSplash = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UINavigationBar.appearance().backgroundColor = .clear
        }
    }
    
    var splash: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("MOTE")
                .font(.system(size: 50, weight: .heavy))
                .foregroundColor(.pointOriginColor)
            Spacer()
            Group {
                Text("Team ")
                    .foregroundColor(.gray)
                +
                Text("미나리무침")
                    .foregroundColor(.pointOriginColor)
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    SplashView()
}
