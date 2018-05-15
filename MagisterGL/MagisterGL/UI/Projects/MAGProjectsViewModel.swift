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
                  xyz0FilePath: String,
                  nvkatPath: String,
                  elemNeibPath: String,
                  sigma3dPath: String,
                  profilePath: String,
                  isLocal: Bool)
  {
    let newEntity = NSEntityDescription.insertNewObject(forEntityName: "MAGProject",
                                                        into: self.persistentContainer.viewContext) as! MAGProject
   
    newEntity.name = name
    newEntity.nverFilePath = nverPath
    newEntity.nvkatFilePath = nvkatPath
    newEntity.xyzFilePath = xyzPath
    newEntity.xyz0FilePath = xyz0FilePath
    newEntity.elemNeibFilePath = elemNeibPath
    newEntity.sigma3dPath = sigma3dPath
    newEntity.profilePath = profilePath
    newEntity.isLocal = isLocal
    
    do
    {
      try self.persistentContainer.viewContext.save()
    }
    catch
    {
    }
  }

}
