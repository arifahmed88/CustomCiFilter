//
//  CIFilterModel.swift
//  FilterGenerate
//
//  Created by PosterMaker on 9/14/22.
//

import Foundation
import UIKit

enum filterName:String{
    case WrapFilter = "Wrap"
    case BangladeshFlagFilter = "BangladeshFlag"
    case ColorFilter = "Color"
    case ThreeDyeFilter = "ThreeDye"
    case BlackTransparentFilter = "BlackTransparent"
    case Unknown = "NoFilter"
}

class AllCustomCIFilter{
    
    var filters:[filterName] = []
    static var shared = AllCustomCIFilter()
    init(){
        createDummyData()
    }
    
    func createDummyData(){
        
        var filterName:filterName = .WrapFilter
        filters.append(filterName)
        
        filterName = .BangladeshFlagFilter
        filters.append(filterName)
        
        filterName = .ColorFilter
        filters.append(filterName)
        
        filterName = .ThreeDyeFilter
        filters.append(filterName)
        
        filterName = .BlackTransparentFilter
        filters.append(filterName)
    }
    
    func applyCustomFilter(filterType:filterName,image:UIImage?)->UIImage?{
        guard let newimage = image else { return nil }
        
        switch filterType{
        case .WrapFilter:
            let filter = WarpFilter()
            filter.inputImage = CIImage(image: newimage)
            guard let outputImage = filter.outputImage else {return nil}
            let filteredimage = UIImage(ciImage: outputImage)
            return filteredimage
        case .ColorFilter:
            let filter = ColorFilter()
            filter.inputImage = CIImage(image: newimage)
            guard let outputImage = filter.outputImage else {return nil}
            let filteredimage = UIImage(ciImage: outputImage)
            return filteredimage
            
        case .ThreeDyeFilter:
            let filter = ThreeDyeFilter()
            filter.inputImage = CIImage(image: newimage)
            guard let outputImage = filter.outputImage else {return nil}
            let filteredimage = UIImage(ciImage: outputImage)
            return filteredimage
        case .BangladeshFlagFilter:
            let filter = BangladeshFlagFilter()
            filter.inputImage = CIImage(image: newimage)
            guard let outputImage = filter.outputImage else {return nil}
            let filteredimage = UIImage(ciImage: outputImage)
            return filteredimage
        case .BlackTransparentFilter:
            let filter = BlackTransparentFilter()
            filter.inputImage = CIImage(image: newimage)
            guard let outputImage = filter.outputImage else {return nil}
            let filteredimage = UIImage(ciImage: outputImage)
            return filteredimage
        default:
            return nil
            
        }
    }
    
    
}
