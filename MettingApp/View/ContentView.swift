//
//  ContentView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isSplash: Bool = false
    @State private var opacity: Bool = false
    var body: some View {
        NavigationStack {
            if !isSplash {
                splash
                    .fadeInOut($opacity)
            } else {
                
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isSplash = true
            }
        }
    }
    
    var splash: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("MOTE")
                .font(.system(size: 50, weight: .heavy))
                .foregroundColor(.pointColor)
            Spacer()
            Group {
                Text("Team ")
                    .foregroundColor(.gray)
                +
                Text("미나리무침")
                    .foregroundColor(.pointColor)
            }
            .font(.system(size: 15, weight: .bold))
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    ContentView()
}
