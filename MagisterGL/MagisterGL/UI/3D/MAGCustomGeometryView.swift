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
        ambientLightNode.light?.color = UIColor.white
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
    var globalMaterials : [SCNMaterial] = []
    var globalTextureCords: [CGPoint] = []
    let gradientImageHelper: GradientImageHelper = GradientImageHelper()

    for hexahedron in self.model.elementsArray
    {
      var normals: [SCNVector3] = []
      var indices: [CInt] = []
      for side in hexahedron.sidesArray
      {
        if side.isVisible
        {
          let indicesSide = side.indicesArray(addValue: j * 8)
          
          let indexDataSide = Data(bytes: indicesSide,
                                   count: MemoryLayout<CInt>.size * indicesSide.count)
          let elementSide = SCNGeometryElement(data: indexDataSide,
                                               primitiveType: .triangles,
                                               primitiveCount: indicesSide.count / 3,
                                               bytesPerIndex: MemoryLayout<CInt>.size)
          globalElements.append(elementSide)
          let material = SCNMaterial()
          let gradientImage = gradientImageHelper.gradientImage(size: CGSize(width: 50, height: 50),
                                                          topColorLeft: .red,
                                                          topColorRight: .green,
                                                          bottomColorLeft: .red,
                                                          bottomColorRight: .yellow)
          material.diffuse.contents = gradientImage//self.getColor(material: side.material)
          material.locksAmbientWithDiffuse = true
          globalMaterials.append(material)
          
          normals = normals + side.normalsArray()
          indices = indices + indicesSide
        }
      }
      
      var textureCord: [CGPoint] = []
        textureCord = [
        CGPoint(x: 1, y: 1),
        CGPoint(x: 0, y: 1),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 0),
        ]
      globalTextureCords = globalTextureCords + textureCord + textureCord + textureCord + textureCord + textureCord + textureCord
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
    
    let vertexSource = SCNGeometrySource(vertices: globalPositions)
    let normalSource = SCNGeometrySource(normals: globalNormals)
    let textureSource = SCNGeometrySource(textureCoordinates: globalTextureCords)
    let geometry = SCNGeometry(sources: [vertexSource, normalSource, textureSource],
                               elements: globalElements)
    geometry.materials = globalMaterials
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
    geometryBorder.firstMaterial?.diffuse.contents = UIColor.white
    let borderCubeNode = SCNNode(geometry: geometryBorder)
    self.scene?.rootNode.addChildNode(borderCubeNode)
  }
  
  private func getColor(material: Int) -> UIColor
  {
    if material == 1
    {
      return UIColor.red
    }
    if material == 2
    {
      return UIColor.blue
    }
    if material == 3
    {
      return UIColor.green
    }
    if material == 4
    {
      return UIColor.cyan
    }
    if material == 5
    {
      return UIColor.magenta
    }
    if material == 6
    {
      return UIColor.orange
    }
    return UIColor.yellow
  }
}
