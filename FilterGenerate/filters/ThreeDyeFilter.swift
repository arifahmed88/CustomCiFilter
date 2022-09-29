//
//  ThreeDyeFilter.swift
//  FilterGenerate
//
//  Created by PosterMaker on 9/15/22.
//

import Foundation
import CoreImage

class ThreeDyeFilter: CIFilter {
    var inputImage: CIImage?
    // 2
    static var kernel: CIKernel = { () -> CIKernel in
        guard let url = Bundle.main.url(
            forResource: "FilterKernel.ci",
            withExtension: "metallib"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load metallib")
        }

        guard let kernel = try? CIKernel(
            functionName: "dyeInThree",
            fromMetalLibraryData: data) else {
            fatalError("Unable to create color kernel")
        }
        return kernel
    }()
    
    // 3
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return .none }
        let reddish   = CIVector(x: 1.1, y: 0.1, z: 0.1)
        let greenish  = CIVector(x: 0.1, y: 1.1, z: 0.1)
        let blueish   = CIVector(x: 0.1, y: 0.1, z: 1.1)
        
        return ThreeDyeFilter.kernel.apply(extent: inputImage.extent, roiCallback: { _, rect in
            return rect
        }, arguments: [inputImage,reddish,greenish,blueish])
    }
}
