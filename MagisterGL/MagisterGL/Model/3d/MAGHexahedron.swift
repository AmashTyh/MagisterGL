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
        sidesArray: [MAGSide],
        material: Int,
        color: [SCNVector3])
   {
      self.positions = positions
      self.sidesArray = sidesArray
      self.material = material
      self.colors = color
   }
   
   func setColorToSides()
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
