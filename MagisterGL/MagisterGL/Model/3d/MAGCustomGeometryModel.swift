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
  var showFieldNumber = -1
  var showTimeSlicesNumber = 10
  var colorGenerator: MAGColorGenerator?
  var project: MAGProject?
  
  var scaleValue : Float = 1.0
  var isDrawingSectionEnabled: Bool = false
  var elementsArray: [MAGHexahedron] = []
  //TODO: NSValue *value = [NSValue valueWithSCNVector3:vector]
  var centerPoint: SCNVector3 = SCNVector3Zero
  var minVector: SCNVector3 = SCNVector3Zero
  var maxVector: SCNVector3 = SCNVector3Zero
  var xyzArray: [SCNVector3] = []
  var fieldsArray: [[Double]] = []
  var nverArray: [[Int]] = []
  var nvkatArray: [Int] = []
  var neibArray: [[Int]] = []
  var sectionType: PlaneType = .X
  var sectionValue: Float = 0
  var greater: Bool = true
  var materials: [MAGMaterial] = []
  var selectedMaterials: [MAGMaterial] = []
  var crossSection: MAGCrossSection?
  var sig3dArray: [[Double]] = []
  var profileArray: [SCNVector3] = []
  var chartsData: MAGChartsData = MAGChartsData()
  var edsallArray: [[Float: Float]] = []
  var rnArray: [[Float]] = []
  
  var timeSlices: [Float] = []
  
  var receiversSurface: [MAGTriangleElement] = []
  
  
  func configure(project: MAGProject)
  {
    self.project = project
    
    let documentsPath = (project.isLocal ? Bundle.main.resourcePath! : NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) + "/"
    xyzArray = self.fileManager.getXYZArray(path: documentsPath + project.xyzFilePath!)
    nverArray = self.fileManager.getNVERArray(path: documentsPath + project.nverFilePath!)
    nvkatArray = self.fileManager.getNVKATArray(path: documentsPath + project.nvkatFilePath!)
    neibArray = self.fileManager.getNEIBArray(path: documentsPath + project.elemNeibFilePath!)
    sig3dArray = self.fileManager.getSig3dArray(path: documentsPath + project.sigma3dPath!)
    profileArray = self.fileManager.getProfileArray(path: documentsPath + project.profilePath!)
    
    // edsall array
    edsallArray = self.fileManager.getEdsallArray(path: documentsPath + project.edsallPath!)
    if edsallArray.count > 0
    {
      for key in edsallArray[0].keys {
        timeSlices.append(key)
      }
      timeSlices.sort { (v1, v2) -> Bool in
        if v1 < v2 {
          return true
        }
        return false
      }
    }
    
    
    // Rn array
//    let rnPath = Bundle.main.path(forResource: "1.Rn.5",
//                                  ofType: "")!
//    rnArray = self.fileManager.getRnArray(path: rnPath)
//    
    //Rn array
    let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: project.rnArrayPathsArray!) as? [String]
    for rnArrayFilePath in decodedArray!
    {
      let rnArrayTmp = self.fileManager.getRnArray(path: documentsPath + rnArrayFilePath)
    }
  
    if (decodedArray?.count)! > 0
    {
      rnArray = self.fileManager.getRnArray(path: documentsPath + decodedArray![0])
    }
    
    if sig3dArray.count > 0
    {
      //TODO: http://nshipster.com/kvc-collection-operators/
      let min = sig3dArray.min { (first, second) -> Bool in
        return first[1] < second[1]
        }![1]
      let max = sig3dArray.max { (first, second) -> Bool in
        return first[1] < second[1]
        }![1]
      let colorGenerator = MAGColorGenerator()
      colorGenerator.generateColor(minValue: min,
                                   maxValue: max)
      self.colorGenerator = colorGenerator
      for i in 0..<sig3dArray.count
      {
        let materialNumber = Int(sig3dArray[i][0])
        let vector = colorGenerator.getColorForU(u: sig3dArray[i][1])
        let material = MAGMaterial.init(numberOfMaterial: materialNumber,
                                        color: vector)
        self.materials.append(material)
      }
    }
    else
    {
      let set = NSMutableSet()
      for nvkat in nvkatArray
      {
        set.add(nvkat)
      }
      for materialNumber in set
      {
        let material = MAGMaterial.init(numberOfMaterial: materialNumber as! Int,
                                        color: self.getColor(material: materialNumber as! Int))
        self.materials.append(material)
      }
    }
    self.selectedMaterials  = self.materials
    createElementsArray()
    if profileArray.count > 0
    {
      createReceiverSurface()
    }
  }
  
  func generateValuesFromEdsall(key: Float) -> [Float]
  {
    var result: [Float] = []
    
    for i in 0..<self.edsallArray.count
    {
      result.append(self.edsallArray[i][key]!)
    }
    return result
  }
  
  func createReceiverSurface()
  {
    var receiversArraySortedByXY = profileArray.sorted(by: { (v1, v2) -> Bool in
      if fabs(v1.y - v2.y)>=5
      {
        return v1.y < v2.y
      }
      else
      {
        return v1.x < v2.x
      }
    })
    
    let colorGenerator = MAGColorGenerator()
    let uValueArray: [Float] = generateValuesFromEdsall(key: self.timeSlices[10])
//    for vector in receiversArraySortedByXY
//    {
//      uValueArray.append(Float(MAGRecieversFuncGenerator.uFunc(x: Double(vector.x),
//                                                               y: Double(vector.y),
//                                                               z: Double(vector.z))))
//    }
    
    let minValue = uValueArray.min { (first, second) -> Bool in
      return first < second
      }!
    let maxValue = uValueArray.max { (first, second) -> Bool in
      return first < second
      }!
    colorGenerator.generateColor(minValue: Double(minValue),
                                 maxValue: Double(maxValue))

    var receivers: [[SCNVector3]] = []
    var lineArray: [SCNVector3] = []
    for i in 0..<receiversArraySortedByXY.count - 1
    {
      if (receiversArraySortedByXY[i].x < receiversArraySortedByXY[i + 1].x)
      {
        lineArray.append(receiversArraySortedByXY[i])
      }
      else
      {
        lineArray.append(receiversArraySortedByXY[i])
        receivers.append(lineArray)
        lineArray = []
      }
    }
    lineArray.append(receiversArraySortedByXY[receiversArraySortedByXY.count - 1])
    receivers.append(lineArray)
    
    var numberArray: [[Int]] = []
    var lineNumArray: [Int] = []
    
    
    // todo cравнить первый элемент если разный то  count-1-h, если одинаковый то оставить

    var h = 0
    for i in 0..<receivers.count {
      for _ in 0..<receivers[i].count {
        if (profileArray[0].x == receivers[0][0].x
          && profileArray[0].y == receivers[0][0].y
          && profileArray[0].z == receivers[0][0].z) {
          lineNumArray.append(h)
        }
        else {
          lineNumArray.append(self.profileArray.count - 1 - h)
        }
        h += 1
      }
      numberArray.append(lineNumArray)
      lineNumArray = []
    }
/*
    var trinaglesArray: [MAGTriangleElement] = []
 
    for i in 0..<receivers.count - 1 {
      var j: Int = 0
      if (receivers[i].count <= receivers[i + 1].count)
      {
        while (j < receivers[i + 1].count - 1)
        {
          if (j < receivers[i].count - 1)
          {
//            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j], receivers[i][j + 1], receivers[i + 1][j]],
//                                                     colors: colorGenerator.getColorsFor(vertexes: [receivers[i][j],
//                                                                                                    receivers[i][j + 1],
//                                                                                                    receivers[i + 1][j]])))
//            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j + 1], receivers[i + 1][j + 1], receivers[i + 1][j]],
//                                                     colors: colorGenerator.getColorsFor(vertexes: [receivers[i][j + 1],
//                                                                                                    receivers[i + 1][j + 1],
//                                                                                                    receivers[i + 1][j]])))
            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j], receivers[i][j + 1], receivers[i + 1][j]],
                                                     colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j]],
                                                                                                  uValueArray[numberArray[i][j + 1]],
                                                                                                  uValueArray[numberArray[i + 1][j]]])))
            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j + 1], receivers[i + 1][j + 1], receivers[i + 1][j]],
                                                     colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j + 1]],
                                                                                                  uValueArray[numberArray[i + 1][j + 1]],
                                                                                                  uValueArray[numberArray[i + 1][j]]])))
          }
          else
          {
//            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][receivers[i].count - 1],
//                                                                 receivers[i + 1][j + 1],
//                                                                 receivers[i + 1][j]],
//                                                     colors: colorGenerator.getColorsFor(vertexes: [receivers[i][receivers[i].count - 1],
//                                                                                                    receivers[i + 1][j + 1],
//                                                                                                    receivers[i + 1][j]])))
            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][receivers[i].count - 1],
                                                                 receivers[i + 1][j + 1],
                                                                 receivers[i + 1][j]],
                                                     colors: colorGenerator.getColorsFor(values:
                                                                                         [uValueArray[numberArray[i][numberArray[i].count - 1]],
                                                                                         uValueArray[numberArray[i + 1][j + 1]],
                                                                                         uValueArray[numberArray[i + 1][j]]])))
          }
          j += 1
        }
      }
      else {
        while (j < receivers[i].count - 1)
        {
          if (j < receivers[i + 1].count - 1)
          {
//            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j], receivers[i][j + 1], receivers[i + 1][j]],
//                                                     colors: colorGenerator.getColorsFor(vertexes: [receivers[i][j],
//                                                                                                    receivers[i][j + 1],
//                                                                                                    receivers[i + 1][j]])))
//            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j + 1], receivers[i + 1][j + 1], receivers[i + 1][j]],
//                                                     colors: colorGenerator.getColorsFor(vertexes: [receivers[i][j + 1],
//                                                                                                    receivers[i + 1][j + 1],
//                                                                                                    receivers[i + 1][j]])))
            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j], receivers[i][j + 1], receivers[i + 1][j]],
                                                     colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j]],
                                                                                                  uValueArray[numberArray[i][j + 1]],
                                                                                                  uValueArray[numberArray[i + 1][j]]])))
            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j + 1], receivers[i + 1][j + 1], receivers[i + 1][j]],
                                                     colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j + 1]],
                                                                                                    uValueArray[numberArray[i + 1][j + 1]],
                                                                                                    uValueArray[numberArray[i + 1][j]]])))
          }
          else
          {
//            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j],
//                                                                 receivers[i][j + 1],
//                                                                 receivers[i + 1][receivers[i + 1].count - 1]],
//                                                     colors: colorGenerator.getColorsFor(vertexes: [receivers[i][j],
//                                                                                                    receivers[i][j + 1],
//                                                                                                    receivers[i + 1][receivers[i + 1].count - 1]])))
            trinaglesArray.append(MAGTriangleElement(positions: [receivers[i][j],
                                                                 receivers[i][j + 1],
                                                                 receivers[i + 1][receivers[i + 1].count - 1]],
                                                     colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j]],
                                                                                                   uValueArray[numberArray[i][j + 1]],
                                                                                                    uValueArray[numberArray[i + 1][numberArray[i + 1].count - 1]]])))
          }
          j += 1
        }
      }
    }
    self.receiversSurface = trinaglesArray
 */
    createTrianglesArray(receivers: receivers, numberArray: numberArray, colorGenerator: colorGenerator)
//    self.chartsData.maxZValue = profileArray.max { (first, second) -> Bool in
//      return first.z < second.z
//      }!.z
//    self.chartsData.minUValue = minValue
//    self.chartsData.maxUValue = maxValue
//    self.chartsData.maxZModel = xyzArray.max { (first, second) -> Bool in
//      return first.z < second.z
//      }!.z
//    self.chartsData.updateZValueChartsData(sortedReceivers: receivers)
    
    
    self.chartsData.generateChartsValuesWith(firstReceiver: receivers[0][0],
                                             rnArray: self.rnArray,
                                             minZValue: profileArray.min { (first, second) -> Bool in
                                              return first.z < second.z
                                              }!.z,
                                             maxZValue: profileArray.max { (first, second) -> Bool in
                                              return first.z < second.z
                                              }!.z,
                                             maxZModel: xyzArray.max { (first, second) -> Bool in
                                              return first.z < second.z
                                              }!.z)
  }
  
  func createTrianglesArray(receivers: [[SCNVector3]], numberArray: [[Int]], colorGenerator: MAGColorGenerator)
  {
    let uValueArray: [Float] = generateValuesFromEdsall(key: self.timeSlices[showTimeSlicesNumber]) // todo временные слоя
    var triangleArray: [MAGTriangleElement] = []
    
    for i in 0..<receivers.count - 1
    {
      if (receivers[i].count >= receivers[i + 1].count) {
        var j: Int = 0
        var h0: Int = 0
        var h: Int = 0
        while (j < receivers[i + 1].count - 1) {
          if (j < receivers[i + 1].count - 1)
          {
            h0 = h
            while (h < receivers[i].count && receivers[i][h].x < receivers[i + 1][j + 1].x) {
              if (h + 1 <= receivers[i].count) {
                h += 1
              }
            }
            if (h >= receivers[i].count) {
              h = receivers[i].count - 1
            }
            triangleArray.append(MAGTriangleElement(positions: [receivers[i][h0], receivers[i][h], receivers[i + 1][j]],
                                                    colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][h0]],
                                                                                                 uValueArray[numberArray[i][h]],
                                                                                                 uValueArray[numberArray[i + 1][j]]])))
            triangleArray.append(MAGTriangleElement(positions: [receivers[i][h], receivers[i + 1][j + 1], receivers[i + 1][j]],
                                                    colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][h]],
                                                                                                 uValueArray[numberArray[i + 1][j + 1]],
                                                                                                 uValueArray[numberArray[i + 1][j]]])))
            
          }
          j += 1
        }
      }
      else {
          var j: Int = 0
          var h0: Int = 0
          var h: Int = 0
          while (j < receivers[i].count - 1) {
            if (j < receivers[i].count - 1)
            {
              h0 = h
              while (h < receivers[i + 1].count && receivers[i + 1][h].x < receivers[i][j + 1].x) {
                if (h + 1 <= receivers[i + 1].count) {
                  h += 1
                }
              }
              if (h >= receivers[i + 1].count) {
                h = receivers[i + 1].count - 1
              }
              triangleArray.append(MAGTriangleElement(positions: [receivers[i][j], receivers[i][j + 1], receivers[i + 1][h0]],
                                                      colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j]],
                                                                                                   uValueArray[numberArray[i][j + 1]],
                                                                                                   uValueArray[numberArray[i + 1][h0]]])))
              triangleArray.append(MAGTriangleElement(positions: [receivers[i][j + 1], receivers[i + 1][h], receivers[i + 1][h0]],
                                                      colors: colorGenerator.getColorsFor(values: [uValueArray[numberArray[i][j + 1]],
                                                                                                   uValueArray[numberArray[i + 1][h]],
                                                                                                   uValueArray[numberArray[i + 1][h0]]])))
              
            }
            j += 1
          }
      }
    }
    
    self.receiversSurface = triangleArray
  }
  
  func createElementsArray()
  {
    elementsArray = []
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
    

    self.scaleValue = 1.0 / abs((maxVector.y - minVector.y) / 8.0)
    centerPoint = SCNVector3Make((maxVector.x - minVector.x) / 2.0 + minVector.x,
                                 (maxVector.y - minVector.y) / 2.0 + minVector.y,
                                 (maxVector.z - minVector.z) / 2.0 + minVector.z)
    
    if isDrawingSectionEnabled
    {
      let crossSection: MAGCrossSection = MAGCrossSection(plane: sectionType,
                                                          value: sectionValue,
                                                          greater: self.greater)
      self.crossSection = crossSection
    }

    var XYZValuesArray: [Double] = []
    if showFieldNumber != -1
    {
      XYZValuesArray = self.fieldsArray[showFieldNumber]
      let min = XYZValuesArray.min { (first, second) -> Bool in
        return first < second
        }!
      let max = XYZValuesArray.max { (first, second) -> Bool in
        return first < second
        }!
      let colorGenerator = MAGColorGenerator()
      colorGenerator.generateColor(minValue: min,
                                   maxValue: max)
      self.colorGenerator = colorGenerator
    }

    var numberOfElement : Int = 0
    for i in 0..<nverArray.count
    {
      let positionArray = getNVERArrayFor(number: i)


      let isVisible = isDrawingSectionEnabled ? self.crossSection?.setVisibleToHexahedron(positions: positionArray) : .isVisible

    
      let elementNeibsArray: [[Int]] = generateNeibsElementArray(number: i)
      
      var hexahedron: MAGHexahedron
      let material = nvkatArray[numberOfElement]
      
      if showFieldNumber != -1
      {
        var colors: [SCNVector3] = []
        var j : Int = 0
        for number in self.nverArray[i]
        {
          if j < 8
          {
            colors.append((self.colorGenerator?.getColorForU(u: XYZValuesArray[number - 1]))!)
          }
          else
          {
            break
          }
          j = j + 1
        }
        hexahedron = MAGHexahedron(positions: positionArray,
                                   neighbours: elementNeibsArray,
                                   material: material,
                                   color: colors)
      }
      else if sig3dArray.count == 0
      {
        hexahedron = MAGHexahedron(positions: positionArray,
                                   neighbours: elementNeibsArray,
                                   material: material,
                                   color: [self.getColor(material: nvkatArray[numberOfElement])])
      }
      else
      {
        var uValue = 0.0
        for materialSig3d in sig3dArray
        {
          if material == Int(materialSig3d[0])
          {
            uValue = materialSig3d[1]
          }
        }
        hexahedron = MAGHexahedron(positions: positionArray,
                                   neighbours: elementNeibsArray,
                                   material: material,
                                   color: [(self.colorGenerator?.getColorForU(u: uValue))!])
        
      }
      
      hexahedron.generateSides()
      // когда формируем hexahedronы смотрим их видимость
      
      hexahedron.visible = isVisible!
      
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
            break
          }
          else
          {
            if (!self.isDrawingSectionEnabled)
            {
               neibsNumbers.append(neibs[i + 1])
            }
            else
            {
              if isElementVisible(numberOfElement: neibs[i + 1] - 1) {
                neibsNumbers.append(neibs[i + 1])
              }
              else
              {
                neibsNumbers = []
              }
            }
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
  
  private func isElementVisible(numberOfElement: Int) -> Bool
  {
    let positionArray: [SCNVector3] = getNVERArrayFor(number: numberOfElement)
    
    if positionArray.count > 0
    {
      if (self.crossSection != nil) {
        return (self.crossSection!.setVisibleToHexahedron(positions: positionArray) == .isVisible)
      } else {
        return true
      }
    }
    return false
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
  

  private func getColor(material: Int) -> SCNVector3
  {
    switch material
    {
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
}

