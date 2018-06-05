import UIKit
import SceneKit
import OpenGLES


extension SCNNode
{
  func cleanup()
  {
    for child in childNodes
    {
      child.cleanup()
    }
    geometry = nil
  }
}


class MAGCustomGeometryView: SCNView
{
  var model: MAGCustomGeometryModel = MAGCustomGeometryModel()
  
  deinit
  {
    scene?.rootNode.cleanup()
  }  
  
  func configure(project: MAGProject)
  {
    scene?.rootNode.cleanup()
    self.model.configure(project: project)
    setupScene()
  }
  
  func setupScene()
  {
    self.scene?.rootNode.cleanup()
    // Configure the Scene View
    self.backgroundColor = UIColor(red: 238.0 / 255.0,
                                   green: 238.0 / 255.0,
                                   blue: 244.0 / 255.0,
                                   alpha: 1.0)
    
    // Create the scene
    let scene = SCNScene()
    
    // Create a camera and attach it to a node
    let camera = SCNCamera()
    //camera.xFov = 10
    //camera.yFov = 45
    
    let cameraNode = SCNNode()
    cameraNode.camera = camera
    cameraNode.position = SCNVector3(self.model.centerPoint.x * self.model.scaleValue,
                                     self.model.centerPoint.y * self.model.scaleValue,
                                     self.model.centerPoint.z * self.model.scaleValue + (self.model.maxVector.z * self.model.scaleValue - self.model.minVector.z * self.model.scaleValue) / 2.0 + 20)
    scene.rootNode.addChildNode(cameraNode)
    
    self.allowsCameraControl = true
//    self.showsStatistics = true
    
    // create and add an ambient light to the scene
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light?.type = .ambient
    //ambientLightNode.light?.color = UIColor.white
    scene.rootNode.addChildNode(ambientLightNode)
    
    scene.rootNode.pivot = SCNMatrix4MakeTranslation(self.model.centerPoint.x * self.model.scaleValue,
                                                     self.model.centerPoint.y * self.model.scaleValue,
                                                     self.model.centerPoint.z * self.model.scaleValue)
    
    self.scene = scene
    
    drawModel()
    drawAsix()
  }
  
  
  private func drawModel()
  {
    var h = 0 as Int32
    var j = 0 as Int32
    var globalPositions : [SCNVector3] = []
    var globalIndicies : [CInt] = []
    var globalIndiciesCarcas : [CInt] = []
    var globalElements : [SCNGeometryElement] = []
    var globalColors : [SCNVector3] = []

    var vertexPositions : [SCNVector3] = []
    var selectedNumberMaterials: [Int] = []

    for material in self.model.selectedMaterials
    {
      selectedNumberMaterials.append(material.numberOfMaterial)
    }

    for hexahedron in self.model.elementsArray
    {
      if hexahedron.visible != .isVisible
      {
        continue
      }
      if !selectedNumberMaterials.contains(hexahedron.material)
      {
        continue
      }
      var indices: [CInt] = []
      for side in hexahedron.sidesArray
      {
        if side.isVisible
        {
          let indicesSide = side.indicesArray(addValue: h * 5)
          
          let indexDataSide = Data(bytes: indicesSide,
                                   count: MemoryLayout<CInt>.size * indicesSide.count)
          let elementSide = SCNGeometryElement(data: indexDataSide,
                                               primitiveType: .triangles,
                                               primitiveCount: indicesSide.count / 3,
                                               bytesPerIndex: MemoryLayout<CInt>.size)
          globalElements.append(elementSide)
          indices = indices + indicesSide
          vertexPositions += side.positions
          
          globalColors = globalColors + side.colors
          h += 1
        }
      }
      
      globalPositions = globalPositions + hexahedron.positions
      
      let addValue = j * 8
      globalIndicies = globalIndicies + indices
      let indicesCarcas = [
        0 + addValue, 1 + addValue,
        0 + addValue, 2 + addValue,
        0 + addValue, 4 + addValue,
        1 + addValue, 3 + addValue,
        2 + addValue, 3 + addValue,
        1 + addValue, 5 + addValue,
        4 + addValue, 5 + addValue,
        2 + addValue, 6 + addValue,
        4 + addValue, 6 + addValue,
        6 + addValue, 7 + addValue,
        3 + addValue, 7 + addValue,
        5 + addValue, 7 + addValue,
        ] as [CInt]
      globalIndiciesCarcas = globalIndiciesCarcas + indicesCarcas
      j = j + 1
    }

    let positionSource = SCNGeometrySource(vertices: globalPositions)
    let vertexSource = SCNGeometrySource(vertices: vertexPositions)

    let dataColor = NSData(bytes: globalColors,
                           length: MemoryLayout<SCNVector3>.size * globalColors.count) as Data
    let colors = SCNGeometrySource(data: dataColor,
                                   semantic: .color,
                                   vectorCount: globalColors.count,
                                   usesFloatComponents: true,
                                   componentsPerVector: 3,
                                   bytesPerComponent: MemoryLayout<Float>.size,
                                   dataOffset: 0,
                                   dataStride: MemoryLayout<SCNVector3>.stride)

    let geometry = SCNGeometry(sources: [vertexSource, colors],
                               elements: globalElements)
    let cubeNode = SCNNode(geometry: geometry)
    let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
    cubeNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(cubeNode)


    let indexDataCarcas = Data(bytes: globalIndiciesCarcas,
                               count: MemoryLayout<CInt>.size * globalIndiciesCarcas.count)
    let elementBorder = SCNGeometryElement(data: indexDataCarcas,
                                           primitiveType: .line,
                                           primitiveCount: globalIndiciesCarcas.count / 2,
                                           bytesPerIndex: MemoryLayout<CInt>.size)
    let geometryBorder = SCNGeometry(sources: [positionSource],
                                     elements: [elementBorder])
    geometryBorder.firstMaterial?.diffuse.contents = UIColor.white
    let borderCubeNode = SCNNode(geometry: geometryBorder)
    borderCubeNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(borderCubeNode)
  }
  
