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
  
  init(positions: [SCNVector3],
       sidesArray: [MAGSide],
       material: Int)
  {
    self.positions = positions
    self.sidesArray = sidesArray
    self.material = material
  }
}
