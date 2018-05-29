//
//  MAGCustomGeometryView.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 26.09.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


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
    self.backgroundColor = .lightGray
    
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
    self.showsStatistics = true
    
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
    
    drawReceivers()
    drawModel()
    drawReceiversSurface()
    drawReceiversCharts()
  }
  
  private func drawReceivers()
  {
    if (self.model.profileArray.count != 0) {
    
      
      
      var globalIndicies : [CInt] = []
      for i in 0..<self.model.profileArray.count {
        globalIndicies.append(CInt(i))
      }
      let globalPositions : [SCNVector3] = self.model.profileArray
      let positionSource = SCNGeometrySource(vertices: globalPositions)
      let indexDataCarcas = Data(bytes: globalIndicies,
                                 count: MemoryLayout<CInt>.size * globalIndicies.count)
      let elementBorder = SCNGeometryElement(data: indexDataCarcas,
                                             primitiveType: .point,
                                             primitiveCount: globalIndicies.count,
                                             bytesPerIndex: MemoryLayout<CInt>.size)
      let pointSize: CGFloat = 5.0
      elementBorder.pointSize = pointSize
      elementBorder.minimumPointScreenSpaceRadius = pointSize
      elementBorder.maximumPointScreenSpaceRadius = pointSize
      let geometryBorder = SCNGeometry(sources: [positionSource],
                                       elements: [elementBorder])
      geometryBorder.firstMaterial?.diffuse.contents = UIColor.red
      let borderCubeNode = SCNNode(geometry: geometryBorder)
      let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
      borderCubeNode.scale = scaleVector
      self.scene?.rootNode.addChildNode(borderCubeNode)
    }
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
  
  private func drawReceiversSurface()
  {
    var globalElements: [SCNGeometryElement] = []
    var vertexPositions: [SCNVector3] = []
    var globalColors: [SCNVector3] = []
    var indices: [CInt] = []

    
    var h: Int32 = 0
    for triangle in self.model.receiversSurface
    {
      let indicesSide = triangle.indicesArray(addValue: h * 3)
      
      let indexDataSide = Data(bytes: indicesSide,
                               count: MemoryLayout<CInt>.size * indicesSide.count)
      let elementSide = SCNGeometryElement(data: indexDataSide,
                                           primitiveType: .triangles,
                                           primitiveCount: indicesSide.count / 3,
                                           bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementSide)
      indices = indices + indicesSide
      vertexPositions += triangle.positions
      
      globalColors = globalColors + triangle.colors
      h += 1
    }
    
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
    
    // let geometry = SCNGeometry(sources: [vertexSource, normalSource, colors],
    let geometry = SCNGeometry(sources: [vertexSource, colors],
                               elements: globalElements)
    let surfaceNode = SCNNode(geometry: geometry)
    let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
    surfaceNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(surfaceNode)
  }
  
  private func drawReceiversCharts()
  {
    var globalPositions : [SCNVector3] = []
    var globalIndicies : [CInt] = []
 
    var h: Int = 0
    for vectorsArray in self.model.chartsData.chartsValues {
      for vector in vectorsArray {
        globalPositions.append(vector)
      }
      for i in 0..<vectorsArray.count - 1 {
        globalIndicies.append(CInt(i + h))
        globalIndicies.append(CInt(i + h + 1))
      }
      h += vectorsArray.count
    }
    
    
    
    let positionSource = SCNGeometrySource(vertices: globalPositions)
    
    let indexData = Data(bytes: globalIndicies,
                         count: MemoryLayout<CInt>.size * globalIndicies.count)
    let linesElement = SCNGeometryElement(data: indexData,
                                          primitiveType: .line,
                                          primitiveCount: globalIndicies.count / 2,
                                          bytesPerIndex: MemoryLayout<CInt>.size)
    
    let geometryLines = SCNGeometry(sources: [positionSource],
                                     elements: [linesElement])
    geometryLines.firstMaterial?.diffuse.contents = UIColor.red
    let chartsNode = SCNNode(geometry: geometryLines)
    let scaleVector = SCNVector3(self.model.scaleValue, self.model.scaleValue, self.model.scaleValue)
    chartsNode.scale = scaleVector
    self.scene?.rootNode.addChildNode(chartsNode)
  }
  
  
  // использовать только для тестирования чего-либо
  private func drawPlayground()
  {
    var globalElements: [SCNGeometryElement] = []
    var globalColors: [SCNVector3] = []
    
    var vertexPositions: [SCNVector3] = []
    
    let indicesSide: [CInt] = [0,1,2]
    let indexDataSide = Data(bytes: indicesSide,
                             count: MemoryLayout<CInt>.size * indicesSide.count)
    
    let elementSide = SCNGeometryElement(data: indexDataSide,
                                         primitiveType: .triangles,
                                         primitiveCount: indicesSide.count / 3,
                                         bytesPerIndex: MemoryLayout<CInt>.size)
    let indicesSide2: [CInt] = [3,4,5]
    let indexDataSide2 = Data(bytes: indicesSide2,
                              count: MemoryLayout<CInt>.size * indicesSide.count)
    let elementSide2 = SCNGeometryElement(data: indexDataSide2,
                                          primitiveType: .triangles,
                                          primitiveCount: indicesSide.count / 3,
                                          bytesPerIndex: MemoryLayout<CInt>.size)
    
    vertexPositions.append(SCNVector3Make(0, 0, 0))
    vertexPositions.append(SCNVector3Make(2, 0, 0))
    vertexPositions.append(SCNVector3Make(1, 4, 0))
    
    vertexPositions.append(SCNVector3Make(4, 0, 0))
    vertexPositions.append(SCNVector3Make(6, 0, 0))
    vertexPositions.append(SCNVector3Make(5, 10, 0))
    
    
    globalColors.append(SCNVector3Make(1, 0, 0))
    globalColors.append(SCNVector3Make(0, 1, 0))
    globalColors.append(SCNVector3Make(0, 0, 1))
    
    globalColors.append(SCNVector3Make(1, 0, 0))
    globalColors.append(SCNVector3Make(0, 1, 0))
    globalColors.append(SCNVector3Make(0, 0, 1))
    
    globalElements.append(elementSide)
    globalElements.append(elementSide2)
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
    let modelNode = SCNNode(geometry: geometry)
    self.scene?.rootNode.addChildNode(modelNode)
  }
}
