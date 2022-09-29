//
//  FilterKernel.ci.metal
//  FilterGenerate
//
//  Created by PosterMaker on 9/21/22.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h>

using namespace metal;

float3 multiplyColors(float3, float3);

float3 multiplyColors(float3 mainColor, float3 colorMultiplier) { // (2)
    float3 color = float3(0,0,0);
    color.r = mainColor.r * colorMultiplier.r;
    color.g = mainColor.g * colorMultiplier.g;
    color.b = mainColor.b * colorMultiplier.b;
    return color;
};

//1
extern "C" {
    namespace coreimage {
        //2
        
        float4 makeBlackTransparent(sample_t sample, float threshold) {
            float4 filtered = (sample.r < threshold && sample.g < threshold && sample.b < threshold) == true ? float4(0):float4(sample.r, sample.g, sample.b, sample.a);
            return filtered;
        }
        
        float2 warpFilter(destination dest) {
            float y = dest.coord().y + tan(dest.coord().y / 20) * 20;
            float x = dest.coord().x + tan(dest.coord().x/ 20) * 20;
            return float2(x,y);
        }
        
        float4 colorFilterKernel(sample_t s) {
          float4 swappedColor;
          swappedColor.r = s.g;
          swappedColor.g = s.b;
          swappedColor.b = s.r;
          swappedColor.a = s.a;
          return swappedColor;
        }
        

        float4 dyeInThree(sampler src, float3 redVector, float3 greenVector, float3 blueVector) {

            float2 pos = src.coord();
            float4 pixelColor = src.sample(pos);     // (4)
            
            float3 pixelRGB = pixelColor.rgb;
            
            float3 color = float3(0,0,0);
            if (pos.y < 0.33) {                      // (5)
                color = multiplyColors(pixelRGB, redVector);
            } else if (pos.y >= 0.33 && pos.y < 0.66) {
                color = multiplyColors(pixelRGB, greenVector);
            } else {
                color = multiplyColors(pixelRGB, blueVector);
            }

            return float4(color, 1.0);
        }
        
        float4 bangladeshFlag(sampler src, float3 redVector, float3 greenVector, float3 blueVector) {

            float2 pos = src.coord();
            float4 pixelColor = src.sample(pos);     // (4)
            
            float3 pixelRGB = pixelColor.rgb;
            
            float3 color = float3(0,0,0);
            
            float2 center = float2(0.5,0.5);
            
            float x = (pos.x - center[0])*(pos.x - center[0]);
            float y = (pos.y - center[1])*(pos.y - center[1]);
            
            float ans = sqrt(x+y);
            
            if (ans<= 0.2 ){
                color = multiplyColors(pixelRGB, redVector);
            }
            else {
                color = multiplyColors(pixelRGB, greenVector);
            }
            return float4(color, 1.0);
        }
        
        
        
    }
}



