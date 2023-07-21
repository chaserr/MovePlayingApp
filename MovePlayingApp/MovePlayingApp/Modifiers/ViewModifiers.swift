/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Custom view modifiers that the app defines.
*/

import SwiftUI

extension View {
    func updateImmersionOnChange(of path: Binding<[Video]>, isPresentingSpace: Binding<Bool>) -> some View {
        self.modifier(ImmersiveSpacePresentationModifier(navigationPath: path, isPresentingSpace: isPresentingSpace))
    }
}

private struct ImmersiveSpacePresentationModifier: ViewModifier {
    
    @Environment(\.openImmersiveSpace) private var openSpace
    @Environment(\.dismissImmersiveSpace) private var dismissSpace

    @Binding var navigationPath: [Video]
    @Binding var isPresentingSpace: Bool
    
    func body(content: Content) -> some View { content
        .onChange(of: navigationPath) {
            Task {
                if navigationPath.isEmpty {
                    if isPresentingSpace {
                        await dismissSpace()
                        isPresentingSpace = false
                    }
                } else {
                    guard !isPresentingSpace else { return }
                    guard let video = navigationPath.first else { fatalError() }
                    switch await openSpace(id: "ImmersiveSpace") {
                    case .opened: isPresentingSpace = true
                    default: isPresentingSpace = false
                    }
                }
            }
        }
    }
}
