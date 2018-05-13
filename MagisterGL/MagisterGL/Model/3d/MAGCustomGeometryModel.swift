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
  //TODO: массив материалов из Sigma, массив выбранных материалов
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
  var xyzCalc: Float = 1
  var sectionType: PlaneType = .X
  var sectionValue: Float = 0
  var materials: [MAGMaterial] = []
  var selectedMaterials: [MAGMaterial] = []
  
  func configure(project: MAGProject)
  {
    let documentsPath = (project.isLocal ? Bundle.main.resourcePath! : NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) + "/"
    xyzArray = self.fileManager.getXYZArray(path: documentsPath + project.xyzFilePath!)
    nverArray = self.fileManager.getNVERArray(path: documentsPath + project.nverFilePath!)
    nvkatArray = self.fileManager.getNVKATArray(path: documentsPath + project.nvkatFilePath!)
    neibArray = self.fileManager.getNEIBArray(path: documentsPath + project.elemNeibFilePath!)
    let sig3dArray = self.fileManager.getSig3dArray(path: documentsPath + project.sigma3dPath!)
    if sig3dArray.count > 0
    {
      for i in 0..<sig3dArray.count
      {
        //TODO: Генерировать цвет в зависимости от сигма
        let materialNumber = Int(sig3dArray[i][0])
        let material = MAGMaterial.init(numberOfMaterial: materialNumber,
                                        color: self.getUIColor(material: materialNumber))
        self.materials.append(material)
      }
    }
    else
    {
      //TODO: Добавить всем тестам файл Sig3d
      let set = NSMutableSet()
      for nvkat in nvkatArray
      {
        set.add(nvkat)
      }
      for materialNumber in set
      {
        let material = MAGMaterial.init(numberOfMaterial: materialNumber as! Int,
                                        color: self.getUIColor(material: materialNumber as! Int))
        self.materials.append(material)
      }
    }
    self.selectedMaterials  = self.materials
    
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
    

    
    self.xyzCalc = abs((maxVector.y - minVector.y) / 2.0)
    let crossSection: MAGCrossSection = MAGCrossSection(plane: .X, value: sectionValue / xyzCalc, greater: false)
    //let crossSection: MAGCrossSection = MAGCrossSection(plane: .Y, value: -4000 / xyzCalc, greater: false)
    
    self.colorGenerator.generateColor(minValue: self.colorGenerator.uFunc(x: Double(minVector.x / xyzCalc),
                                                                          y: Double(minVector.y / xyzCalc),
                                                                          z: Double(minVector.z / xyzCalc)),
                                      maxValue: self.colorGenerator.uFunc(x: Double(maxVector.x / xyzCalc),
                                                                          y: Double(maxVector.y / xyzCalc),
                                                                          z: Double(maxVector.z / xyzCalc)))
    
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
      var elementMaterialsNeibsArray: [[Int]] = []
      for numberOfSide in 0..<6
      {
        elementNeibsArray.insert(neibArray[6 * numberOfElement + numberOfSide],
                                 at: numberOfSide)
      }
      
      /** строка двумерного массива ELEM NEIB содержит:
       [количество соседей, номера соседей(нумерация соседей с единицы)]
       
       elementsMaterialsArray soderzhit:
       [nomera materialov sosedeyi]
       nomera materialov sosedeyi berutsya iz NVKAT
       
       NVKAT odnomernyi massiv:
       
       nvkat[index] - nomer materiala
       
       index - nomer soseda nachinaya s nulya
       */
      for numberOFside in 0..<6
      {
        var materialsArray: [Int] = []
        for index in 0..<elementNeibsArray[numberOFside][0]
        {
          let nvkatIndex = elementNeibsArray[numberOFside][index + 1] - 1
          //elementMaterialsNeibsArray.append(self.nvkatArray[index])
          materialsArray.append(self.nvkatArray[nvkatIndex])
        }
        elementMaterialsNeibsArray.append(materialsArray)
      }
      
      
      let hexahedron = MAGHexahedron(positions: positionArray!,
                                     neighbours: elementNeibsArray,
                                     material: nvkatArray[numberOfElement],
                                     neibsMaterials: elementMaterialsNeibsArray,
                                     selectedMaterials: selectedMaterials,
//                                     color:self.colorGenerator.getColorsFor(vertexes: positionArray!))
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
    switch material {
    case 0:
      return SCNVector3(0.5, 0, 0)
    case 1:
      return SCNVector3(1, 0, 0)
    case 2:
      return SCNVector3(0, 1, 0)
    case 3:
      return SCNVector3(0, 0, 1)
    case 4:
      return SCNVector3(1, 0, 1)
    case 5:
      return SCNVector3(1, 0.5, 0)
    case 6:
      return SCNVector3(0.2, 0.4, 1)
    case 7:
      return SCNVector3(0.8, 1, 0)
    case 8:
      return SCNVector3(0.4, 0, 1)
    case 9:
      return SCNVector3(0.4, 0.4, 0.4)
    case 10:
      return SCNVector3(1, 0.4, 0.5)
    case 11:
      return SCNVector3(0, 0.5, 0.5)
    case 12:
      return SCNVector3(0, 0.3, 0)
    case 13:
      return SCNVector3(0, 1, 0.5)
    case 14:
      return SCNVector3(1, 1, 0.5)
    case 15:
      return SCNVector3(1, 0.5, 0.5)
    default:
      return SCNVector3(0.6, 0.6, 0.6)
    }
  }
  
  private func getUIColor(material: Int) -> UIColor
  {
    let vector = self.getColor(material: material)
    return UIColor(displayP3Red: CGFloat(vector.x),
                   green: CGFloat(vector.y),
                   blue: CGFloat(vector.z),
                   alpha: 1.0)
  }
}

