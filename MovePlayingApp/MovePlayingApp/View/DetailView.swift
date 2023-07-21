/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that display a simple inline video player with custom controls.
*/

import AVKit
import SwiftUI

struct DetailView: View {

    @Environment(PlayerModel.self) private var player
    @Environment(VideoLibrary.self) private var videoLibrary

    let margins = 30.0
    let video: Video

    var body: some View {
        HStack(alignment: .top, spacing: margins) {
            TrailerPosterView()
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(width: 620)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                VideoInfoView()
                HStack {
                    Group {
                        Button {
                            player.changePresentation(.fullScreen)
                        } label: {
                            Label("播放视频", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        Button {
                            print("添加到播放列表")
                        } label: {
                            Label("添加到播放列表",
                                  systemImage: "plus")
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 420)
                Spacer()
            }
        }
        .padding(margins)
    }
}



