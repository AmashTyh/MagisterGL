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
  let coreDataHelper: MAGProjectsViewModel = MAGProjectsViewModel()
  
  var name: String?
  var cellObjects: [MAGProjectFileAddTableViewCellObject] = []
  
  override init()
  {    
    var array: [MAGProjectFileAddTableViewCellObject] = []
    array.append(MAGProjectFileAddTableViewCellObject(name: "nver",
                                                      filePath: ""))
    array.append(MAGProjectFileAddTableViewCellObject(name: "xyz",
                                                      filePath: ""))
    array.append(MAGProjectFileAddTableViewCellObject(name: "xyz0",
                                                      filePath: ""))
    array.append(MAGProjectFileAddTableViewCellObject(name: "nvkat",
                                                      filePath: ""))
    array.append(MAGProjectFileAddTableViewCellObject(name: "elem_neib",
                                                      filePath: ""))
    array.append(MAGProjectFileAddTableViewCellObject(name: "sig3d",
                                                      filePath: ""))
    array.append(MAGProjectFileAddTableViewCellObject(name: "profile",
                                                      filePath: ""))
    cellObjects = array
  }
  
  func createProject()
  {
    coreDataHelper.addProject(name: self.name!,
                              nverPath: self.cellObjects[0].filePath,
                              xyzPath: self.cellObjects[1].filePath,
                              xyz0FilePath: self.cellObjects[2].filePath,
                              nvkatPath: self.cellObjects[3].filePath,
                              elemNeibPath: self.cellObjects[4].filePath,
                              sigma3dPath: self.cellObjects[5].filePath,
                              profilePath: self.cellObjects[6].filePath,
                              isLocal: false)
  }
}
