/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view presents a 360° destination image in an immersive space.
*/

import SwiftUI
import RealityKit
import Combine
import RealityKitContent

/// A view that displays a 360 degree scene in which to watch video.
/// 将纹理映射到在人周围显示的球体内部
struct DestinationView: View {
    
    @State private var destinationChanged = false
    @State var model = BoxModel()
    @State var boxEntity = Entity()
    @State var fishEntity: Entity?


    var body: some View {
        RealityView { content in
            let realyEntity = Entity()
            realyEntity.addSkybox()
            content.add(realyEntity)
            content.add(model.setupContentEntity())
            boxEntity = model.addCube(name: "box1")
            fishEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle)
            if let fishEntity {
                content.add(fishEntity)
                if let lightURL = Bundle.main.url(forResource: "ImageBasedLight", withExtension: "exr"),
                   let lightSource = CGImageSourceCreateWithURL(lightURL as CFURL, nil),
                   let imageBasedLightImage = CGImageSourceCreateImageAtIndex(lightSource, 0, nil),
                   let lightResource = try? await EnvironmentResource.generate(fromEquirectangular: imageBasedLightImage) {
                    let imageBasedLightSource = ImageBasedLightComponent.Source.single(lightResource)

                    let imageBasedLight = Entity()
                    imageBasedLight.components.set(ImageBasedLightComponent(source: imageBasedLightSource))
                    content.add(imageBasedLight)

                    fishEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: imageBasedLight))
                }
            }
        }
        .transition(.opacity)
        .gesture(
            DragGesture()
                .targetedToEntity(boxEntity)
                .onChanged { value in
                    boxEntity.position = value.convert(value.location3D, from: .local, to: boxEntity.parent!)
                }
        )
        .gesture(
            SpatialTapGesture()
                .targetedToEntity(boxEntity)
                .onEnded { value in
                    // print(value)
                    model.changeToRandomColor(entity: boxEntity)
                }
        )
        .gesture(TapGesture().targetedToAnyEntity().onEnded({ value in
            var transform = value.entity.transform
            transform.translation += SIMD3(0.2, 0, 0)
            value.entity.move(to: transform, relativeTo: nil, duration: 3, timingFunction: .easeInOut)
        }))
    }
}

extension Entity {
    func addSkybox() {
        let subscription = TextureResource.loadAsync(named: "hillside_scene").sink(
            receiveCompletion: {
                switch $0 {
                case .finished: break
                case .failure(let error): assertionFailure("\(error)")
                }
            },
            receiveValue: { [weak self] texture in
                guard let self = self else { return }
                var material = UnlitMaterial()
                material.color = .init(texture: .init(texture))
                // 创建实体视觉外观的资源集合。
                // 其中generateSphere是系统提供的创建一个具有指定半径的球体网格。 球体以实体原点为中心。 参数 球体的半径，单位为米。 返回:一个球体网格。 这里设置10的三次方，也就是1000米，相当于无限空间
                // materials是模型使用的材料
                self.components.set(ModelComponent(
                    mesh: .generateSphere(radius: 1E3),
                    materials: [material]
                ))
                // 指定实体的缩放因子
                self.scale *= .init(x: -1, y: 1, z: 1)
                // 设置实体沿 x、y 和 z 轴的位置。
                self.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
                
                // Rotate the sphere to show the best initial view of the space.
                updateRotation()
            }
        )
        components.set(Entity.SubscriptionComponent(subscription: subscription))
    }

    
    func updateRotation() {
        // Rotate the immersive space around the Y-axis set the user's
        // initial view of the immersive scene.
        let angle = Angle.degrees(0)
        let rotation = simd_quatf(angle: Float(angle.radians), axis: SIMD3<Float>(0, 1, 0))
        self.transform.rotation = rotation
    }
    
    /// A container for the subscription that comes from asynchronous texture loads.
    ///
    /// In order for async loading callbacks to work we need to store
    /// a subscription somewhere. Storing it on a component will keep
    /// the subscription alive for as long as the component is attached.
    struct SubscriptionComponent: Component {
        var subscription: AnyCancellable
    }
}

#Preview {
    DestinationView()
        .previewLayout(.sizeThatFits)
}
