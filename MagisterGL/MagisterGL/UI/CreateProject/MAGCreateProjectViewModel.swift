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
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "xyz",
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "nvkat",
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "elem_neib",
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "sig3d",
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "profile",
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "edsallPath",
                                                      filePathArray: []))
    array.append(MAGProjectFileAddTableViewCellObject(name: "rnArray",
                                                      filePathArray: []))
    cellObjects = array
  }
  
  func createProject()
  {
    coreDataHelper.addProject(name: self.name!,
                              nverPath: self.cellObjects[0].filePathArray.first!,
                              xyzPath: self.cellObjects[1].filePathArray.first!,
                              nvkatPath: self.cellObjects[2].filePathArray.first!,
                              elemNeibPath: self.cellObjects[3].filePathArray.first!,
                              sigma3dPath: self.cellObjects[4].filePathArray.first!,
                              profilePath: self.cellObjects[5].filePathArray.first!,
                              edsallPath: self.cellObjects[6].filePathArray.first!,
                              rnArrayPathsArray: NSKeyedArchiver.archivedData(withRootObject: self.cellObjects[7].filePathArray),
                              isLocal: false)
  }
}
