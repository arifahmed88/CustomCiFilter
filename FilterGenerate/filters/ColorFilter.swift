//
//  ColorFilter.swift
//  filtertest
//
//  Created by PosterMaker on 9/18/22.
//

// 1
import UIKit
import CoreImage

class ColorFilter: CIFilter {
  // 2
  var inputImage: CIImage?

  // 3
  static var kernel: CIKernel = { () -> CIColorKernel in
    guard let url = Bundle.main.url(
      forResource: "FilterKernel.ci",
      withExtension: "metallib"),
      let data = try? Data(contentsOf: url) else {
      fatalError("Unable to load metallib")
    }

    guard let kernel = try? CIColorKernel(
      functionName: "colorFilterKernel",
      fromMetalLibraryData: data) else {
      fatalError("Unable to create color kernel")
    }

    return kernel
  }()

  // 4
  override var outputImage: CIImage? {
    guard let inputImage = inputImage else { return nil }
    return ColorFilter.kernel.apply(
      extent: inputImage.extent,
      roiCallback: { _, rect in
        return rect
      },
      arguments: [inputImage])
  }
}
