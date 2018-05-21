//
//  MAGHexahedron.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit

enum HexahedronVisible
{
  case isVisible
  case notVisible
  case needSection
}

class MAGHexahedron: NSObject
{
  var positions: [SCNVector3]
  /**
   Массив сторон шестигранника - 6 штук
   порядок: левая, передняя, нижняя, правая, задняя, верхняя
   */
  var sidesArray: [MAGSide] = []
  
  var isSideVisibleArray: [Bool] = [true, true, true, true, true, true]
  
  /**
   Массив nvkat для элемента
   */
  var neighbours: [[Int]] = []
  /**
   Массив sosedeyi материалов
   */
  var neibsMaterials: [[Int]] = []
  
  var selectedMaterials: [MAGMaterial] = []
  /**
   Материал - целое число
   */
  var material: Int
  
  /**
   Видимость - три состояния
   0 - не видим
   1 - видим
   2 - через него проходит сечение
   */
  var visible: HexahedronVisible = .isVisible
  
  var colors: [SCNVector3]
  
  init(positions: [SCNVector3],
       neighbours: [[Int]],
       material: Int,
       color: [SCNVector3])
  {
    self.positions = positions
    self.neighbours = neighbours
    self.material = material
    self.colors = color
  }
  
  func generateSides()
  {
    var selectedNumberMaterials: [Int] = []
    
    for material in self.selectedMaterials
    {
      selectedNumberMaterials.append(material.numberOfMaterial)
    }
    
    for i in 0..<6
    {
      if (neighbours[i].count >= 1) && (neighbours[i][0] == 0)
      {
        isSideVisibleArray[i] = true
      }
      else
      {
        isSideVisibleArray[i] = false
      }
    }
    
    sidesArray = [
      MAGSide.init(positions: [positions[0], positions[2], positions[6], positions[4]],
                   positionType: .Left,
                   material: self.material,
                   isVisible: isSideVisibleArray[0]), //левая
      MAGSide.init(positions: [positions[1], positions[0], positions[4], positions[5]],
                   positionType: .Front,
                   material: self.material,
                   isVisible: isSideVisibleArray[1]), //передняя
      MAGSide.init(positions: [positions[0], positions[1], positions[3], positions[2]],
                   positionType: .Bottom,
                   material: self.material,
                   isVisible: isSideVisibleArray[2]), //нижняя
      MAGSide.init(positions: [positions[1], positions[5], positions[7], positions[3]],
                   positionType: .Right,
                   material: self.material,
                   isVisible: isSideVisibleArray[3]), //правая
      MAGSide.init(positions: [positions[2], positions[3], positions[7], positions[6]],
                   positionType: .Back,
                   material: self.material,
                   isVisible: isSideVisibleArray[4]), //задняя
      MAGSide.init(positions: [positions[5], positions[4], positions[6], positions[7]],
                   positionType: .Top,
                   material: self.material,
                   isVisible: isSideVisibleArray[5]),  //верхняя
    ]
    setColorToSides()
  }
  
  
  func setColorToSides()
  {
    if (self.colors.count > 1)
    {
      for side in sidesArray
      {
        switch side.positionType {
        case .Left:
          side.colors.append(self.colors[0])
          side.colors.append(self.colors[2])
          side.colors.append(self.colors[6])
          side.colors.append(self.colors[4])
          side.colors.append(side.generateCenterColor())
          
        case .Front:
          side.colors.append(self.colors[1])
          side.colors.append(self.colors[0])
          side.colors.append(self.colors[4])
          side.colors.append(self.colors[5])
          side.colors.append(side.generateCenterColor())
          
        case .Bottom:
          side.colors.append(self.colors[0])
          side.colors.append(self.colors[1])
          side.colors.append(self.colors[3])
          side.colors.append(self.colors[2])
          side.colors.append(side.generateCenterColor())
          
        case .Right:
          side.colors.append(self.colors[1])
          side.colors.append(self.colors[5])
          side.colors.append(self.colors[7])
          side.colors.append(self.colors[3])
          side.colors.append(side.generateCenterColor())
          
        case .Back:
          side.colors.append(self.colors[2])
          side.colors.append(self.colors[3])
          side.colors.append(self.colors[7])
          side.colors.append(self.colors[6])
          side.colors.append(side.generateCenterColor())
          
        case .Top:
          side.colors.append(self.colors[5])
          side.colors.append(self.colors[4])
          side.colors.append(self.colors[6])
          side.colors.append(self.colors[7])
          side.colors.append(side.generateCenterColor())
        }
      }
    }
    else
    {
      for side in sidesArray
      {
        for _ in 0..<5
        {
          side.colors.append(self.colors[0])
        }
      }
    }
  }
  
}
