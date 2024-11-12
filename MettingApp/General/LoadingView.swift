//
//  LoadingView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import SwiftUI
import Kingfisher

struct LoadingView: View {
    var url: String
    var size: [CGFloat]
    
    var body: some View {
        if let url = Bundle.main.url(forResource: self.url, withExtension: "gif") {
            KFAnimatedImage(url)
                .scaledToFit()
                .frame(width: size[0], height: size[1])
        }
    }
}

#Preview {
    LoadingView(url: "bell", size: [150, 150])
}
