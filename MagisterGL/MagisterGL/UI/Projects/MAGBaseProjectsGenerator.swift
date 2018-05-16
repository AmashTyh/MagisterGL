//
//  MAGBaseProjectsGenerator.swift
//  MagisterGL
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit


class MAGBaseProjectsGenerator: NSObject
{
  let baseProjectsGeneratedKey = "BaseProjectsWasGenerated"
  
  let viewModel: MAGProjectsViewModel = MAGProjectsViewModel()
  
  func baseProjects()
  {
    let baseProjectsGenerated = UserDefaults.standard.object(forKey: baseProjectsGeneratedKey) != nil
    if baseProjectsGenerated
    {
      return
    }
    viewModel.addProject(name: "Test 1",
                         nverPath: "nver.txt",
                         xyzPath: "xyz.txt",
                         xyz0FilePath: "",
                         nvkatPath: "nvkat.txt",
                         elemNeibPath: "elem_neib.txt",
                         sigma3dPath: "",
                         profilePath: "",
                         v3FilePathsArray: NSKeyedArchiver.archivedData(withRootObject: ["v3.t1.txt", "v3.t2.txt"]),
                         isLocal: true)
    viewModel.addProject(name: "Test 2",
                         nverPath: "nver2.txt",
                         xyzPath: "xyz2.txt",
                         xyz0FilePath: "",
                         nvkatPath: "nvkat2.txt",
                         elemNeibPath: "elem_neib2.txt",
                         sigma3dPath: "",
                         profilePath: "",
                         v3FilePathsArray: NSKeyedArchiver.archivedData(withRootObject: [""]),
                         isLocal: true)
    viewModel.addProject(name: "Test 3",
                         nverPath: "nver.dat",
                         xyzPath: "xyz.dat",
                         xyz0FilePath: "",
                         nvkatPath: "nvkat.dat",
                         elemNeibPath: "elem_neib",
                         sigma3dPath: "",
                         profilePath: "",
                         v3FilePathsArray: NSKeyedArchiver.archivedData(withRootObject: [""]),
                         isLocal: true)
    viewModel.addProject(name: "Test 4",
                         nverPath: "nver4.dat",
                         xyzPath: "xyz4.dat",
                         xyz0FilePath: "xyz04.dat",
                         nvkatPath: "nvkat4.dat",
                         elemNeibPath: "elem_neib4",
                         sigma3dPath: "Sig3d4",
                         profilePath: "profile4",
                         v3FilePathsArray: NSKeyedArchiver.archivedData(withRootObject: [""]),
                         isLocal: true)
    viewModel.addProject(name: "Test 5",
                         nverPath: "nver5.dat",
                         xyzPath: "xyz5.dat",
                         xyz0FilePath: "xyz05.dat",
                         nvkatPath: "nvkat5.dat",
                         elemNeibPath: "elem_neib5",
                         sigma3dPath: "Sig3d5",
                         profilePath: "profile5",
                         v3FilePathsArray: NSKeyedArchiver.archivedData(withRootObject: [""]),
                         isLocal: true)
    UserDefaults.standard.set("true",
                              forKey: baseProjectsGeneratedKey)
  }
}
