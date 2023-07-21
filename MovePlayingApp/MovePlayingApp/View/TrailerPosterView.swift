//
//  InlinePlayerView.swift
//  Created on 2023/6/29
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import SwiftUI
import AVKit

struct TrailerPosterView: View {
    @State var isPosterVisible: Bool = true

    var body: some View {
        if isPosterVisible {
            Button {
                withAnimation {
                    isPosterVisible = false
                }
            } label: {
                ZStack {
                    ZStack {
                        Image("mountain_scene", bundle: .main)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        VStack(spacing: 2) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 24.0))
                                .padding(12)
                                .background(.thinMaterial)
                                .clipShape(.circle)
                            Text("播放视频")
                                .font(.title3)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 1, y: 1)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
        } else {
            InlinePlayerView()
        }
    }
}

#Preview {
    TrailerPosterView()
}
