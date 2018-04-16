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
  var cellObjects: [MAGProjectCellObject] = []
  
  

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
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
    

  @IBAction func addButtonTapped(_ sender: Any)
  {
  }
  
}
