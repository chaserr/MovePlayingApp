//
//  PlayerModel.swift
//  Created on 2023/6/29
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2023 Zepp Health. All rights reserved.
//  @author tongxing(tongxing@zepp.com)   
//

import AVKit
import Observation
import Combine
import UIKit

enum Presentation {
    case inline
    case fullScreen
}

@Observable class PlayerModel {
//    let player = AVPlayer(url: URL(string: "http://playgrounds-cdn.apple.com/assets/beach/index.m3u8")!)
//    let player = AVPlayer(url: Bundle.main.url(forResource: "ElephantSeals", withExtension: "mp4")!)
    let player = AVPlayer(url: Bundle.main.url(forResource: "example-avatar", withExtension: "mp4")!)

    private(set) var isPlaying = false
    private(set) var presentation: Presentation = .inline
    private var playerViewController: AVPlayerViewController? = nil
    private var playerViewControllerDelegate: AVPlayerViewControllerDelegate? = nil

    init() {
        let experience: AVAudioSessionSpatialExperience = .headTracked(
            soundStageSize: .small,
            anchoringStrategy: .front
        )
        try? AVAudioSession.sharedInstance().setIntendedSpatialExperience(experience)
        Task {
            await configureAudioSession()
        }
    }

    func changePresentation(_ presentation: Presentation) {
        self.presentation = presentation
        do {
            let experience: AVAudioSessionSpatialExperience
            switch presentation {
            case .inline:
                // 对于内联播放器视图，它将体验设置为一个小型的前置声场，其中音频来自人对前方的感知。
                experience = .headTracked(soundStageSize: .small, anchoringStrategy: .front)
            case .fullScreen:
                // 全屏显示视频时，它会指定自动设置，让系统优化体验以最适合视频演示。
                experience = .headTracked(soundStageSize: .automatic, anchoringStrategy: .automatic)
            }
            try AVAudioSession.sharedInstance().setIntendedSpatialExperience(experience)
        } catch {
            logger.error("Unable to set the intended spatial experience. \(error.localizedDescription)")
        }
    }

    func makePlayerViewController() -> AVPlayerViewController {
        let delegate = PlayerViewControllerDelegate(player: self)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.delegate = delegate

        playerViewControllerDelegate = delegate

        return controller
    }

    func reset() {
        player.replaceCurrentItem(with: nil)
        playerViewControllerDelegate = nil
        // Reset the presentation state on the next cycle of the run loop.
        Task { @MainActor in
            presentation = .inline
        }
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func togglePlayback() {
        player.timeControlStatus == .paused ? play() : pause()
    }

    func createMetadataItems(for video: Video) -> [AVMetadataItem] {
        let mapping: [AVMetadataIdentifier: Any] = [
            .commonIdentifierTitle: video.title,
            .commonIdentifierArtwork: video.imageData,
            .commonIdentifierDescription: video.description,
            .commonIdentifierCreationDate: video.info.releaseDate,
            .iTunesMetadataContentRating: video.info.contentRating,
            .quickTimeMetadataGenre: video.info.genres
        ]
        return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
    }

    private func createMetadataItem(
        for identifier: AVMetadataIdentifier,
        value: Any
    ) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        // 指定未定义语言
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }

    private func configureAudioSession() async {
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for playback. Set the `moviePlayback` mode
            // to reduce the audio's dynamic range to help normalize audio levels.
            try session.setCategory(.playback, mode: .moviePlayback)
        } catch {
            logger.error("Unable to configure audio session: \(error.localizedDescription)")
        }
    }
}

final class PlayerViewControllerDelegate: NSObject, AVPlayerViewControllerDelegate {

    let player: PlayerModel

    init(player: PlayerModel) {
        self.player = player
    }

    func playerViewController(_ playerViewController: AVPlayerViewController,
                              willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        Task { @MainActor in
            player.changePresentation(.inline)
        }
    }
}
