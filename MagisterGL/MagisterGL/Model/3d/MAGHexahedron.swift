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
  var countArray: [Int]
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
       material: Int,
       counts: [Int])
  {
    self.positions = positions
    self.countArray = counts
    self.sidesArray = sidesArray
    self.material = material
  }
  
  func minCount() -> Int
  {
    return self.countArray.min()!
  }
}
