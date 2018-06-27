import UIKit


class MAGProjectFileAddTableViewCellObject: NSObject
{
  var name: String
  var filePathArray: [String]

  init(name: String,
       filePathArray: [String])
  {
    self.name = name
    self.filePathArray = filePathArray
  }
}
