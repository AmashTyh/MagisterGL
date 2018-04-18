//
//  MAGCreateProjectViewModel.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 17.04.18.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit


class MAGCreateProjectViewModel: NSObject
{

  func cellObjects() -> [MAGProjectFileAddTableViewCellObject]
  {
    var array: [MAGProjectFileAddTableViewCellObject] = []
    array.append(MAGProjectFileAddTableViewCellObject(name: "nvkat"))
    array.append(MAGProjectFileAddTableViewCellObject(name: "xyz"))
    array.append(MAGProjectFileAddTableViewCellObject(name: "nver"))
    array.append(MAGProjectFileAddTableViewCellObject(name: "elem_neib"))
    return array
  }
}
