//
//  noise.metal
//
//
//  Created by João Gabriel Pozzobon dos Santos on 24/04/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float mapStrength(float2 position,
                float2 size,
                float offset,
                float interpolation,
                float strength,
                float direction) {
    float mapped = 0.0;
    
    if (direction == 0) {
        mapped = max((position.y/size.y-offset)/interpolation, 0.0);
    } else if (direction == 1) {
        mapped = max(0.5-(position.y/size.y-offset)/interpolation, 0.0);
    } else if (direction == 2) {
        mapped = max((position.x/size.x-offset)/interpolation, 0.0);
    } else if (direction == 3) {
        mapped = max(0.5-(position.x/size.x-offset)/interpolation, 0.0);
    }
    
    return min(mapped*strength, strength);
}

float overlay(float base, float blend) {
    return (base <= 0.5) ? (2.0*base*blend) : (1.0-2.0*(1.0-base)*(1.0-blend));
}

float rand(float2 st) {
    return fract(sin(dot(st.xy,
                         float2(12.9898,78.233)))*
                 43758.5453123);
}

[[ stitchable ]] half4 noise(float2 position,
                             SwiftUI::Layer layer,
                             float strength,
                             float offset,
                             float interpolation,
                             float direction,
                             float2 size) {
    float s = mapStrength(position,
                        size,
                        offset,
                        interpolation,
                        strength,
                        direction);
    
    float2 pos = position*10;
    float2 floored = floor(pos);
    
    float white = rand(floored)*0.5+0.5;
    half4 color = layer.sample(float2(position.x, position.y));
    
    float r = overlay(color.r, white);
    float g = overlay(color.g, white);
    float b = overlay(color.b, white);
    
    half4 newColor = half4(r, g, b, color.a);
    return mix(color, newColor, s);
}
