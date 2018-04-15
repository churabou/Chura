//
//  UIImage+Extension.swift
//  ChuraImage
//
//  Created by ちゅーたつ on 2018/04/15.
//  Copyright © 2018年 ちゅーたつ. All rights reserved.
//

import UIKit

extension UIImage {
    
    func createCIImage() -> CIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        return CIImage(cgImage: cgImage)
    }
    
    //blurTool splashTool textTool
    func maskedWith(image: UIImage) -> UIImage? {
        
        guard let maskData = image.cgImage else {
            fatalError("maskImage does not have cgImage")
        }
        
        if let mask: CGImage = CGImage(maskWidth: maskData.width,
                                       height: maskData.height,
                                       bitsPerComponent: maskData.bitsPerComponent,
                                       bitsPerPixel: maskData.bitsPerPixel,
                                       bytesPerRow: maskData.bytesPerRow,
                                       provider: maskData.dataProvider!,
                                       decode: nil,
                                       shouldInterpolate: false) {
            let masked = self.cgImage?.masking(mask)
            
            return UIImage(cgImage: masked!)
        }
        else {
            return nil
        }
    }
    
    //blurTool
    func discBlured(radius: CGFloat) -> UIImage {
        
        let inputImage = CIImage(cgImage: self.cgImage!)
        
        let filter = CIFilter(name: "CIDiscBlur")!
        filter.setValue(inputImage.affinClamp, forKey: "inputImage")
        filter.setValue(radius, forKey: "inputRadius")
        
        guard let blurredImage = filter.outputImage else {
            fatalError("failed to output with CIDiscBlur ")
        }
        
        let cropFilter = CIFilter(name: "CICrop")!
        let originalRect = inputImage.extent
        cropFilter.setValue(blurredImage, forKey: kCIInputImageKey)
        cropFilter.setValue(originalRect, forKey: "inputRectangle")
        guard let croppedImage = cropFilter.outputImage else {
            fatalError("failed to output with CICrop ")
        }
        
        let context = CIContext()
        let imageRef = context.createCGImage(croppedImage, from: croppedImage.extent)!
        return UIImage(cgImage: imageRef)
    }
}


extension CIImage  {
    
    //blurなど
    var affinClamp: CIImage {
        
        let affineClampFilter = CIFilter(name: "CIAffineClamp")!
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        affineClampFilter.setValue(self, forKey: kCIInputImageKey)
        affineClampFilter.setValue(transform, forKey: kCIInputTransformKey)
        guard let affineClampedImage = affineClampFilter.outputImage else {
            fatalError("failed to output with CIAffineClamp ")
        }
        
        return affineClampedImage
    }
}

extension CIImage {
    
    func createUIImage() -> UIImage {
        let context = CIContext()
        guard let cgImage = context.createCGImage(self, from: extent) else {
            fatalError("failed to create cgImage from ciImage")
        }
        return UIImage(cgImage: cgImage)
    }
}
