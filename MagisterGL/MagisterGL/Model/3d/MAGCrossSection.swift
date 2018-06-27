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
    if (greater)
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
    else
    {
      if ((minValue <= value) && (value < maxValue))
      {
        if (value < ((maxValue - minValue) / 2.0) + minValue)
        {
          return .isVisible
        }
        return .notVisible
      }
      else if (maxValue < value)
      {
        return .notVisible
      }
      return .isVisible
    }

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
        return first.y < second.y
        }!.y
      
      let maxValue = positions.max { (first, second) -> Bool in
        return first.y < second.y
        }!.y
      
      return self.isVisible(value: value,
                            minValue: minValue,
                            maxValue: maxValue)
    case .Z:
      let minValue = positions.min { (first, second) -> Bool in
        return first.z < second.z
        }!.z
      
      let maxValue = positions.max { (first, second) -> Bool in
        return first.z < second.z
        }!.z
      
      return self.isVisible(value: value,
                            minValue: minValue,
                            maxValue: maxValue)
    }
  }
}
