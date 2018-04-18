//
//  MAGSide.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 05.03.18.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import Foundation
import SceneKit


enum PositionType {
  case Left
  case Front
  case Bottom
  case Right
  case Back
  case Top
}


class MAGSide: NSObject
{
  /**
   Массив одной стороны шестигранника - 4 точки
 */
  var positions: [SCNVector3] = []
  var positionType: PositionType
  var isVisible: Bool
  var material: Int
  var color: [SCNVector3] = []
  
  init(positions: [SCNVector3],
       positionType: PositionType,
       material: Int,
       isVisible: Bool)
  {
    self.positions = positions
    self.positionType = positionType
    self.material = material
    self.isVisible = isVisible
  }
  
  func normalsArray() -> [SCNVector3]
  {
    switch positionType
    {
    case .Left:
      return [SCNVector3Make(-1, 0, 0),
              SCNVector3Make(-1, 0, 0),
              SCNVector3Make(-1, 0, 0),
              SCNVector3Make(-1, 0, 0)]
      
    case .Front:
      return [SCNVector3Make(0, 1, 0),
              SCNVector3Make(0, 1, 0),
              SCNVector3Make(0, 1, 0),
              SCNVector3Make(0, 1, 0)]
      
    case .Bottom:
      return [SCNVector3Make( 0, 0, -1),
              SCNVector3Make( 0, 0, -1),
              SCNVector3Make( 0, 0, -1),
              SCNVector3Make( 0, 0, -1)]
      
    case .Right:
      return [SCNVector3Make( 1, 0, 0),
              SCNVector3Make( 1, 0, 0),
              SCNVector3Make( 1, 0, 0),
              SCNVector3Make( 1, 0, 0)]
      
    case .Back:
      return [SCNVector3Make( 0, -1, 0),
              SCNVector3Make( 0, -1, 0),
              SCNVector3Make( 0, -1, 0),
              SCNVector3Make( 0, -1, 0)]
      
    case .Top:
      return [SCNVector3Make( 0, 0, 1),
              SCNVector3Make( 0, 0, 1),
              SCNVector3Make( 0, 0, 1),
              SCNVector3Make( 0, 0, 1)]
    }
  }
    
  func indicesArray(addValue: Int32) -> [Int32]
  {
    return [0 + addValue, 3 + addValue, 1 + addValue,
            3 + addValue, 2 + addValue, 1 + addValue]
  }
  
}
