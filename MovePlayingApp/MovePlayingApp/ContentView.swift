//
//  ContentView.swift
//  Created on 2023/6/27
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation
import AVKit



// MARK: 视频的简单播放
struct ContentView: View {

    @Environment(PlayerModel.self) private var player
    @State private var navigationPath = [Video]()
    @State private var isPresentingSpace = false

    var body: some View {
        switch player.presentation {
        case .fullScreen:
            FullScreenPlayer()
                .onAppear() {
                    player.play()
                }
        default:
            HomeView(path: $navigationPath, isPresentingSpace: $isPresentingSpace)
        }
    }
}

#Preview {
    ContentView()
}
