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
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        scene.rootNode.pivot = SCNMatrix4MakeTranslation(self.model.centerPoint.x,
                                                         self.model.centerPoint.y,
                                                         self.model.centerPoint.z)
      
        self.scene = scene
        createCube()
    }
    
    private func createCube()
    {
        var j = 0 as Int32
        var globalPositions : [SCNVector3] = []
        var globalNormals : [SCNVector3] = []
        var globalIndicies : [CInt] = []
        var globalIndiciesCarcas : [CInt] = []
        var globalElements : [SCNGeometryElement] = []

        for hexahedron in self.model.elementsArray
        {
            var normals: [SCNVector3] = []
            var indices: [CInt] = []
            var positions: [SCNVector3] = []
            var k = 0 as Int32
            for side in hexahedron.sidesArray
            {
              if side.isVisible
              {
                let indicesSide = side.indicesArray(addValue: j * 24)
                
                let indexDataSide = Data(bytes: indicesSide,
                                         count: MemoryLayout<CInt>.size * indicesSide.count)
                let elementSide = SCNGeometryElement(data: indexDataSide,
                                                     primitiveType: .triangles,
                                                     primitiveCount: indicesSide.count / 3,
                                                     bytesPerIndex: MemoryLayout<CInt>.size)
                globalElements.append(elementSide)
                
                normals = normals + side.normalsArray()
                indices = indices + indicesSide
                positions = positions + side.positions
              }
              k = k + 1
          }
          let positions2 = hexahedron.positions + hexahedron.positions + hexahedron.positions

            globalPositions = globalPositions + positions2
          
            globalNormals = globalNormals + normals
            let addValue = j * 24
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
      
      let vertexSource = SCNGeometrySource(vertices: globalPositions)
      let normalSource = SCNGeometrySource(normals: globalNormals)
      let geometry = SCNGeometry(sources: [vertexSource, normalSource],
                                 elements: globalElements)
      geometry.firstMaterial?.diffuse.contents = UIColor(red: 0.149,
                                                         green: 0.604,
                                                         blue: 0.859,
                                                         alpha: 1.0)
      let cubeNode = SCNNode(geometry: geometry)
      self.scene?.rootNode.addChildNode(cubeNode)
    
      let indexDataCarcas = Data(bytes: globalIndiciesCarcas,
                                 count: MemoryLayout<CInt>.size * globalIndiciesCarcas.count)
      let elementBorder = SCNGeometryElement(data: indexDataCarcas,
                                             primitiveType: .line,
                                             primitiveCount: globalIndiciesCarcas.count / 2,
                                             bytesPerIndex: MemoryLayout<CInt>.size)
      let geometryBorder = SCNGeometry(sources: [vertexSource],
                                       elements: [elementBorder])
      geometryBorder.firstMaterial?.diffuse.contents = UIColor.red
      let borderCubeNode = SCNNode(geometry: geometryBorder)
      self.scene?.rootNode.addChildNode(borderCubeNode)
  }
}
