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
    var globalMaterials : [SCNMaterial] = []
    for hexahedron in self.model.elementsArray
    {
      let positions = hexahedron.positions + hexahedron.positions + hexahedron.positions
      globalPositions = globalPositions + positions
      let addValue = j * 24
      
      
      let normalsBottom = [SCNVector3Make( 0, -1, 0),
                           SCNVector3Make( 0, -1, 0),
                           SCNVector3Make( 0, -1, 0),
                           SCNVector3Make( 0, -1, 0)]
      let indicesBottom = [0 + addValue, 2 + addValue, 1 + addValue,
                           1 + addValue, 2 + addValue, 3 + addValue]
      
      let indexDataBottom = Data(bytes: indicesBottom,
                                 count: MemoryLayout<CInt>.size * indicesBottom.count)
      let elementBottom = SCNGeometryElement(data: indexDataBottom,
                                             primitiveType: .triangles,
                                             primitiveCount: indicesBottom.count / 3,
                                             bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementBottom)
      let materialBottom = SCNMaterial()
      materialBottom.diffuse.contents = self.getColor(material: hexahedron.materialsArray[2])
      materialBottom.locksAmbientWithDiffuse = true
      globalMaterials.append(materialBottom)
      
      
      let normalsBack = [SCNVector3Make( 0, 1, 0),
                         SCNVector3Make( 0, 1, 0),
                         SCNVector3Make( 0, 1, 0),
                         SCNVector3Make( 0, 1, 0),]
      let indicesBack = [ 10 + addValue, 14 + addValue, 11 + addValue,  // 2, 6, 3,   + 8
        11 + addValue, 14 + addValue, 15 + addValue,  // 3, 6, 7,   + 8
      ]
      
      let indexDataBack = Data(bytes: indicesBack,
                               count: MemoryLayout<CInt>.size * indicesBack.count)
      let elementBack = SCNGeometryElement(data: indexDataBack,
                                           primitiveType: .triangles,
                                           primitiveCount: indicesBack.count / 3,
                                           bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementBack)
      let materialBack = SCNMaterial()
      materialBack.diffuse.contents = self.getColor(material: hexahedron.materialsArray[4])
      materialBack.locksAmbientWithDiffuse = true
      globalMaterials.append(materialBack)
      
      
      let normalsLeft = [SCNVector3Make( 0, 0,  1),
                         SCNVector3Make( 0, 0,  1),
                         SCNVector3Make( 0, 0, -1),
                         SCNVector3Make( 0, 0, -1),]
      let indicesLeft = [16 + addValue, 20 + addValue, 18 + addValue,  // 0, 4, 2,   + 16
        18 + addValue, 20 + addValue, 22 + addValue,  // 2, 4, 6,   + 16
      ]
      
      let indexDataLeft = Data(bytes: indicesLeft,
                               count: MemoryLayout<CInt>.size * indicesLeft.count)
      let elementLeft = SCNGeometryElement(data: indexDataLeft,
                                           primitiveType: .triangles,
                                           primitiveCount: indicesLeft.count / 3,
                                           bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementLeft)
      let materialLeft = SCNMaterial()
      materialLeft.diffuse.contents = self.getColor(material: hexahedron.materialsArray[0])
      materialLeft.locksAmbientWithDiffuse = true
      globalMaterials.append(materialLeft)
      
      
      let normalsRight = [SCNVector3Make( 0, 0, 1),
                          SCNVector3Make( 0, 0, 1),
                          SCNVector3Make( 0, 0, -1),
                          SCNVector3Make( 0, 0, -1),]
      let indicesRight = [17 + addValue, 19 + addValue, 21 + addValue,  // 1, 3, 5,   + 16
        19 + addValue, 23 + addValue, 21 + addValue,  // 3, 7, 5,   + 16
      ]
      
      let indexDataRight = Data(bytes: indicesRight,
                                count: MemoryLayout<CInt>.size * indicesRight.count)
      let elementRight = SCNGeometryElement(data: indexDataRight,
                                            primitiveType: .triangles,
                                            primitiveCount: indicesRight.count / 3,
                                            bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementRight)
      let materialRight = SCNMaterial()
      materialRight.diffuse.contents = self.getColor(material: hexahedron.materialsArray[3])
      materialRight.locksAmbientWithDiffuse = true
      globalMaterials.append(materialRight)
      
      
      let normalsFront = [SCNVector3Make(-1, 0, 0),
                          SCNVector3Make( 1, 0, 0),
                          SCNVector3Make(-1, 0, 0),
                          SCNVector3Make( 1, 0, 0),]
      let indicesFront = [8 + addValue,  9 + addValue, 12 + addValue,  // 0, 1, 4,   + 8
        9 + addValue, 13 + addValue, 12 + addValue,  // 1, 5, 4,   + 8
      ]
      
      let indexDataFront = Data(bytes: indicesFront,
                                count: MemoryLayout<CInt>.size * indicesFront.count)
      let elementFront = SCNGeometryElement(data: indexDataFront,
                                            primitiveType: .triangles,
                                            primitiveCount: indicesFront.count / 3,
                                            bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementFront)
      let materialFront = SCNMaterial()
      materialFront.diffuse.contents = self.getColor(material: hexahedron.materialsArray[1])
      materialFront.locksAmbientWithDiffuse = true
      globalMaterials.append(materialFront)
      
      
      let normalsTop = [SCNVector3Make(-1, 0, 0),
                        SCNVector3Make( 1, 0, 0),
                        SCNVector3Make(-1, 0, 0),
                        SCNVector3Make( 1, 0, 0),]
      let indicesTop = [4 + addValue, 5 + addValue, 6 + addValue,
                        5 + addValue, 7 + addValue, 6 + addValue
      ]
      
      let indexDataTop = Data(bytes: indicesTop,
                              count: MemoryLayout<CInt>.size * indicesTop.count)
      let elementTop = SCNGeometryElement(data: indexDataTop,
                                          primitiveType: .triangles,
                                          primitiveCount: indicesTop.count / 3,
                                          bytesPerIndex: MemoryLayout<CInt>.size)
      globalElements.append(elementTop)
      let materialTop = SCNMaterial()
      materialTop.diffuse.contents = self.getColor(material: hexahedron.materialsArray[5])
      materialTop.locksAmbientWithDiffuse = true
      globalMaterials.append(materialTop)
      
      
      let normals = [
        SCNVector3Make( 0, -1, 0),
        SCNVector3Make( 0, -1, 0),
        SCNVector3Make( 0, -1, 0),
        SCNVector3Make( 0, -1, 0),
        
        SCNVector3Make( 0, 1, 0),
        SCNVector3Make( 0, 1, 0),
        SCNVector3Make( 0, 1, 0),
        SCNVector3Make( 0, 1, 0),
        
        
        SCNVector3Make( 0, 0,  1),
        SCNVector3Make( 0, 0,  1),
        SCNVector3Make( 0, 0, -1),
        SCNVector3Make( 0, 0, -1),
        
        SCNVector3Make( 0, 0, 1),
        SCNVector3Make( 0, 0, 1),
        SCNVector3Make( 0, 0, -1),
        SCNVector3Make( 0, 0, -1),
        
        
        SCNVector3Make(-1, 0, 0),
        SCNVector3Make( 1, 0, 0),
        SCNVector3Make(-1, 0, 0),
        SCNVector3Make( 1, 0, 0),
        
        SCNVector3Make(-1, 0, 0),
        SCNVector3Make( 1, 0, 0),
        SCNVector3Make(-1, 0, 0),
        SCNVector3Make( 1, 0, 0),
        ]
      globalNormals = globalNormals + normals
      let indices = [
        // bottom
        0 + addValue, 2 + addValue, 1 + addValue,
        1 + addValue, 2 + addValue, 3 + addValue,
        // back
        10 + addValue, 14 + addValue, 11 + addValue,  // 2, 6, 3,   + 8
        11 + addValue, 14 + addValue, 15 + addValue,  // 3, 6, 7,   + 8
        // left
        16 + addValue, 20 + addValue, 18 + addValue,  // 0, 4, 2,   + 16
        18 + addValue, 20 + addValue, 22 + addValue,  // 2, 4, 6,   + 16
        // right
        17 + addValue, 19 + addValue, 21 + addValue,  // 1, 3, 5,   + 16
        19 + addValue, 23 + addValue, 21 + addValue,  // 3, 7, 5,   + 16
        // front
        8 + addValue,  9 + addValue, 12 + addValue,  // 0, 1, 4,   + 8
        9 + addValue, 13 + addValue, 12 + addValue,  // 1, 5, 4,   + 8
        // top
        4 + addValue, 5 + addValue, 6 + addValue,
        5 + addValue, 7 + addValue, 6 + addValue
        ] as [CInt]
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
    geometry.materials = globalMaterials
    let cubeNode = SCNNode(geometry: geometry)
    self.scene?.rootNode.addChildNode(cubeNode)
    
    let indexDataCarcas = Data(bytes: globalIndiciesCarcas,
                               count: MemoryLayout<CInt>.size * globalIndiciesCarcas.count)
    let elementBorder = SCNGeometryElement(data: indexDataCarcas,
                                           primitiveType: .line,
                                           primitiveCount: globalIndiciesCarcas.count / 2,
                                           bytesPerIndex: MemoryLayout<CInt>.size)
    let geometryBorder = SCNGeometry(sources: [vertexSource, normalSource],
                                     elements: [elementBorder])
    geometryBorder.firstMaterial?.diffuse.contents = UIColor.red
    let borderCubeNode = SCNNode(geometry: geometryBorder)
    self.scene?.rootNode.addChildNode(borderCubeNode)
  }
  
  private func getColor(material: Int) -> UIColor
  {
    if material == 0
    {
      return UIColor.red
    }
    if material == 1
    {
      return UIColor.blue
    }
    return UIColor.green
  }
}
