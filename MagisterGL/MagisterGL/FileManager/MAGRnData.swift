import UIKit

class MAGRnData: NSObject
{
  public let numberOfTime: Int
  public let numberOfProfileLine: Int
  public var profileChartsData: [[Float]]
  
  init(numberOfTime: Int, numberOfProfileLine: Int, profileChartsData: [[Float]]) {
    self.numberOfTime = numberOfTime
    self.numberOfProfileLine = numberOfProfileLine
    self.profileChartsData = profileChartsData
  }
}
