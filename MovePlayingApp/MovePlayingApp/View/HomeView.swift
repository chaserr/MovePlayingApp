//
//  HomeView.swift
//  Created on 2023/6/30
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import SwiftUI

struct HomeView: View {
    @Binding private var navigationPath: [Video]
    @Binding private var isPresentingSpace: Bool
    @Environment(VideoLibrary.self) private var video

    init(path: Binding<[Video]>, isPresentingSpace: Binding<Bool> = .constant(false)) {
        _navigationPath = path
        _isPresentingSpace = isPresentingSpace
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(alignment: .leading, spacing: 20) {
                NavigationLink(value: video.videos.first!) {
                    Text("进入详情页")
                }
            }
            .navigationDestination(for: Video.self) { video in
                DetailView(video: video)
                    .navigationTitle(video.title)
            }
        }
        .updateImmersionOnChange(of: $navigationPath, isPresentingSpace: $isPresentingSpace)
    }
}
