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
  
  var scaleValue : Float = 1.0
  var isDrawingSectionEnabled: Bool = false
  var elementsArray: [MAGHexahedron] = []
  var centerPoint: SCNVector3 = SCNVector3Zero
  var minVector: SCNVector3 = SCNVector3Zero
  var maxVector: SCNVector3 = SCNVector3Zero
  var xyzArray: [SCNVector3] = []
  var xyz0Array: [SCNVector3] = []
  var nverArray: [[Int]] = []
  var nvkatArray: [Int] = []
  var neibArray: [[Int]] = []
  var sectionType: PlaneType = .X
  var sectionValue: Float = 0
  var materials: [MAGMaterial] = []
  var selectedMaterials: [MAGMaterial] = []
  
  func configure(project: MAGProject)
  {
    let documentsPath = (project.isLocal ? Bundle.main.resourcePath! : NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) + "/"
    xyzArray = self.fileManager.getXYZArray(path: documentsPath + project.xyzFilePath!)
    xyz0Array = self.fileManager.getXYZArray(path: documentsPath + project.xyz0FilePath!)
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
    elementsArray = []
    // TODO: Необходимо просматривать массив xyzArray, очень опасное поведение!
    minVector = SCNVector3Zero
    maxVector = SCNVector3Zero
    
    // минимумы и максимумы по осям
    minVector.x = xyzArray.min { (first, second) -> Bool in
      return first.x < second.x
      }!.x
    maxVector.x = xyzArray.max { (first, second) -> Bool in
      return first.x < second.x
      }!.x
    minVector.y = xyzArray.min { (first, second) -> Bool in
      return first.y < second.y
      }!.y
    maxVector.y = xyzArray.max { (first, second) -> Bool in
      return first.y < second.y
      }!.y
    minVector.z = xyzArray.min { (first, second) -> Bool in
      return first.z < second.z
      }!.z
    maxVector.z = xyzArray.max { (first, second) -> Bool in
      return first.z < second.z
      }!.z
    

    self.scaleValue = 1.0 / abs((maxVector.y - minVector.y) / 2.0)
    centerPoint = SCNVector3Make((maxVector.x - minVector.x) / 2.0 + minVector.x,
                                 (maxVector.y - minVector.y) / 2.0 + minVector.y,
                                 (maxVector.z - minVector.z) / 2.0 + minVector.z)
    
    let crossSection: MAGCrossSection = MAGCrossSection(plane: sectionType,
                                                        value: sectionValue,
                                                        greater: true)
    //let crossSection: MAGCrossSection = MAGCrossSection(plane: .Y, value: -4000 / xyzCalc, greater: false)
    
    self.colorGenerator.generateColor(minValue: self.colorGenerator.uFunc(x: Double(minVector.x),
                                                                          y: Double(minVector.y),
                                                                          z: Double(minVector.z)),
                                      maxValue: self.colorGenerator.uFunc(x: Double(maxVector.x),
                                                                          y: Double(maxVector.y),
                                                                          z: Double(maxVector.z)))
    

    var numberOfElement : Int = 0
    for i in 0..<nverArray.count
    {
      let positionArray = getNVERArrayFor(number: i)
      let isVisible = isDrawingSectionEnabled ? crossSection.setVisibleToHexahedron(positions: positionArray) : .isVisible
      
      let elementNeibsArray: [[Int]] = generateNeibsElementArray(number: i)
      
      
      let hexahedron = MAGHexahedron(positions: positionArray,
                                     neighbours: elementNeibsArray,
                                     material: nvkatArray[numberOfElement],
                                     //                                     color:self.colorGenerator.getColorsFor(vertexes: positionArray!))
                                     color: [self.getColor(material: nvkatArray[numberOfElement])])
      
      hexahedron.generateSides()
      // когда формируем hexahedronы смотрим их видимость
      
      hexahedron.visible = isVisible
      
      if isVisible == .isVisible
      {
        elementsArray.append(hexahedron)
      }
      numberOfElement = numberOfElement + 1
    }
  }
  
  
  private func getNVERArrayFor(number: Int) -> [SCNVector3]
  {
    var positionArray : [SCNVector3] = []
    var i : Int = 0
    
    for gridNum in nverArray[number]
    {
      if i < 8
      {
        let vector = xyzArray[gridNum - 1]
        positionArray.append(vector)
      }
      i = i + 1
    }
    return positionArray
  }
  
  private func generateNeibsElementArray(number: Int) -> [[Int]]
  {
    var elementNeibsArray: [[Int]] = []
    for numberOfSide in 0..<6
    {
      var neibs: [Int] = neibArray[6 * number + numberOfSide]
      var resNeibs: [Int] = []
      if (neibs.count >= 1) && (neibs[0] == 0)
      {
        resNeibs.append(0)
      }
      else
      {
        var neibsNumbers: [Int] = []
        for i in 0..<neibs[0]
        {
          // если материал соседа выключен, мы должны это учесть
          /** строка двумерного массива ELEM NEIB содержит:
           [количество соседей, номера соседей(нумерация соседей с единицы)]
           
           elementsMaterialsArray содержит:
           [номера материалов соседей]
           номера материалов соседей берутся из NVKAT
           
           NVKAT одномерный массив:
           
           nvkat[index] - номер материала
           
           index - номер соседа начиная с нуля
           */
          let index = self.nvkatArray[neibs[i + 1] - 1]
          if (!self.findInSelectedMaterials(numberOfMaterial: index))
          {
            //resNeibs.append(0)
            break
          }
          else
          {
            neibsNumbers.append(neibs[i + 1])
          }
        }
        resNeibs.append(neibsNumbers.count)
        resNeibs += neibsNumbers
      }
      
      elementNeibsArray.insert(resNeibs,
                               at: numberOfSide)
    }
    
    return elementNeibsArray
  }
  
  private func findInSelectedMaterials(numberOfMaterial: Int) -> Bool
  {
    for selectedMaterial in self.selectedMaterials
    {
      if (numberOfMaterial == selectedMaterial.numberOfMaterial)
      {
        return true
      }
    }
    return false
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

