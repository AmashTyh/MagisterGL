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
  let kCountOfColorAreas: Int = 20
  var rainbow: [Color] = []
  var baseColors: [Color] = []
  
  func generateColor(minValue: Double, maxValue: Double)
  {
    var color = Color()
    color.red = 148
    color.green = 0
    color.blue = 211
    color = Color()
    baseColors.append(color)
    color.red = 75
    color.green = 0
    color.blue = 130
    color = Color()
    baseColors.append(color)
    color.red = 0
    color.green = 0
    color.blue = 255
    color = Color()
    baseColors.append(color)
    color.red = 0
    color.green = 255
    color.blue = 0
    color = Color()
    baseColors.append(color)
    color.red = 255
    color.green = 255
    color.blue = 0
    color = Color()
    baseColors.append(color)
    color.red = 255
    color.green = 127
    color.blue = 0
    color = Color()
    baseColors.append(color)
    color.red = 255
    color.green = 0
    color.blue = 0
    baseColors.append(color)
    
    let hValues: Double = (maxValue - minValue) / Double(kCountOfColorAreas * baseColors.count)
    for i in 0..<kCountOfColorAreas * baseColors.count
    {
      let color = Color()
      color.value = minValue + Double(i) * hValues
      rainbow.append(color)
    }
    for j in 0..<baseColors.count - 1
    {
      let colorRedMin: Double = baseColors[j].red
      let colorGreenMin: Double = baseColors[j].green
      let colorBlueMin: Double = baseColors[j].blue
      
      let colorRedMax: Double = baseColors[j + 1].red
      let colorGreenMax: Double = baseColors[j + 1].green
      let colorBlueMax: Double = baseColors[j + 1].blue
      
      rainbow[(j + 1)*kCountOfColorAreas].red = colorRedMax
      rainbow[(j + 1)*kCountOfColorAreas].green = colorGreenMax
      rainbow[(j + 1)*kCountOfColorAreas].blue = colorBlueMax
      
      let colorRedH: Double = (colorRedMax - colorRedMin) / Double(kCountOfColorAreas)
      let colorGreenH: Double = (colorGreenMax - colorGreenMin) / Double(kCountOfColorAreas)
      let colorBlueH: Double = (colorBlueMax - colorBlueMin) / Double(kCountOfColorAreas)
      for i in 0..<kCountOfColorAreas
      {
        rainbow[i + j*kCountOfColorAreas].red = colorRedMin + Double(i) * colorRedH
        rainbow[i + j*kCountOfColorAreas].green = colorGreenMin + Double(i) * colorGreenH
        rainbow[i + j*kCountOfColorAreas].blue = colorBlueMin + Double(i) * colorBlueH
      }
    }
    
//    let countOfColors = kCountOfColorAreas / (baseColors.count - 1)
//    for j in 0..<baseColors.count - 1
//    {
//      let colorRedMin: Double = baseColors[j].red
//      let colorGreenMin: Double = baseColors[j].green
//      let colorBlueMin: Double = baseColors[j].blue
//
//      let colorRedMax: Double = baseColors[j + 1].red
//      let colorGreenMax: Double = baseColors[j + 1].green
//      let colorBlueMax: Double = baseColors[j + 1].blue
//
//      let maxCountOfColors = (j == baseColors.count - 2) ? kCountOfColorAreas : (countOfColors * (j + 1) + 1)
//      rainbow[maxCountOfColors - 1].red = colorRedMax
//      rainbow[maxCountOfColors - 1].green = colorGreenMax
//      rainbow[maxCountOfColors - 1].blue = colorBlueMax
//
//      let colorRedH: Double = (colorRedMax - colorRedMin) / Double(countOfColors - 1)
//      let colorGreenH: Double = (colorGreenMax - colorGreenMin) / Double(countOfColors - 1)
//      let colorBlueH: Double = (colorBlueMax - colorBlueMin) / Double(countOfColors - 1)
//      for i in countOfColors * j..<maxCountOfColors
//      {
//        rainbow[i].red = colorRedMin + Double(i) * colorRedH
//        rainbow[i].green = colorGreenMin + Double(i) * colorGreenH
//        rainbow[i].blue = colorBlueMin + Double(i) * colorBlueH
//      }
//    }
  }
  
  func getColorForU(u: Double) -> SCNVector3
  {
    var i = 0
    while i < kCountOfColorAreas * baseColors.count - 1 && u >= rainbow[i + 1].value
    {
      i += 1
    }
    return rainbow[i].colorVector;
  }
  
  func getColorsFor(vertexes: [SCNVector3]) -> [SCNVector3]
  {
    var colors: [SCNVector3] = []
    for vertex in vertexes
    {
      var i = 0
      while i < kCountOfColorAreas - 1
        && MAGRecieversFuncGenerator.uFunc(x: Double(vertex.x), y: Double(vertex.y), z: Double(vertex.z)) >= rainbow[i + 1].value
      {
        i += 1
      }
      colors.append(rainbow[i].colorVector)
    }
    return colors
  }
}
