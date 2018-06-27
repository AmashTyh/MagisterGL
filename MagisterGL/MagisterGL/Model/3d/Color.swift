import UIKit
import SceneKit

class Color: NSObject
{
   var value: Double = 0.0
   var red: Double = 0
   var green: Double = 0
   var blue: Double = 0
   
   public var color: UIColor
   {
      get
      {
         return UIColor(red: CGFloat(red / 255.0),
                        green:  CGFloat(green / 255.0),
                        blue: CGFloat(blue / 255.0),
                        alpha: 1.0)
      }
   }
   
   public var colorVector: SCNVector3
   {
      get
      {
          return SCNVector3Make(Float(red / 255.0), Float(green / 255.0), Float(blue / 255.0))
      }
   }
   
   override init()
   {
   }
}
