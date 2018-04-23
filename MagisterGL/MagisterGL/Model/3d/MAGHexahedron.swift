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
  /**
   Номера элементов соседей
   порядок: [левый], [передний], [нижний], [правый], [задний], [верхний]
   */
  var neighbours: [[Int]] = [[]]
  
  /**
   Вершины элемента
   */
  var positions: [SCNVector3]
  /**
   Массив сторон шестигранника - 6 штук
   порядок: левая, передняя, нижняя, правая, задняя, верхняя
   */
  var sidesArray: [MAGSide] = []
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
  /**
   Цвета - целое число
   */
  var colors: [SCNVector3]
  /**
   Массив видимости сторон шестигранника - 6 штук
   порядок: левая, передняя, нижняя, правая, задняя, верхняя
   */
  var isSideVisibleArray: [Bool] = [true, true, true, true, true, true]
  
  init(positions: [SCNVector3],
       neighbours: [[Int]],
       material: Int,
       colors: [SCNVector3])
  {
    self.positions = positions
    self.neighbours = neighbours
    self.material = material
    self.colors = colors
  }
  
  
  /**
   Используйте, если хотите работать с Side
   */
  func generateSides()
  {
    for i in 0..<6
    {
       if (neighbours[i].count == 1)
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
                   material: material,
                   isVisible: isSideVisibleArray[0]), //левая
      MAGSide.init(positions: [positions[1], positions[0], positions[4], positions[5]],
                   positionType: .Front,
                   material: material,
                   isVisible: isSideVisibleArray[1]), //передняя
      MAGSide.init(positions: [positions[0], positions[1], positions[3], positions[2]],
                   positionType: .Bottom,
                   material: material,
                   isVisible: isSideVisibleArray[2]), //нижняя
      MAGSide.init(positions: [positions[1], positions[5], positions[7], positions[3]],
                   positionType: .Right,
                   material: material,
                   isVisible: isSideVisibleArray[3]), //правая
      MAGSide.init(positions: [positions[2], positions[3], positions[7], positions[6]],
                   positionType: .Back,
                   material: material,
                   isVisible: isSideVisibleArray[4]), //задняя
      MAGSide.init(positions: [positions[5], positions[4], positions[6], positions[7]],
                   positionType: .Top,
                   material: material,
                   isVisible: isSideVisibleArray[5]),  //верхняя
      
    ]
    
    setColorToSides()
  }
  
  
  private func setColorToSides()
  {
    if (self.colors.count > 1) {
      for side in sidesArray {
        //            side.colors.append(SCNVector3(1, 0, 0))
        //            side.colors.append(SCNVector3(0, 0, 1))
        //            side.colors.append(SCNVector3(1, 1, 0))
        //            side.colors.append(SCNVector3(0, 1, 0))
        //            side.generateCenterColor()
        
        switch side.positionType {
        case .Left:
          side.colors.append(self.colors[0])
          side.colors.append(self.colors[2])
          side.colors.append(self.colors[6])
          side.colors.append(self.colors[4])
          side.generateCenterColor()
        case .Front:
          side.colors.append(self.colors[1])
          side.colors.append(self.colors[0])
          side.colors.append(self.colors[4])
          side.colors.append(self.colors[5])
          side.generateCenterColor()
        case .Bottom:
          side.colors.append(self.colors[0])
          side.colors.append(self.colors[1])
          side.colors.append(self.colors[3])
          side.colors.append(self.colors[2])
          side.generateCenterColor()
        case .Right:
          side.colors.append(self.colors[1])
          side.colors.append(self.colors[5])
          side.colors.append(self.colors[7])
          side.colors.append(self.colors[3])
          side.generateCenterColor()
        case .Back:
          side.colors.append(self.colors[2])
          side.colors.append(self.colors[3])
          side.colors.append(self.colors[7])
          side.colors.append(self.colors[6])
          side.generateCenterColor()
        case .Top:
          side.colors.append(self.colors[5])
          side.colors.append(self.colors[4])
          side.colors.append(self.colors[6])
          side.colors.append(self.colors[7])
          side.generateCenterColor()
        }
      }
    } else {
      for side in sidesArray {
        for _ in 0..<5
        {
          side.colors.append(self.colors[0])
        }
      }
    }
  }
}
