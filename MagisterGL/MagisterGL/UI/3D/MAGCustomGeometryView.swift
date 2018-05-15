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
    
    drawProfile()
    createCube()
  }
  
  private func drawProfile()
  {
    var globalIndicies : [CInt] = []
    for i in 0..<self.model.profileArray.count
    {
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
  
  private func createCube()
  {
//    var verts : [SCNVector3] = [SCNVector3Make(0, 0, 0),
//                                SCNVector3Make(2, 0, 0),
//                                SCNVector3Make(0, 2, 0),
//                                SCNVector3Make(2, 2, 0)]
//    let src = SCNGeometrySource(vertices: verts)
//    let indexes: [CInt] = [4, 0, 1, 3, 2] // Changed to CInt
//
//    let dat  = Data(
//      bytes: indexes,
//      count: MemoryLayout<CInt>.size * indexes.count // Changed to size of CInt * count
//    )
//    let ele = SCNGeometryElement(
//      data: dat,
//      primitiveType: .polygon,
//      primitiveCount: 1,
//      bytesPerIndex: MemoryLayout<CInt>.size // Changed to CInt
//    )
//    let geo = SCNGeometry(sources: [src], elements: [ele])
//
//    let nd = SCNNode(geometry: geo)
//    self.scene?.rootNode.addChildNode(nd)
//    return
    
    var h = 0 as Int32
    var j = 0 as Int32
    var globalPositions : [SCNVector3] = []
    var globalNormals : [SCNVector3] = []
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
        //hexahedron.setColorToSides()
        var normals: [SCNVector3] = []
        var indices: [CInt] = []
        for side in hexahedron.sidesArray
        {
          if side.isVisible
          {
            let indicesSide = [4] + side.indicesArray(addValue: h * 4)

            let indexDataSide = Data(bytes: indicesSide,
                                     count: MemoryLayout<CInt>.size * indicesSide.count)
            let elementSide = SCNGeometryElement(data: indexDataSide,
                                                 primitiveType: .polygon,
                                                 primitiveCount: indicesSide.count / 4,
                                                 bytesPerIndex: MemoryLayout<CInt>.size)
            globalElements.append(elementSide)
            normals = normals + side.normalsArray()
            indices = indices + indicesSide
            vertexPositions += side.positions

            globalColors = globalColors + side.colors
            h += 1
          }
        }

        globalPositions = globalPositions + hexahedron.positions
        let normals2 = [
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          //
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          SCNVector3Make( 1, 1, 1),
          ]

        globalNormals = globalNormals + normals2
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
    let normalSource = SCNGeometrySource(normals: globalNormals)

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
}
