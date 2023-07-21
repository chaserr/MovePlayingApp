/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that displays information about a video like its title, actors, and rating.
*/
import SwiftUI

struct VideoInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("视频标题")
                .font(.title)
                .padding(.bottom, 4)
            InfoLineView(year: "2023",
                         rating: "NR",
                         duration: "1m 1s")
                .padding([.bottom], 4)
            GenreView(genres: ["Drama", "Romance"])
                .padding(.bottom, 4)
            RoleView(role: String(localized: "Stars"), people: ["M. Seagull"])
                .padding(.top, 1)
            RoleView(role: String(localized: "Director"), people: ["R. Rock", "G. Seaglass"])
                .padding(.top, 1)
            RoleView(role: String(localized: "Writers"), people: ["N. Sand", "P. Sky", "J. Sun", "L. Windy"])
                .padding(.top, 1)
                .padding(.bottom, 12)
            Text("From an award-winning producer and actor, \"A Beach\" is a sweeping, awe-inspiring drama depicting waves crashing on a scenic California beach. Sit back and enjoy the sweet sounds of the ocean while relaxing on a soft, sandy beach.")
                .font(.headline)
                .padding(.bottom, 12)
        }
    }
}

/// A view that displays a horizontal list of the video's year, rating, and duration.
struct InfoLineView: View {
    let year: String
    let rating: String
    let duration: String
    var body: some View {
        HStack {
            Text("\(year) | \(rating) | \(duration)")
                .font(.subheadline.weight(.medium))
        }
    }
}

/// A view that displays a comma-separated list of genres for a video.
struct GenreView: View {
    let genres: [String]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(genres, id: \.self) {
                Text($0)
                    .fixedSize()
                #if os(xrOS)
                    .font(.caption2.weight(.bold))
                #else
                    .font(.caption)
                #endif
                    .padding([.leading, .trailing], 4)
                    .padding([.top, .bottom], 4)
                    .background(RoundedRectangle(cornerRadius: 5).stroke())
                    .foregroundStyle(.secondary)
            }
            // Push the list to the leading edge.
            Spacer()
        }
    }
}

/// A view that displays a name of a role, followed by one or more people who hold the position.
struct RoleView: View {
    let role: String
    let people: [String]
    var body: some View {
        VStack(alignment: .leading) {
            Text(role)
            Text(people.formatted())
                .foregroundStyle(.secondary)
        }
    }
}

//#if os(xrOS)
//#Preview {
//    VideoInfoView(video: .preview)
//        .padding()
//        .frame(width: 500, height: 500)
//        .background(.gray)
//        .previewLayout(.sizeThatFits)
//}
//#endif
