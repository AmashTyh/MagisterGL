//
//  Color.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 12.06.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

@objc
class Color: NSObject
{
   var value: Double = 0.0
   var red: Double = 0
   var green: Double = 0
   var blue: Double = 0
  
   @objc
   public var color: UIColor
   {
      get
      {
         return UIColor(red: CGFloat(red / 255.0),
                        green:  CGFloat(green / 255.0),
                        blue: CGFloat(blue / 255.0),
                        alpha: 1.0)
      }
   }
  
   @objc
   public var colorVector: SCNVector3
   {
      get
      {
          return SCNVector3Make(Float(red / 255.0), Float(green / 255.0), Float(blue / 255.0))
      }
   }
  
   @objc
   override init()
   {
   }
}
