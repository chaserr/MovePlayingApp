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

struct InlinePlayerView: UIViewControllerRepresentable {

    @Environment(PlayerModel.self) private var model

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = model.makePlayerViewController()
        return controller
    }
}