  //MARK: Draw asix
  
  func drawAsix()
  {
    drawAsixX()
    drawAsixY()
    drawAsixZ()
  }
  
  func drawAsixX()
  {
    let geometry = SCNGeometry.lineFrom(vector: SCNVector3Make(0, 0, 0), toVector: SCNVector3Make(self.model.maxVector.x * 1.3, 0, 0))
    let modelNode = SCNNode(geometry: geometry)
    geometry.firstMaterial?.diffuse.contents = UIColor.red
    let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
    modelNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(modelNode)
  }
  
  func drawAsixY()
  {
    let geometry = SCNGeometry.lineFrom(vector: SCNVector3Make(0, 0, 0), toVector: SCNVector3Make(0, self.model.maxVector.y * 1.3, 0))
    let modelNode = SCNNode(geometry: geometry)
    geometry.firstMaterial?.diffuse.contents = UIColor.green
    let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
    modelNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(modelNode)
  }
  
  func drawAsixZ()
  {
    let geometry = SCNGeometry.lineFrom(vector: SCNVector3Make(0, 0, 0), toVector: SCNVector3Make(0, 0, self.model.maxVector.z * 1.3))
    let modelNode = SCNNode(geometry: geometry)
    geometry.firstMaterial?.diffuse.contents = UIColor.blue
    let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
    modelNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(modelNode)
  }
 
}

extension SCNGeometry
{
  class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry
  {
    let indices: [Int32] = [0, 1]
    
    let source = SCNGeometrySource(vertices: [vector1,
                                              vector2])
    let element = SCNGeometryElement(indices: indices,
                                     primitiveType: .line)
    let geometry = SCNGeometry(sources: [source],
                               elements: [element])
    geometry.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
    return geometry
  }
}
