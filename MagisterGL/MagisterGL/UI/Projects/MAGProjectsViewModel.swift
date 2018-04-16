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
        let cellObject = MAGProjectCellObject(name: entity.name!)
        array.append(cellObject)
      }
    }
    catch
    {
    }
    return array
  }
  
  func addProject()
  {
    let newEntity = NSEntityDescription.insertNewObject(forEntityName: "MAGProject",
                                                        into: self.persistentContainer.viewContext) as! MAGProject
   
    newEntity.name = "kjdfglkdf"
    
    do
    {
      try self.persistentContainer.viewContext.save()
    }
    catch
    {
    }
  }

}
