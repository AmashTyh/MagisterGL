//
//  MAGProjectsViewModel.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit
import CoreData

class MAGProjectsViewModel: NSObject
{
  // MARK: - Core Data stack
  
  //TODO: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/InitializingtheCoreDataStack.html#//apple_ref/doc/uid/TP40001075-CH4-SW1
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "MAGProjectsModels")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func cellObjects() -> [MAGProjectCellObject]
  {
    var array: [MAGProjectCellObject] = []
    
    //TODO: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/FetchingObjects.html#//apple_ref/doc/uid/TP40001075-CH6-SW1
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MAGProject")
    do
    {
      let fetchedEntities = try self.persistentContainer.viewContext.fetch(fetchRequest) as! [MAGProject]
      for entity in fetchedEntities
      {
        let cellObject = MAGProjectCellObject(name: entity.name!,
                                              project: entity)
        array.append(cellObject)
      }
    }
    catch
    {
    }
    return array
  }
  
  // Передать все параметры проекта (название, урлы)
  func addProject(name: String,
                  nverPath: String,
                  xyzPath: String,
                  nvkatPath: String,
                  elemNeibPath: String,
                  sigma3dPath: String,
                  profilePath: String,
                  edsallPath: String,
                  rnArrayPathsArray: Data,
                  isLocal: Bool)
  {
    let newEntity = NSEntityDescription.insertNewObject(forEntityName: "MAGProject",
                                                        into: self.persistentContainer.viewContext) as! MAGProject
   
    newEntity.name = name
    newEntity.nverFilePath = nverPath
    newEntity.nvkatFilePath = nvkatPath
    newEntity.xyzFilePath = xyzPath
    newEntity.elemNeibFilePath = elemNeibPath
    newEntity.sigma3dPath = sigma3dPath
    newEntity.profilePath = profilePath
    newEntity.isLocal = isLocal
    newEntity.edsallPath = edsallPath
    newEntity.rnArrayPathsArray = rnArrayPathsArray
    
    do
    {
      try self.persistentContainer.viewContext.save()
    }
    catch
    {
    }
  }

}
