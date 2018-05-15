//
//  MAGMaterial.swift
//  MagisterGL
//
//  Created by Admin on 08.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


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
