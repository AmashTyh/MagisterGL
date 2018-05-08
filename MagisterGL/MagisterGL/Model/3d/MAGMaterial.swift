//
//  MAGMaterial.swift
//  MagisterGL
//
//  Created by Admin on 08.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit


class MAGMaterial: NSObject
{
  let numberOfMaterial: Int
  let color: UIColor
  
  init(numberOfMaterial: Int,
       color: UIColor)
  {
    self.numberOfMaterial = numberOfMaterial
    self.color = color
  }
  
}
