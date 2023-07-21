//
//  PlayView.swift
//  Created on 2023/6/27
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit
import RealityKit
import RealityKitContent

struct FullScreenPlayer: UIViewControllerRepresentable {

    @Environment(PlayerModel.self) private var model
    @Environment(VideoLibrary.self) private var video
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player?.currentItem?.externalMetadata = model.createMetadataItems(for: video.videos.first!)
        Task { @MainActor in
            if let upNextViewController {
                playerController.customInfoViewControllers = [upNextViewController]
            }

            if let upNextAction {
                playerController.contextualActions = [upNextAction]
            } else {
                playerController.contextualActions = []
            }
        }
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = model.makePlayerViewController()
        let infoCircle = UIImage(systemName: "info.circle")
        let showMoreInfo = UIAction(title: "展示更多信息", image: infoCircle) { action in
            print("展示更多信息")
        }
        if let upNextViewController {
            controller.customInfoViewControllers = [upNextViewController]
        }
        controller.infoViewActions.append(showMoreInfo)
        return controller
    }
}


extension FullScreenPlayer {
    var upNextViewController: UIViewController? {
        
        let view = UpNextView()
        let controller = UIHostingController(rootView: view)
        controller.title = "Next Video"
        controller.preferredContentSize = CGSize(width: 500, height: 150)
        return controller
    }

    var upNextAction: UIAction? {
        return UIAction(title: "Play Next", image: UIImage(systemName: "play.fill")) { _ in
            print("播放下一条视频")
        }
    }
}
