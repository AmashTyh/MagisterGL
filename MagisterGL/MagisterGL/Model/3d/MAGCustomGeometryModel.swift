//
//  MAGCustomGeometryModel.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit


class MAGCustomGeometryModel: NSObject
{
  let fileManager: MAGFileManager = MAGFileManager()
  
  var isShowMaterials = true
  var colorGenerator = MAGColorGenerator()
  
  var elementsArray: [MAGHexahedron] = []
  var centerPoint: SCNVector3 = SCNVector3Zero
  var minVector: SCNVector3 = SCNVector3Zero
  var maxVector: SCNVector3 = SCNVector3Zero
  var xyzArray: [SCNVector3] = []
  var nverArray: [[Int]] = []
  var nvkatArray: [Int] = []
  var neibArray: [[Int]] = []
  
  func runTest()
  {
    xyzArray = MAGFileManager.sharedInstance.getXYZArray()
    nverArray = MAGFileManager.sharedInstance.getNVERArray()
    nvkatArray = MAGFileManager.sharedInstance.getNVKATArray()
    neibArray = MAGFileManager.sharedInstance.getNEIBArray()
    
    createElementsArray()
  }
  
  func configure(project: MAGProject)
  {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
    xyzArray = self.fileManager.getXYZArray(path: documentsPath + project.xyzFilePath!)
    nverArray = self.fileManager.getNVERArray(path: documentsPath + project.nverFilePath!)
    nvkatArray = self.fileManager.getNVKATArray(path: documentsPath + project.nvkatFilePath!)
    neibArray = self.fileManager.getNEIBArray(path: documentsPath + project.elemNeibFilePath!)
    
    createElementsArray()
  }
  
  func createElementsArray ()
  {
    // TODO: Необходимо просматривать массив xyzArray, очень опасное поведение!
    minVector = xyzArray.first!
    maxVector = xyzArray.last!
    
    // минимумы и максимумы по осям
    let minX = xyzArray.min { (first, second) -> Bool in
      return first.x < second.x
      }!.x
    let maxX = xyzArray.max { (first, second) -> Bool in
      return first.x < second.x
      }!.x
    let minY = xyzArray.min { (first, second) -> Bool in
      return first.y < second.y
      }!.y
    let maxY = xyzArray.max { (first, second) -> Bool in
      return first.y < second.y
      }!.y
    let minZ = xyzArray.min { (first, second) -> Bool in
      return first.z < second.z
      }!.z
    let maxZ = xyzArray.max { (first, second) -> Bool in
      return first.z < second.z
      }!.z
    
    self.colorGenerator.generateColor(minValue: self.colorGenerator.uFunc(x: Double(minX), y: Double(minY), z: Double(minZ)),
                                      maxValue: self.colorGenerator.uFunc(x: Double(maxX), y: Double(maxY), z: Double(maxZ)))
    
    let xyzCalc: Float = abs((maxVector.y - minVector.y) / 4.0)
    let crossSection: MAGCrossSection = MAGCrossSection(plane: .Y, value: -4000 / xyzCalc, greater: false)
    
    var arrayOfVectors: [SCNVector3]? = []
    for xyz in xyzArray
    {
      let vector = SCNVector3Make(Float(xyz.x / xyzCalc),
                                  Float(xyz.y / xyzCalc),
                                  Float(xyz.z / xyzCalc))
      arrayOfVectors?.append(vector)
    }
    xyzArray = arrayOfVectors!
    minVector = xyzArray.first!
    maxVector = xyzArray.last!
    
    var countArray = Array(repeating: 0, count: 100000)
    for nver in nverArray
    {
      var i : Int = 0
      for grid in nver
      {
        if i < 8
        {
          countArray[grid - 1] += 1
        }
        else
        {
          break
        }
        i = i + 1
      }
    }
    var j : Int = 0
    var numberOfElement : Int = 0
    for nverElementArray in nverArray
    {
      var positionArray : [SCNVector3]? = []
      var materialsArray: [Int] = []
      var i : Int = 0
      
      for gridNum in nverElementArray
      {
        if i < 8
        {
          let vector = xyzArray[gridNum - 1]
          positionArray?.append(vector)
        }
        else
        {
          materialsArray.append(gridNum)
        }
        i = i + 1
      }
      j = j + 1
      
      var elementNeibsArray: [[Int]] = []
      for numberOfSide in 0..<6 {
        elementNeibsArray.insert(neibArray[6 * numberOfElement + numberOfSide], at: numberOfSide)
      }
      
      let hexahedron = MAGHexahedron(positions: positionArray!,
                                     neighbours: elementNeibsArray,
                                     material: nvkatArray[numberOfElement],
                                     //color:self.colorGenerator.getColorsFor(vertexes: positionArray!)))
                                     color: [self.getColor(material: nvkatArray[numberOfElement])])
      
      hexahedron.generateSides()
      // когда формируем hexahedronы смотрим их видимость
      hexahedron.visible = crossSection.setVisibleToHexahedron(positions: positionArray!)
      elementsArray.append(hexahedron)
      numberOfElement = numberOfElement + 1
    }
    centerPoint = SCNVector3Make((maxVector.x - minVector.x) / 2.0 + minVector.x,
                                 (maxVector.y - minVector.y) / 2.0 + minVector.y,
                                 (maxVector.z - minVector.z) / 2.0 + minVector.z)
  }
  
  // TODO: Надо сделать цвета кастомизируемыми(хотя бы из файла).
  private func getColor(material: Int) -> SCNVector3
  {
    if material == 0 {
      return SCNVector3(0.5, 0, 0)
    }
    if material == 1 {
      return SCNVector3(1, 0, 0)
    }
    if material == 2 {
      return SCNVector3(0, 1, 0)
    }
    if material == 3 {
      return SCNVector3(0, 0, 1)
    }
    if material == 4 {
      return SCNVector3(1, 0, 1)
    }
    if material == 5 {
      return SCNVector3(1, 0.5, 0)
    }
    if material == 6 {
      return SCNVector3(1, 0, 0)
    }
    return SCNVector3(1, 0, 0.5)
  }
}

