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
  
  init(positions: [SCNVector3],
       positionType: PositionType,
       material: Int,
       isVisible: Bool)
  {
    self.positions = positions
    self.positionType = positionType
    self.isVisible = isVisible
    self.material = material
  }
  
  func normalsArray() -> [SCNVector3]
  {
    switch positionType
    {
    case .Left:
      return [SCNVector3Make( 0, 0,  1),
              SCNVector3Make( 0, 0,  1),
              SCNVector3Make( 0, 0, -1),
              SCNVector3Make( 0, 0, -1)]

    case .Front:
      return [SCNVector3Make(-1, 0, 0),
              SCNVector3Make( 1, 0, 0),
              SCNVector3Make(-1, 0, 0),
              SCNVector3Make( 1, 0, 0),]

    case .Bottom:
      return [SCNVector3Make( 0, -1, 0),
              SCNVector3Make( 0, -1, 0),
              SCNVector3Make( 0, -1, 0),
              SCNVector3Make( 0, -1, 0)]

    case .Right:
      return [SCNVector3Make( 0, 0, 1),
              SCNVector3Make( 0, 0, 1),
              SCNVector3Make( 0, 0, -1),
              SCNVector3Make( 0, 0, -1),]

    case .Back:
      return [SCNVector3Make( 0, 1, 0),
              SCNVector3Make( 0, 1, 0),
              SCNVector3Make( 0, 1, 0),
              SCNVector3Make( 0, 1, 0),]

    case .Top:
      return [SCNVector3Make(-1, 0, 0),
              SCNVector3Make( 1, 0, 0),
              SCNVector3Make(-1, 0, 0),
              SCNVector3Make( 1, 0, 0),]
    }
  }
  
  func indicesArray(addValue: Int32) -> [Int32]
  {
    switch positionType
    {
    case .Left:
      return [0 + addValue, 4 + addValue, 2 + addValue,  // 0, 4, 2,   + 16
              2 + addValue, 4 + addValue, 6 + addValue,  // 2, 4, 6,   + 16
              ]
      
    case .Front:
      return [0 + addValue,  1 + addValue, 4 + addValue,  // 0, 1, 4,   + 8
              1 + addValue, 5 + addValue, 4 + addValue,  // 1, 5, 4,   + 8
              ]
      
    case .Bottom:
      return [0 + addValue, 2 + addValue, 1 + addValue,
              1 + addValue, 2 + addValue, 3 + addValue]
      
    case .Right:
      return [1 + addValue, 3 + addValue, 5 + addValue,  // 1, 3, 5,   + 16
              3 + addValue, 7 + addValue, 5 + addValue,  // 3, 7, 5,   + 16
              ]
      
    case .Back:
      return [2 + addValue, 6 + addValue, 3 + addValue,  // 2, 6, 3,   + 8
              3 + addValue, 6 + addValue, 7 + addValue,  // 3, 6, 7,   + 8
              ]

      
    case .Top:
      return [4 + addValue, 5 + addValue, 6 + addValue,
              5 + addValue, 7 + addValue, 6 + addValue]
    }
  }
  
}
