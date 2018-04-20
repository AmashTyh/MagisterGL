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
   private var model: MAGCustomGeometryModel = MAGCustomGeometryModel.init()
   
   deinit
   {
      scene?.rootNode.cleanup()
   }
   
   
   public func redraw()
   {
      scene?.rootNode.cleanup()
      setupScene()
   }
   
   override func awakeFromNib()
   {
      super.awakeFromNib()
      
      setupScene()
   }
   
   private func setupScene()
   {
      self.model = MAGCustomGeometryModel.init()
      self.model.createElementsArray()
      // Configure the Scene View
      self.backgroundColor = .darkGray
      
      // Create the scene
      let scene = SCNScene()
      
      // Create a camera and attach it to a node
      let camera = SCNCamera()
      //camera.xFov = 10
      //camera.yFov = 45
      
      let cameraNode = SCNNode()
      cameraNode.camera = camera
      cameraNode.position = SCNVector3(self.model.centerPoint.x,
                                       self.model.centerPoint.y,
                                       self.model.centerPoint.z + (self.model.maxVector.z - self.model.minVector.z) / 2.0 + 20)
      scene.rootNode.addChildNode(cameraNode)
      
      self.allowsCameraControl = true
      self.showsStatistics = true
      
      // create and add an ambient light to the scene
      let ambientLightNode = SCNNode()
      ambientLightNode.light = SCNLight()
      ambientLightNode.light?.type = .ambient
      //ambientLightNode.light?.color = UIColor.white
      scene.rootNode.addChildNode(ambientLightNode)
      
      scene.rootNode.pivot = SCNMatrix4MakeTranslation(self.model.centerPoint.x,
                                                       self.model.centerPoint.y,
                                                       self.model.centerPoint.z)
      
      self.scene = scene
      createCube()
   }
   
   private func createCube()
   {
      var h = 0 as Int32
      var j = 0 as Int32
      var globalPositions : [SCNVector3] = []
      var globalNormals : [SCNVector3] = []
      var globalIndicies : [CInt] = []
      var globalIndiciesCarcas : [CInt] = []
      var globalElements : [SCNGeometryElement] = []
      var globalColors : [SCNVector3] = []
      
      var vertexPositions : [SCNVector3] = []
      
      for hexahedron in self.model.elementsArray
      {
         if hexahedron.visible == .isVisible
         {
      
            hexahedron.setColorToSides()
            var normals: [SCNVector3] = []
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
      self.scene?.rootNode.addChildNode(borderCubeNode)
   }
}
