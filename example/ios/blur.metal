//
//  blur.metal
//  WWDCApp
//
//  Created by João Gabriel Pozzobon dos Santos on 06/06/23.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

#define kernelSize (64)

float mapRadius(float2 position,
                float2 size,
                float offset,
                float interpolation,
                float radius,
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
    
    return min(mapped*radius, radius);
}

void calculateGaussianWeights(float radius,
                              thread half weights[]) {
    half sum = 0.0;
    
    for (int i = 0; i < kernelSize; ++i) {
        float x = i-(kernelSize-1)/2;
        weights[i] = exp(-(x*x)/(2.0*radius*radius));
        sum+= weights[i];
    }
    
    for (int i = 0; i < kernelSize; ++i) {
        weights[i]/= sum;
    }
}

[[ stitchable ]] half4 blurX(float2 position,
                             SwiftUI::Layer layer,
                             float radius,
                             float offset,
                             float interpolation,
                             float direction,
                             float2 size) {
    float r = mapRadius(position,
                        size,
                        offset,
                        interpolation,
                        radius,
                        direction);
    
    if (r == 0) {
        return layer.sample(position);
    }
    
    half weights[kernelSize];
    calculateGaussianWeights(r, weights);
    
    half4 result = half4(0.0);
    for (int i = 0; i < kernelSize; ++i) {
        float offset = i-(kernelSize-1)/2;
        float x = clamp(position.x+offset, 0.0, size.x-1.0);
        
        result+= layer.sample(float2(x, position.y))*weights[i];
    }
    
    return result;
}

[[ stitchable ]] half4 blurY(float2 position,
                             SwiftUI::Layer layer,
                             float radius,
                             float offset,
                             float interpolation,
                             float direction,
                             float2 size) {
    float r = mapRadius(position,
                        size,
                        offset,
                        interpolation,
                        radius,
                        direction);
    
    if (r == 0) {
        return layer.sample(position);
    }
    
    half weights[kernelSize];
    calculateGaussianWeights(r, weights);
    
    half4 result = half4(0.0);
    for (int i = 0; i < kernelSize; ++i) {
        float offset = i-(kernelSize-1)/2;
        float y = clamp(position.y+offset, 0.0, size.y-1.0);
        
        result+= layer.sample(float2(position.x, y))*weights[i];
    }
    
    return result;
}
