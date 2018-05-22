import UIKit
import SceneKit

class MAGChartsData: NSObject
{
  var minUValue: Float = 0.0
  var maxUValue: Float = 0.0
  var receivers: [[SCNVector3]] = []
  var chartsValues: [[SCNVector3]] = []
  
  var minZValue: Float = 0.0
  private var delta: Float = 0.0
  
  
  func updateZValueChartsData(sortedReceivers: [[SCNVector3]])
  {
    self.receivers = sortedReceivers
    
    var resultChartsPoints: [[SCNVector3]] = []
    var tempPoints: [SCNVector3] = []
    
    if (minZValue > minUValue) {
      delta = fabsf(minUValue) + fabsf(minZValue)
    }
    
    for chartsLine in receivers
    {
      tempPoints = []
      for vector in chartsLine
      {
        tempPoints.append(SCNVector3Make(vector.x,
                                         vector.y,
                                         Float(MAGRecieversFuncGenerator.uFunc(x: Double(vector.x),
                                                                               y: Double(vector.y),
                                                                               z: Double(vector.z))) + delta))
      }
      resultChartsPoints.append(tempPoints)
    }
    

    
    
    
    
    chartsValues = resultChartsPoints
  }
}
