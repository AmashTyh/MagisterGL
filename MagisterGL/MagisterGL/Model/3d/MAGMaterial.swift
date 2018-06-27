import UIKit
import SceneKit


class MAGMaterial: NSObject
{
  let numberOfMaterial: Int
  let color: SCNVector3
  
  init(numberOfMaterial: Int,
       color: SCNVector3)
  {
    self.numberOfMaterial = numberOfMaterial
    self.color = color
  }
  
}
