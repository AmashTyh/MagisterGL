//
//  MAGCrossSection.swift
//  MagisterGL
//
//  Created by Admin on 20.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

enum PlaneType {
   case X
   case Y
   case Z
}

class MAGCrossSection: NSObject {
   
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
   
  func setVisibleToHexahedron(positions:[SCNVector3]) -> HexahedronVisible
  {
    switch plane {
    case .X:
      if ((positions[0].x <= value) && (positions[1].x > value) || (positions[2].x <= value)  && (positions[3].x > value)) ||
        ((positions[4].x <= value) && (positions[5].x > value) || (positions[6].x <= value)  && (positions[7].x > value)) {
        return HexahedronVisible.needSection
      }
      else {
        if greater {
          if ((positions[0].x < value) && (positions[1].x < value) && (positions[2].x < value) && (positions[3].x < value) &&
            (positions[4].x < value) && (positions[5].x < value) && (positions[6].x < value) && (positions[7].x < value)) {
            return HexahedronVisible.notVisible
          }
        }
        else {
          if ((positions[0].x > value) && (positions[1].x > value) && (positions[2].x > value) && (positions[3].x > value) &&
            (positions[4].x > value) && (positions[5].x > value) && (positions[6].x > value) && (positions[7].x > value)) {
            return HexahedronVisible.notVisible
          }
        }
      }
    case .Y:
      if ((positions[0].y <= value) && (positions[2].y > value) || (positions[1].y <= value)  && (positions[3].y > value)) ||
        ((positions[4].y <= value) && (positions[6].y > value) || (positions[5].y <= value)  && (positions[7].y > value))
      {
        return HexahedronVisible.needSection
      }
    case .Z:
      if ((positions[0].z <= value) && (positions[4].z > value) || (positions[1].z <= value)  && (positions[5].z > value)) ||
        ((positions[2].z <= value) && (positions[6].z > value) || (positions[3].z <= value)  && (positions[7].z > value))
      {
        return HexahedronVisible.needSection
      }
    }
    return HexahedronVisible.isVisible
  }
  
  static func isPointBetweenPoints(point: SCNVector3, firstPoint: SCNVector3, secondPoint: SCNVector3) -> Bool
  {
    return true
  }
}
