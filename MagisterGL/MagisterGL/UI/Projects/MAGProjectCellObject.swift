import UIKit

class MAGProjectCellObject: NSObject
{
  var name: String
  var project: MAGProject
  
  init(name: String,
       project: MAGProject)
  {
    self.name = name
    self.project = project
  }
}
