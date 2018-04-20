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
  
   override init()
   {
      super.init()
      //createElementsArray()
   }
  
   func createElementsArray ()
   {
      xyzArray = MAGFileManager.sharedInstance.getXYZArray()
      nverArray = MAGFileManager.sharedInstance.getNVERArray()
      nvkatArray = MAGFileManager.sharedInstance.getNVKATArray()
      neibArray = MAGFileManager.sharedInstance.getNEIBArray()
      
      
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
      
      var crossSection: MAGCrossSection = MAGCrossSection(plane: .X, value: 1)
      
      let xyzCalc: Float = abs((maxVector.y - minVector.y) / 4.0)
      
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
         var sidesFlagsArray: [Bool] = [true, true, true, true, true, true]
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
         
         
         for numberOfSide in 0..<6
         {
            sidesFlagsArray[numberOfSide] = (neibArray[6 * numberOfElement + numberOfSide].count == 1)
         }
         
         let sidesArray: [MAGSide]? = [
            MAGSide.init(positions: [positionArray![0], positionArray![2], positionArray![6], positionArray![4]],
                         positionType: .Left,
                         material: nvkatArray[numberOfElement],
                         isVisible: sidesFlagsArray[0]), //левая
            MAGSide.init(positions: [positionArray![1], positionArray![0], positionArray![4], positionArray![5]],
                         positionType: .Front,
                         material: nvkatArray[numberOfElement],
                         isVisible: sidesFlagsArray[1]), //передняя
            MAGSide.init(positions: [positionArray![0], positionArray![1], positionArray![3], positionArray![2]],
                         positionType: .Bottom,
                         material: nvkatArray[numberOfElement],
                         isVisible: sidesFlagsArray[2]), //нижняя
            MAGSide.init(positions: [positionArray![1], positionArray![5], positionArray![7], positionArray![3]],
                         positionType: .Right,
                         material: nvkatArray[numberOfElement],
                         isVisible: sidesFlagsArray[3]), //правая
            MAGSide.init(positions: [positionArray![2], positionArray![3], positionArray![7], positionArray![6]],
                         positionType: .Back,
                         material: nvkatArray[numberOfElement],
                         isVisible: sidesFlagsArray[4]), //задняя
            MAGSide.init(positions: [positionArray![5], positionArray![4], positionArray![6], positionArray![7]],
                         positionType: .Top,
                         material: nvkatArray[numberOfElement],
                         isVisible: sidesFlagsArray[5]),  //верхняя
         ]
         
         let hexahedron = MAGHexahedron(positions: positionArray!,
                                        sidesArray: sidesArray!,
                                        material: nvkatArray[numberOfElement],
                                        //color:self.colorGenerator.getColorsFor(vertexes: positionArray!)))
                                        color: [self.getColor(material: nvkatArray[numberOfElement])])
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

