import UIKit
import SceneKit

class MAGColorGenerator: NSObject
{
   private let kCountOfColorAreas: Int = 255
   var rainbow: [Color] = []
  
  
  func generateColorForMaterials(minValue: Double, maxValue: Double)
  {
    var baseColors: [Color] = []
    var color = Color()
    color.red = 0
    color.green = 5
    color.blue = 255
    baseColors.append(color)
    
    color = Color()
    color.red = 0
    color.green = 255
    color.blue = 25
    baseColors.append(color)
    
    color = Color()
    color.red = 255
    color.green = 140
    color.blue = 0
    baseColors.append(color)
    
    color = Color()
    color.red = 255
    color.green = 0
    color.blue = 0
    baseColors.append(color)
    
    let hValues: Double = (maxValue - minValue) / Double(kCountOfColorAreas - 1)
    for i in 0..<kCountOfColorAreas
    {
      let color = Color()
      color.value = minValue + Double(i) * hValues
      rainbow.append(color)
    }
    
    let countOfColors = kCountOfColorAreas / (baseColors.count - 1)
    for j in 0..<baseColors.count - 1
    {
      let colorRedMin: Double = baseColors[j].red
      let colorGreenMin: Double = baseColors[j].green
      let colorBlueMin: Double = baseColors[j].blue
      
      let colorRedMax: Double = baseColors[j + 1].red
      let colorGreenMax: Double = baseColors[j + 1].green
      let colorBlueMax: Double = baseColors[j + 1].blue
      
      let maxCountOfColors = (j == baseColors.count - 2) ? kCountOfColorAreas : (countOfColors * (j + 1) + 1)
      rainbow[maxCountOfColors - 1].red = colorRedMax
      rainbow[maxCountOfColors - 1].green = colorGreenMax
      rainbow[maxCountOfColors - 1].blue = colorBlueMax
      
      let colorRedH: Double = (colorRedMax - colorRedMin) / Double(countOfColors - 1)
      let colorGreenH: Double = (colorGreenMax - colorGreenMin) / Double(countOfColors - 1)
      let colorBlueH: Double = (colorBlueMax - colorBlueMin) / Double(countOfColors - 1)
      for i in countOfColors * j..<maxCountOfColors
      {
        rainbow[i].red = colorRedMin + Double(i) * colorRedH
        rainbow[i].green = colorGreenMin + Double(i) * colorGreenH
        rainbow[i].blue = colorBlueMin + Double(i) * colorBlueH
      }
    }
  }
   
//   func uFunc(x: Double,
//              y: Double,
//              z: Double) -> Double
//   {
//      return (x + y) / 10
//   }
  
   func getColorForU(u: Double) -> SCNVector3
   {
      var i = 0
      while i < kCountOfColorAreas - 1 && u >= rainbow[i + 1].value
      {
         i += 1
      }
      return rainbow[i].colorVector;
   }
  
   
   func getColorsFor(vertexes: [SCNVector3]) -> [SCNVector3]
   {
      var colors: [SCNVector3] = []
      for vertex in vertexes {
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
  
  func getColorsFor(values: [Float]) -> [SCNVector3]
  {
    var colors: [SCNVector3] = []
    for u in values {
      var i = 0
      while i < kCountOfColorAreas - 1
        && Double(u) >= rainbow[i + 1].value
      {
        i += 1
      }
      colors.append(rainbow[i].colorVector)
    }
    return colors
  }
  
  func generateColorForSurface(minValue: Double, maxValue: Double)
  {
    let hValues: Double = (maxValue - minValue) / Double(kCountOfColorAreas - 1)
    for i in 0..<kCountOfColorAreas
    {
      let color = Color()
      color.value = minValue + Double(i) * hValues
      rainbow.append(color)
    }
    
    let colorRedMin: Double = 0
    let colorGreenMin: Double = 5
    let colorBlueMin: Double = 255
    
    let colorRedMax: Double = 0
    let colorGreenMax: Double = 255
    let colorBlueMax: Double = 25
    
    rainbow[kCountOfColorAreas - 1].red = colorRedMax
    rainbow[kCountOfColorAreas - 1].green = colorGreenMax
    rainbow[kCountOfColorAreas - 1].blue = colorBlueMax
    
    let colorRedH: Double = (colorRedMax - colorRedMin) / Double(kCountOfColorAreas - 1)
    let colorGreenH: Double = (colorGreenMax - colorGreenMin) / Double(kCountOfColorAreas - 1)
    let colorBlueH: Double = (colorBlueMax - colorBlueMin) / Double(kCountOfColorAreas - 1)
    for i in 0..<kCountOfColorAreas
    {
      rainbow[i].red = colorRedMin + Double(i) * colorRedH
      rainbow[i].green = colorGreenMin + Double(i) * colorGreenH
      rainbow[i].blue = colorBlueMin + Double(i) * colorBlueH
    }
  }
}
