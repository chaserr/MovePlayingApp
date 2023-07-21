//
//  MovePlayingAppApp.swift
//  Created on 2023/6/27
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import SwiftUI
import os

@main
struct MovePlayingAppApp: App {

    @State private var player = PlayerModel()
    @State private var library = VideoLibrary()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(player)
                .environment(library)
        }
//        // 这里我们为指定类型的呈现数据创建一个沉浸式空间
//        
        ImmersiveSpace(id: "ImmersiveSpace") {
            DestinationView()
        }
//        // 设置沉浸式空间的风格，这里有3种风格可供设置
//        // mixed风格将您的内容与直通融合在一起。这使您能够将虚拟对象放置在人的周围环境中。
//        // full样式仅显示您的内容，并关闭直通。这使您能够完全控制视觉体验，就像当您想要将人们传送到一个新世界时一样。
//        // progressive样式完全取代了部分显示的直通。您可以使用这种风格让人们立足于现实世界，同时展示另一个世界的观点。
        .immersionStyle(selection: .constant(.full), in: .progressive, .mixed, .full)
    }
}

let logger = Logger()
