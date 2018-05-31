import UIKit
import SceneKit

class MAGChartsData: NSObject
{
  var chosenTimeSlice: Int = 0
  
  
  var timeSlicesArray: [Int] = []
  var numbersOfChartLineArray: [Int] = []
  
  var minUValue: Float = 0.0
  var maxUValue: Float = 0.0
  var receivers: [[SCNVector3]] = []
  var chartsValues: [[SCNVector3]] = []
  
  var minZValue: Float = 0.0
  var maxZValue: Float = 0.0
  
  var maxZModel: Float = 0.0
  var delta: Float = 0.0
  
  func generateScaleParameter() -> Float
  {
    return (maxZModel - maxZValue) / (maxUValue - minUValue)
  }
  
  func generateChartsValuesWith(receivers: [[SCNVector3]], rnArray: [MAGRnData], minZValue: Float, maxZValue: Float, maxZModel: Float)
  {
    self.receivers = receivers
    var timeSlices: Set<Int> = Set<Int>()
    var numbersOfChartLine: Set<Int> = Set<Int>()
    for rnData in rnArray {
      timeSlices.insert(rnData.numberOfTime)
      numbersOfChartLine.insert(rnData.numberOfProfileLine)
    }
    
    for timeNumber in timeSlices {
      timeSlicesArray.append(timeNumber)
    }
    timeSlicesArray.sort { (v1, v2) -> Bool in
      return v1 < v2
    }

    for number in numbersOfChartLine {
      numbersOfChartLineArray.append(number)
    }
    numbersOfChartLineArray.sort{ (v1, v2) -> Bool in
      return v1 < v2
    }
    
    var minUValueArray: [Float] = []
    var maxUValueArray: [Float] = []
    var min: Float = 0.0
    var max: Float = 0.0
    
    for i in numbersOfChartLineArray {
      for rnData in rnArray {
        if (rnData.numberOfProfileLine == i) && (rnData.numberOfTime == chosenTimeSlice) {
          // работаем с данными
          var chartsValuesLine: [SCNVector3] = []
          for j in 0..<rnData.profileChartsData.count {
            let vector: SCNVector3 = SCNVector3Make(receivers[i][0].x + rnData.profileChartsData[j][0],
                                                    receivers[i][0].y,
                                                    rnData.profileChartsData[j][1])
            chartsValuesLine.append(vector)
          }
          chartsValues.append(chartsValuesLine)
          if !rnData.profileChartsData.isEmpty {
            min = rnData.profileChartsData.min(by: { (v1, v2) -> Bool in
              return v1[1] < v2[1]
            })![1]
            max = rnData.profileChartsData.max(by: { (v1, v2) -> Bool in
              return v1[1] < v2[1]
            })![1]
            minUValueArray.append(min)
            maxUValueArray.append(max)
          }
        }
      }
    }
    
    minUValue = minUValueArray.min(by: {(v1, v2) -> Bool in
      return v1 < v2
    })!
    maxUValue = maxUValueArray.max(by: {(v1, v2) -> Bool in
      return v1 < v2
    })!
    self.maxZModel = maxZModel
    self.maxZValue = maxZValue
    self.minZValue = minZValue

    
//    var chartsValuesLine: [SCNVector3] = []
//    for i in 0..<rnArray.count {
//      let vector: SCNVector3 = SCNVector3Make(firstReceiver.x + rnArray[i][0], firstReceiver.y, rnArray[i][1])
//      chartsValuesLine.append(vector)
//    }
//    chartsValues.append(chartsValuesLine)
//    if !rnArray.isEmpty {
//      minUValue = rnArray.min(by: { (v1, v2) -> Bool in
//        return v1[1] < v2[1]
//      })![1]
//      maxUValue = rnArray.max(by: { (v1, v2) -> Bool in
//        return v1[1] < v2[1]
//      })![1]
//    }
  }
  
  func updateZValueChartsData(sortedReceivers: [[SCNVector3]])
  {
    self.receivers = sortedReceivers
    
    var resultChartsPoints: [[SCNVector3]] = []
    var tempPoints: [SCNVector3] = []
    
    if (maxZValue > minUValue) {
      delta = fabsf(minUValue) + fabsf(maxZValue)
    }
    //    else {
    //      delta = minUValue - minZValue
    //    }
    
    for chartsLine in receivers
    {
      tempPoints = []
      for vector in chartsLine
      {
        tempPoints.append(SCNVector3Make(vector.x,
                                         vector.y,
                                         Float(MAGRecieversFuncGenerator.uFunc(x: Double(vector.x),
                                                                               y: Double(vector.y),
                                                                               z: Double(vector.z)))))
      }
      resultChartsPoints.append(tempPoints)
    }
    chartsValues = resultChartsPoints
  }
  
}
