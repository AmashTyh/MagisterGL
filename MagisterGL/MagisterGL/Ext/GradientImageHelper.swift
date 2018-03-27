//
//  UIImage+Gradient.swift
//  MagisterGL
//
//  Created by Admin on 27.03.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class GradientImageHelper: NSObject {
  
  func gradientImage(size: CGSize,
                     topColorLeft: CIColor,
                     topColorRight: CIColor,
                     bottomColorLeft: CIColor,
                     bottomColorRight: CIColor) -> UIImage
  {
    UIGraphicsBeginImageContext(size)
    let currentContext = UIGraphicsGetCurrentContext()
    
    currentContext!.saveGState();
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let col1: [CGFloat] = [topColorLeft.components[0], topColorLeft.components[1], topColorLeft.components[2], topColorLeft.components[3],
                           bottomColorRight.components[0], bottomColorRight.components[1], bottomColorRight.components[2], bottomColorRight.components[3]]
    let grad1 = CGGradient(colorSpace: colorSpace, colorComponents: col1, locations: nil, count: 2)
    currentContext?.drawLinearGradient(grad1!,
                                       start: CGPoint(x: 0, y: size.height),
                                       end: CGPoint(x: size.width, y: 0),
                                       options: [])
    let col2: [CGFloat] = [bottomColorLeft.components[0], bottomColorLeft.components[1], bottomColorLeft.components[2], bottomColorLeft.components[3],
                           topColorRight.components[0], topColorRight.components[1], topColorRight.components[2], topColorRight.components[3]]
    let grad2 = CGGradient(colorSpace: colorSpace, colorComponents: col2, locations: nil, count: 2)
    currentContext?.drawLinearGradient(grad2!,
                                       start: CGPoint(x: 0, y: 0),
                                       end: CGPoint(x: size.width, y: size.height),
                                       options: [])
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image!
  }
  
}
