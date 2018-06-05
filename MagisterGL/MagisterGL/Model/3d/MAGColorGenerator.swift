//
//  MAGColorGenerator.swift
//  MagisterGL
//
//  Created by Admin on 18.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

class MAGColorGenerator: NSObject
{
   private static let kCountOfColorAreas: Int = 255
   var rainbow: [MAGColor] = []
  
   
   func generateColor(minValue: Double, maxValue: Double)
   {
      let hValues: Double = (maxValue - minValue) / Double(MAGColorGenerator.kCountOfColorAreas - 1)
      for i in 0..<MAGColorGenerator.kCountOfColorAreas
      {
         let color = MAGColor()
         color.value = minValue + Double(i) * hValues
         rainbow.append(color)
      }
      
      let colorRedMin: Double = 255
      let colorGreenMin: Double = 0
      let colorBlueMin: Double = 0
      
      let colorRedMax: Double = 0
      let colorGreenMax: Double = 255
      let colorBlueMax: Double = 25
      
      rainbow[MAGColorGenerator.kCountOfColorAreas - 1].red = colorRedMax
      rainbow[MAGColorGenerator.kCountOfColorAreas - 1].green = colorGreenMax
      rainbow[MAGColorGenerator.kCountOfColorAreas - 1].blue = colorBlueMax
      
      let colorRedH: Double = (colorRedMax - colorRedMin) / Double(MAGColorGenerator.kCountOfColorAreas - 1)
      let colorGreenH: Double = (colorGreenMax - colorGreenMin) / Double(MAGColorGenerator.kCountOfColorAreas - 1)
      let colorBlueH: Double = (colorBlueMax - colorBlueMin) / Double(MAGColorGenerator.kCountOfColorAreas - 1)
      for i in 0..<MAGColorGenerator.kCountOfColorAreas
      {
         rainbow[i].red = colorRedMin + Double(i) * colorRedH
         rainbow[i].green = colorGreenMin + Double(i) * colorGreenH
         rainbow[i].blue = colorBlueMin + Double(i) * colorBlueH
      }
   }
  
   func getColorForU(u: Double) -> SCNVector3
   {
      var i = 0
      while i < MAGColorGenerator.kCountOfColorAreas - 1 && u >= rainbow[i + 1].value
      {
         i += 1
      }
      return rainbow[i].colorVector;
   }
}
