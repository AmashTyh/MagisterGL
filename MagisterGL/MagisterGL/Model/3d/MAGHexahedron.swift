//
//  MAGHexahedron.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit


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
   
   
   var color: [SCNVector3]
   
   init(positions: [SCNVector3],
        sidesArray: [MAGSide],
        material: Int,
        color: [SCNVector3])
   {
      self.positions = positions
      self.sidesArray = sidesArray
      self.material = material
      self.color = color
   }
   
   func setColorToSides()
   {
      if (self.color.count > 1) {
         for side in sidesArray {
            switch side.positionType {
            case .Left:
               side.color.append(self.color[0])
               side.color.append(self.color[2])
               side.color.append(self.color[6])
               side.color.append(self.color[4])
            case .Front:
               side.color.append(self.color[1])
               side.color.append(self.color[0])
               side.color.append(self.color[4])
               side.color.append(self.color[5])
            case .Bottom:
               side.color.append(self.color[0])
               side.color.append(self.color[1])
               side.color.append(self.color[3])
               side.color.append(self.color[2])
            case .Right:
               side.color.append(self.color[1])
               side.color.append(self.color[5])
               side.color.append(self.color[7])
               side.color.append(self.color[3])
            case .Back:
               side.color.append(self.color[2])
               side.color.append(self.color[3])
               side.color.append(self.color[7])
               side.color.append(self.color[6])
            case .Top:
               side.color.append(self.color[5])
               side.color.append(self.color[4])
               side.color.append(self.color[6])
               side.color.append(self.color[7])
            }
         }
      } else {
         for side in sidesArray {
            for _ in 0..<4
            {
               side.color.append(self.color[0])
            }
         }
      }
      
   }
}
