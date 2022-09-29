//
//  LumaThresholdFilter.swift
//  FilterGenerate
//
//  Created by PosterMaker on 9/15/22.
//

import Foundation
import CoreImage
import UIKit
class LumaThresholdFilter: CIFilter
{
    var threshold: CGFloat = 0.5
    
//    static let thresholdKernel = CIColorKernel(source:"""
//kernel vec4 thresholdFilter(__sample image, float threshold)
//{
//    float luma = (image.r * 0.2126) + (image.g * 0.7152) + (image.b * 0.0722);
//    return (luma > threshold) ? vec4(1.0, 1.0, 1.0, 1.0) : vec4(0.0, 0.0, 0.0, 0.0);
//}
//""")!
    
    //
    
    @objc dynamic var inputImage : CIImage?
    
    override var outputImage : CIImage!
    {
        guard let inputImage = self.inputImage else
        {
            return nil
        }
        
        let arguments = [inputImage, Float(self.threshold)] as [Any]
        
        return Self.thresholdKernel.apply(extent: inputImage.extent, arguments: arguments)
    }
    
    
    static var thresholdKernel: CIColorKernel = { () -> CIColorKernel in
//        let url = Bundle.main.url(forResource: "LumaThreshold", withExtension: "ci.metallib")!
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        
        do {
            return try CIColorKernel(functionName: "lumaThreshold", fromMetalLibraryData: data)
        }
        catch {
            print("\(error)")
            fatalError("\(error)")
        }
    }()
    
}
