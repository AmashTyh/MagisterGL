//
//  MAGCrossSection.swift
//  MagisterGL
//
//  Created by Admin on 20.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

enum PlaneType : Int{
   case X = 0
   case Y
   case Z
}

class MAGCrossSection: NSObject
{
   
  var plane: PlaneType
  var value: Float
  var greater: Bool
  
  init(plane: PlaneType,
       value: Float,
    greater: Bool)
  {
    self.plane = plane
    self.value = value
    self.greater = greater
  }
  
  func isVisible(value: Float,
                 minValue: Float,
                 maxValue: Float) -> HexahedronVisible
  {
    if ((minValue <= value) && (value < maxValue))
    {
      if (value >= ((maxValue - minValue) / 2.0) + minValue)
      {
        return .isVisible
      }
      return .notVisible
    }
    else if (maxValue > value)
    {
      return .notVisible
    }
    return .isVisible
  }
   
  func setVisibleToHexahedron(positions: [SCNVector3]) -> HexahedronVisible
  {
    switch plane
    {
    case .X:
      let minValue = positions.min { (first, second) -> Bool in
        return first.x < second.x
        }!.x
      
      let maxValue = positions.max { (first, second) -> Bool in
        return first.x < second.x
        }!.x
      
      return self.isVisible(value: value,
                            minValue: minValue,
                            maxValue: maxValue)
    case .Y:
      let minValue = positions.min { (first, second) -> Bool in
        return first.x < second.x
        }!.y
      
      let maxValue = positions.max { (first, second) -> Bool in
        return first.x < second.x
        }!.y
      
      return self.isVisible(value: value,
                            minValue: minValue,
                            maxValue: maxValue)
    case .Z:
      let minValue = positions.min { (first, second) -> Bool in
        return first.x < second.x
        }!.z
      
      let maxValue = positions.max { (first, second) -> Bool in
        return first.x < second.x
        }!.z
      
      return self.isVisible(value: value,
                            minValue: minValue,
                            maxValue: maxValue)
    }
//    switch plane
//    {
//    case .X:
//      if ((positions[0].x <= value) && (positions[1].x > value) || (positions[2].x <= value)  && (positions[3].x > value)) ||
//        ((positions[4].x <= value) && (positions[5].x > value) || (positions[6].x <= value)  && (positions[7].x > value))
//      {
//        return HexahedronVisible.needSection
//      }
//      else
//      {
//        if greater
//        {
//          if ((positions[0].x < value) && (positions[1].x < value) && (positions[2].x < value) && (positions[3].x < value) &&
//            (positions[4].x < value) && (positions[5].x < value) && (positions[6].x < value) && (positions[7].x < value))
//          {
//            return HexahedronVisible.notVisible
//          }
//        }
//        else
//        {
//          if ((positions[0].x > value) && (positions[1].x > value) && (positions[2].x > value) && (positions[3].x > value) &&
//            (positions[4].x > value) && (positions[5].x > value) && (positions[6].x > value) && (positions[7].x > value))
//          {
//            return HexahedronVisible.notVisible
//          }
//        }
//      }
//
//    case .Y:
//      if ((positions[0].y <= value) && (positions[2].y > value) || (positions[1].y <= value)  && (positions[3].y > value)) ||
//        ((positions[4].y <= value) && (positions[6].y > value) || (positions[5].y <= value)  && (positions[7].y > value))
//      {
//        return HexahedronVisible.needSection
//      }
//
//    case .Z:
//      if ((positions[0].z <= value) && (positions[4].z > value) || (positions[1].z <= value)  && (positions[5].z > value)) ||
//        ((positions[2].z <= value) && (positions[6].z > value) || (positions[3].z <= value)  && (positions[7].z > value))
//      {
//        return HexahedronVisible.needSection
//      }
//    }
    return .isVisible
  }
  
  static func isPointBetweenPoints(point: SCNVector3, firstPoint: SCNVector3, secondPoint: SCNVector3) -> Bool
  {
    return true
  }
}
