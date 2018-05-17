//
//  MAGPoint.swift
//  MagisterGL
//
//  Created by Admin on 16.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

class MAGPoint: NSObject
{
  var position: SCNVector3 = SCNVector3Zero
  var color: SCNVector3 = SCNVector3Zero
  
  init(position: SCNVector3,
       color: SCNVector3)
  {
    self.position = position
    self.color = color
  }
  
}
