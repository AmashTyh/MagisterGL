//
//  MAGProjectFileAddTableViewCellObject.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 17.04.18.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


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
