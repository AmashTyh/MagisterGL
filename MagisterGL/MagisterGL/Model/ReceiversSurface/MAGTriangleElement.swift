import UIKit
import SceneKit

class MAGTriangleElement: NSObject
{
  public var colors: [SCNVector3]
  public var positions: [SCNVector3]

  
  init(positions: [SCNVector3],
       colors:  [SCNVector3])
  {
    self.positions = positions
    self.colors = colors
  }
  
  func indicesArray(addValue: Int32) -> [Int32]
  {
    return [0 + addValue, 1 + addValue, 2 + addValue]
  }
}
