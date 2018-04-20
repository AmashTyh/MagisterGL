//
//  MAGProjectCellObject.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

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
