//
//  MAGCrossSectionHelper.swift
//  MagisterGL
//
//  Created by Admin on 02.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

class MAGCrossSectionHelper: NSObject {
  /**
   Использовать эту функцию, когда прямые не совпадают и не паралллельны друг другу!
   иначе error = true!
  */
  static func getIntersectionPointOf(lineFirstPoint: SCNVector3,
                                     lineSecondPoint: SCNVector3,
                                     sectionAxis: PlaneType,
                                     sectionValue: Float) -> (point: SCNVector3, error: Bool)
  {
    var x: Float = 0.0, y: Float = 0.0, z: Float = 0.0
    var t: Float = 0.0
    var error = false
    
    // направляющий вектор прямой
    let p1: Float = lineSecondPoint.x - lineFirstPoint.x
    let p2: Float = lineSecondPoint.y - lineFirstPoint.y
    let p3: Float = lineSecondPoint.z - lineFirstPoint.z
    
    // ось Х
    if (sectionAxis == PlaneType.X) {
      if isEqualToFloat(first: p1, second: 0.0) {
        error = true
        return (SCNVector3(x, y, z), error)
      }
      t = (sectionValue - lineFirstPoint.x) / p1
      
      x = sectionValue
      y = p2 * t + lineFirstPoint.y
      z = p3 * t + lineFirstPoint.z
      
      return (SCNVector3(x,y,z), error)
    }
    else { // ось Y
      if (sectionAxis == PlaneType.Y) {
        if isEqualToFloat(first: p2, second: 0.0) {
          error = true
          return (SCNVector3(x, y, z), error)
        }
        t = (sectionValue - lineFirstPoint.y) / p2
        
        x = p1 * t + lineFirstPoint.x
        y = sectionValue
        z = p3 * t + lineFirstPoint.z
        
        return (SCNVector3(x,y,z), error)
      }
      else { // ось Z
        if isEqualToFloat(first: p3, second: 0.0) {
          error = true
          return (SCNVector3(x, y, z), error)
        }
        t = (sectionValue - lineFirstPoint.z) / p3
        
        x = p1 * t + lineFirstPoint.x
        y = p2 * t + lineFirstPoint.y
        z = sectionValue
        
        return (SCNVector3(x,y,z), error)
      }
    }
  }
  
  static private func isEqualToFloat(first: Float, second: Float) -> Bool
  {
    if (fabs(Double(first - second)) <= 0.0000001) {
      return true
    }
    return false
  }
  
  static func isSectionAtEdge(first: SCNVector3,
                              second: SCNVector3,
                              sectionType: PlaneType,
                              sectionValue: Float) -> Bool
  {
    if (sectionType == .X) {
      if (first.x <= sectionValue && second.x >= sectionValue)
        || (second.x <= sectionValue && first.x >= sectionValue) {
        return true
      } else {
        return false
      }
    } else {
      if (sectionType == .Y) {
        if (first.y <= sectionValue && second.y >= sectionValue)
          || (second.y <= sectionValue && first.y >= sectionValue) {
          return true
        } else {
          return false
        }
      }
      else {
        if (first.z <= sectionValue && second.z >= sectionValue)
          || (second.z <= sectionValue && first.z >= sectionValue) {
          return true
        } else {
          return false
        }
      }
    }
  }
  
  /**
   Функция для поиска точек пересечения плоскости сечения и элемента
   */
  static func getPointsOfIntersectionWith(hexahedron: MAGHexahedron,
                                          sectionType: PlaneType,
                                          sectionValue: Float) -> [SCNVector3]
  {
     return []
  }
  
  
  
  /**
   Функция для поиска точек пересечения плоскости сечения и элемента
  */
//  static func getPointsOfIntersectionWith(hexahedron: MAGHexahedron,
//                                          sectionType: PlaneType,
//                                          sectionValue: Float) -> [SCNVector3]
//  {
//    var intersectionPoints: [SCNVector3] = []
//    if (isSectionAtEdge(first: hexahedron.positions[0],
//                        second: hexahedron.positions[1],
//                        sectionType: sectionType,
//                        sectionValue: sectionValue)) {
//      let interPoint: (point: SCNVector3, error: Bool) = getIntersectionPointOf(lineFirstPoint: hexahedron.positions[0],
//                                              lineSecondPoint: hexahedron.positions[1],
//                                              sectionAxis: sectionType,
//                                              sectionValue: sectionValue)
//      if (interPoint.error == false) {
//
//      }
//      else {
//
//        // TODO: обработать случай
//        switch sectionType
//        {
//        case .X:
//          if (isEqualToFloat(first: hexahedron.positions[0].x, second: sectionValue)) {
//            intersectionPoints += [hexahedron.positions[0], secondPoint]
//          }
//        case .Y:
//          if (isEqualToFloat(first: hexahedron.positions[0].y, second: sectionValue)) {
//
//          }
//        case .Z:
//          if (isEqualToFloat(first: hexahedron.positions[0].z, second: sectionValue)) {
//
//          }
//        }
//
//
//
//      }
//
//    }
//  }
  
}
