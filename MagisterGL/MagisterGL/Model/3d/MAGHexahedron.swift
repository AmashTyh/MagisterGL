//
//  MAGHexahedron.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit


class MAGHexahedron: NSObject
{
  var positions: [SCNVector3];
  var countArray: [Int];
  var materialsArray: [Int] = []
  
  init(positions: [SCNVector3],
       counts: [Int],
      materialsArray: [Int])
  {
    self.positions = positions
    self.countArray = counts
    self.materialsArray = materialsArray
  }
  
  func minCount() -> Int
  {
    return self.countArray.min()!
  }
  
}
