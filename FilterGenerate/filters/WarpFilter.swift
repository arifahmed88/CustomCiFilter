import CoreImage

// 1
class WarpFilter: CIFilter {
  var inputImage: CIImage?
  // 2
  static var kernel: CIWarpKernel = { () -> CIWarpKernel in
    guard let url = Bundle.main.url(
      forResource: "FilterKernel.ci",
      withExtension: "metallib"),
    let data = try? Data(contentsOf: url) else {
      fatalError("Unable to load metallib")
    }

    guard let kernel = try? CIWarpKernel(
      functionName: "warpFilter",
      fromMetalLibraryData: data) else {
      fatalError("Unable to create warp kernel")
    }

    return kernel
  }()

  // 3
  override var outputImage: CIImage? {
    guard let inputImage = inputImage else { return .none }

    return WarpFilter.kernel.apply(
      extent: inputImage.extent,
      roiCallback: { _, rect in
        return rect
      },
      image: inputImage,
      arguments: [])
  }
}
