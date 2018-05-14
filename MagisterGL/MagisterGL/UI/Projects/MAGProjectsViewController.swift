//
//  MAGProjectsViewController.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGProjectsViewController: UIViewController,
                                 UITableViewDelegate,
                                 UITableViewDataSource
{
  
  @IBOutlet weak var tableView: UITableView!
  
  let viewModel: MAGProjectsViewModel = MAGProjectsViewModel()
  let baseProjectsGenerator: MAGBaseProjectsGenerator = MAGBaseProjectsGenerator()
  var cellObjects: [MAGProjectCellObject] = []
  
  

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    baseProjectsGenerator.baseProjects()
    cellObjects = viewModel.cellObjects()
    self.tableView.register(UINib.init(nibName: "MAGProjectTableViewCell",
                                       bundle: nil),
                            forCellReuseIdentifier: "MAGProjectTableViewCell")
  }
  
  // MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return cellObjects.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MAGProjectTableViewCell",
                                             for: indexPath) as! MAGProjectTableViewCell
    cell.configure(cellObject: cellObjects[indexPath.row])
    return cell
  }
  /*
   секлет ячейки открывает проект 3д(можно сделать тип ячейки со стрелочкой) или по кнопке
   добавить кнопки удалить, редактировать
 */
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    let storyboard = UIStoryboard(name: "Main",
                                  bundle: nil)
    let geometryVC = storyboard.instantiateViewController(withIdentifier: "MAG3DViewController") as! MAG3DViewController
    let project = cellObjects[indexPath.row].project
    geometryVC.title = project.name
    geometryVC.configure(project: project)
    self.navigationController?.pushViewController(geometryVC,
                                                  animated: true)
    tableView.deselectRow(at: indexPath,
                          animated: false)
  }
    

  /*
   Переделать чтение файлов - разделять дат и текстовый файлы
 */
  @IBAction func addButtonTapped(_ sender: Any)
  {
    /* это отсюда убрать, передавать из контроллера Create project (можно подумать как это все передавать)
     по возвращению просто обновлять таблицу - должны браться все данные из коре даты
    */
//    self.viewModel.addProject()
  }
  
  @IBAction func refresh(_ sender: Any)
  {
    cellObjects = viewModel.cellObjects()
    self.tableView.reloadData()
  }
}
