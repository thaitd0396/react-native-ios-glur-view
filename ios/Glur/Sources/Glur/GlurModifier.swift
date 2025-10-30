//
//  GlurModifier.swift
//  
//
//  Created by João Gabriel Pozzobon dos Santos on 09/02/24.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, visionOS 1.0, *)
internal struct GlurModifier: ViewModifier {
    public var radius: CGFloat
    public var offset: CGFloat
    public var interpolation: CGFloat
    public var direction: BlurDirection
    public var noise: CGFloat
    public var drawingGroup: Bool
    
    @State var size: CGSize = .zero
    
    @Environment(\.layoutDirection) var layoutDirection
    
    var evaluatedDirection: BlurDirection.Evaluated {
        direction.evaluate(with: layoutDirection)
    }
    
    let library = ShaderLibrary.bundle(.main)
    
    var blurX: Shader {
        var shader = library.blurX(.float(radius),
                                   .float(offset),
                                   .float(interpolation),
                                   .float(Float(evaluatedDirection.rawValue)),
                                   .float2(size))
        shader.dithersColor = true
        return shader
    }
    
    var blurY: Shader {
        var shader = library.blurY(.float(radius),
                                   .float(offset),
                                   .float(interpolation),
                                   .float(Float(evaluatedDirection.rawValue)),
                                   .float2(size))
        shader.dithersColor = true
        return shader
    }
    
    var noiseShader: Shader {
        var shader = library.noise(.float(noise),
                                    .float(offset),
                                    .float(interpolation),
                                    .float(Float(evaluatedDirection.rawValue)),
                                    .float2(size))
        shader.dithersColor = true
        return shader
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        if radius.isZero {
            content
        } else {
            Group {
                if drawingGroup {
                    content.drawingGroup()
                } else {
                    content
                }
            }
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
                .allowsHitTesting(false)
            }
            .onPreferenceChange(SizePreferenceKey.self) { size in
                self.size = size
            }
            .layerEffect(blurX, maxSampleOffset: .zero)
            .layerEffect(blurY, maxSampleOffset: .zero)
            .layerEffect(noiseShader, maxSampleOffset: .zero)
        }
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
