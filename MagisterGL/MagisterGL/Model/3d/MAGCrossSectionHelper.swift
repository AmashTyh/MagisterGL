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
   Третья точка на отрезке с концами с первой и второй
   */
  static func isPointAtEdge(first: SCNVector3,
                            second: SCNVector3,
                            third: SCNVector3,
                            sectionType: PlaneType) -> Bool
  {
    if (sectionType == .X) {
      if (first.x <= third.x && second.x >= third.x)
        || (second.x <= third.x && first.x >= third.x) {
        return true
      } else {
        return false
      }
    } else {
      if (sectionType == .Y) {
        if (first.y <= third.y && second.y >= third.y)
          || (second.y <= third.y && first.y >= third.y) {
          return true
        } else {
          return false
        }
      }
      else {
        if (first.z <= third.z && second.z >= third.z)
          || (second.z <= third.z && first.z >= third.z) {
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
    var points: [SCNVector3] = []
    
    for side in hexahedron.sidesArray
    {
      let arrayIndex = [0, 1, 2, 3, 0]
      
      for i in 0..<4
      {
        if isSectionAtEdge(first: side.positions[arrayIndex[i]],
                           second: side.positions[arrayIndex[i + 1]],
                           sectionType: sectionType,
                           sectionValue: sectionValue)
        {
          let intersectionPoint = getIntersectionPointOf(lineFirstPoint: side.positions[arrayIndex[i]],
                                                         lineSecondPoint: side.positions[arrayIndex[i + 1]],
                                                         sectionAxis: sectionType,
                                                         sectionValue: sectionValue)
          if !checkPoints(points: points,
                         hasPoint: intersectionPoint.point)
          {
            points.append(intersectionPoint.point)
          }
        }
      }
    }
    
    if points.count >= 4
    {
      return [points[0], points[1], points[3], points[2]]
    }
    return points
  }
  
  static func checkPoints(points: [SCNVector3],
                          hasPoint: SCNVector3) -> Bool
  {
    for point in points
    {
      if isEqualToFloat(first: point.x, second: hasPoint.x) &&
      isEqualToFloat(first: point.y, second: hasPoint.y) &&
      isEqualToFloat(first: point.z, second: hasPoint.z)
      {
        return true
      }
    }
    return false
  }
  
  
  
  

//  static func getPointsOfXIntersectionWith(hexahedron: MAGHexahedron,
//                                          sectionValue: Float) -> [SCNVector3]
//  {
//    var resultsPoints: [SCNVector3] = []
//
//    let interPoint1: (point: SCNVector3, error: Bool) = getIntersectionPointOf(lineFirstPoint: hexahedron.positions[0],
//                                                                               lineSecondPoint: hexahedron.positions[1],
//                                                                               sectionAxis: .X,
//                                                                               sectionValue: sectionValue)
//    let interPoint2: (point: SCNVector3, error: Bool) = getIntersectionPointOf(lineFirstPoint: hexahedron.positions[0],
//                                                                               lineSecondPoint: hexahedron.positions[2],
//                                                                               sectionAxis: .X,
//                                                                               sectionValue: sectionValue)
//    let interPoint3: (point: SCNVector3, error: Bool) = getIntersectionPointOf(lineFirstPoint: hexahedron.positions[1],
//                                                                               lineSecondPoint: hexahedron.positions[3],
//                                                                               sectionAxis: .X,
//                                                                               sectionValue: sectionValue)
//
//    let interPoint4: (point: SCNVector3, error: Bool) = getIntersectionPointOf(lineFirstPoint: hexahedron.positions[2],
//                                                                               lineSecondPoint: hexahedron.positions[3],
//                                                                               sectionAxis: .X,
//                                                                               sectionValue: sectionValue)
//
//    if (interPoint1.error == false) && isPointAtEdge(first: hexahedron.positions[0],
//                                                     second: hexahedron.positions[1],
//                                                     third: interPoint1.point,
//                                                     sectionType: .X) {
//      resultsPoints.append(interPoint1.point)
//    }
//
//    if (interPoint2.error == false) && isPointAtEdge(first: hexahedron.positions[0],
//                                                     second: hexahedron.positions[2],
//                                                     third: interPoint2.point,
//                                                     sectionType: .X) {
//      resultsPoints.append(interPoint2.point)
//    }
//    if (interPoint3.error == false) && isPointAtEdge(first: hexahedron.positions[1],
//                                                     second: hexahedron.positions[3],
//                                                     third: interPoint3.point,
//                                                     sectionType: .X) {
//      resultsPoints.append(interPoint3.point)
//    }
//    if (interPoint4.error == false) && isPointAtEdge(first: hexahedron.positions[2],
//                                                     second: hexahedron.positions[3],
//                                                     third: interPoint4.point,
//                                                     sectionType: .X) {
//      resultsPoints.append(interPoint4.point)
//    }
//
//
//    return resultsPoints
//  }
  
  
  
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
