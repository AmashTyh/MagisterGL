import UIKit
import SceneKit

/**
 Основная модель приложения
 */
class MAGCustomGeometryModel: NSObject
{
  /**
   Работа с файлами
   */
  let fileManager: MAGFileManager = MAGFileManager()
  
  /**
   Пользовательские настройки
   */
  var isShowMaterials = true
  var showFieldNumber = -1
  var colorGenerator: MAGColorGenerator?
  var project: MAGProject?
  
  var scaleValue : Float = 1.0
  var isDrawingSectionEnabled: Bool = false
  var elementsArray: [MAGHexahedron] = []
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
  
  /**
   Настроить модель с помощью проекта
   */
  func configure(project: MAGProject)
  {
    self.project = project
    
    let documentsPath = (project.isLocal ? Bundle.main.resourcePath! : NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]) + "/"
    xyzArray = self.fileManager.getXYZArray(path: documentsPath + project.xyzFilePath!)
    nverArray = self.fileManager.getNVERArray(path: documentsPath + project.nverFilePath!)
    nvkatArray = self.fileManager.getNVKATArray(path: documentsPath + project.nvkatFilePath!)
    neibArray = self.fileManager.getNEIBArray(path: documentsPath + project.elemNeibFilePath!)
    sig3dArray = self.fileManager.getSig3dArray(path: documentsPath + project.sigma3dPath!)
    
    //v3 array
    let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: project.v3FilePathsArray!) as? [String]
    for v3FilePath in decodedArray!
    {
      let XYZValuesArray = self.fileManager.getXYZValuesArray(path: documentsPath + v3FilePath)
      if XYZValuesArray.count > 0
      {
        self.fieldsArray.append(XYZValuesArray)
      }
    }
    
    if sig3dArray.count > 0
    {
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
        var color = SCNVector3Zero
        for materialElem in materials
        {
          if materialElem.numberOfMaterial == material
          {
            color = materialElem.color
            break
          }
        }
        hexahedron = MAGHexahedron(positions: positionArray,
                                   neighbours: elementNeibsArray,
                                   material: material,
                                   color: [color])
        
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

