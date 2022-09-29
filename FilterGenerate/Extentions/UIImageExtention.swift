//
//  UIImageExtention.swift
//  FilterGenerate
//
//  Created by PosterMaker on 9/22/22.
//

import UIKit

extension UIImage {
    func rotateCameraImageToProperOrientation(maxResolution : CGFloat = 320) -> UIImage? {
        
        let imageSource = self
        
        guard let imgRef = imageSource.cgImage else {
            return nil
        }
        
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            scaleRatio = 1.0
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        
        switch(imageSource.imageOrientation) {
        case .up:
            transform = .identity
        case .upMirrored:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: 0)
                .scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: imageSize.height)
                .rotated(by: CGFloat.pi)
        case .downMirrored:
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.height)
                .scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.width)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: imageSize.width)
                .scaledBy(x: -1.0, y: 1.0)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: 0)
                .rotated(by: CGFloat.pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(scaleX: -1.0, y: 1.0)
                .rotated(by: CGFloat.pi / 2.0)
        @unknown default:
            print("rotation Unknown")
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            
            context.concatenate(transform)
            context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy
    }


}
