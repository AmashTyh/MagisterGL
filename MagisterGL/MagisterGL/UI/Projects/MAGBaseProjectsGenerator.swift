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
                         nverPath: Bundle.main.path(forResource: "nver",
                                                    ofType: "txt")!,
                         xyzPath: Bundle.main.path(forResource: "xyz",
                                                   ofType: "txt")!,
                         nvkatPath: Bundle.main.path(forResource: "nvkat",
                                                     ofType: "txt")!,
                         elemNeibPath: Bundle.main.path(forResource: "elem_neib",
                                                        ofType: "txt")!,
                         isLocal: true)
    viewModel.addProject(name: "Test 2",
                         nverPath: Bundle.main.path(forResource: "nver2",
                                                    ofType: "txt")!,
                         xyzPath: Bundle.main.path(forResource: "xyz2",
                                                   ofType: "txt")!,
                         nvkatPath: Bundle.main.path(forResource: "nvkat2",
                                                     ofType: "txt")!,
                         elemNeibPath: Bundle.main.path(forResource: "elem_neib2",
                                                        ofType: "txt")!,
                         isLocal: true)
    viewModel.addProject(name: "Test 3",
                         nverPath: Bundle.main.path(forResource: "nver",
                                                    ofType: "dat")!,
                         xyzPath: Bundle.main.path(forResource: "xyz",
                                                   ofType: "dat")!,
                         nvkatPath: Bundle.main.path(forResource: "nvkat",
                                                     ofType: "dat")!,
                         elemNeibPath: Bundle.main.path(forResource: "elem_neib",
                                                        ofType: "")!,
                         isLocal: true)
    viewModel.addProject(name: "Test 4",
                         nverPath: Bundle.main.path(forResource: "nver4",
                                                    ofType: "dat")!,
                         xyzPath: Bundle.main.path(forResource: "xyz4",
                                                   ofType: "dat")!,
                         nvkatPath: Bundle.main.path(forResource: "nvkat4",
                                                     ofType: "dat")!,
                         elemNeibPath: Bundle.main.path(forResource: "elem_neib4",
                                                        ofType: "")!,
                         isLocal: true)
    viewModel.addProject(name: "Test 5",
                         nverPath: Bundle.main.path(forResource: "nver5",
                                                    ofType: "dat")!,
                         xyzPath: Bundle.main.path(forResource: "xyz5",
                                                   ofType: "dat")!,
                         nvkatPath: Bundle.main.path(forResource: "nvkat5",
                                                     ofType: "dat")!,
                         elemNeibPath: Bundle.main.path(forResource: "elem_neib5",
                                                        ofType: "")!,
                         isLocal: true)
    UserDefaults.standard.set("true",
                              forKey: baseProjectsGeneratedKey)
  }
}
