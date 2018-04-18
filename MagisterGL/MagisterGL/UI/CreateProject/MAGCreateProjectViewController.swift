//
//  MAGCreateProjectViewController.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGCreateProjectViewController: UIViewController,
                                      UITableViewDelegate,
                                      UITableViewDataSource
{
  
  let viewModel: MAGCreateProjectViewModel = MAGCreateProjectViewModel()
  
  var cellObjects: [MAGProjectFileAddTableViewCellObject] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UINib.init(nibName: "MAGProjectFileAddTableViewCell",
                                       bundle: nil),
                            forCellReuseIdentifier: "MAGProjectFileAddTableViewCell")
    self.cellObjects = self.viewModel.cellObjects()
    
  }
  
  override func performSegue(withIdentifier identifier: String,
                             sender: Any?)
  {
    if identifier.elementsEqual("showGoogleDrive")
    {
      
    }
  }
  
  /*Возможно стоит переделать в таблицу
   
   создать фабрику создания ячеек
   
   Передавать отсюда новый проект
   Добавить проверки на валидность
   Добавить кнопку сохранить и сохранить все в коре дату(сохранять во вью модел)
 */
  @IBAction func addNVERTapped()
  {
    /*
     Открывается выбор файла и сохраняется этот файл в папку документс
     А сюда возвращается путь, который мы сохраняем в коре дату
     Открывать контроллер - инит с комплишином
     Можно для этого создать объект роутер(пожелание)
     */
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: nil)
  }
  
  @IBAction func addXYZTapped()
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: self)
  }
  
  @IBAction func addNVKATTapped(_ sender: Any)
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: self)
  }
  
  @IBAction func addElemNeibTapped()
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: self)
  }
  
  
  //MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.cellObjects.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MAGProjectFileAddTableViewCell",
                                             for: indexPath) as! MAGProjectFileAddTableViewCell
    cell.configure(cellObject: cellObjects[indexPath.row])
    return cell
  }
  
}
