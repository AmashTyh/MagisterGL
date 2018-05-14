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
                                      UITableViewDataSource,
                                      MAGProjectFileAddTableViewCellDelegate
{
  
  let viewModel: MAGCreateProjectViewModel = MAGCreateProjectViewModel()
  
  var cellObjects: [MAGProjectFileAddTableViewCellObject] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var nameTextField: UITextField!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UINib.init(nibName: "MAGProjectFileAddTableViewCell",
                                       bundle: nil),
                            forCellReuseIdentifier: "MAGProjectFileAddTableViewCell")
    self.cellObjects = self.viewModel.cellObjects
    
  }
  
  @IBAction func cancelCreateProject()
  {
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  @IBAction func addNewProject()
  {
    self.viewModel.name = self.nameTextField.text
    self.viewModel.createProject()    
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  
  //MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int
  {
    return self.cellObjects.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MAGProjectFileAddTableViewCell",
                                             for: indexPath) as! MAGProjectFileAddTableViewCell
    cell.configure(cellObject: cellObjects[indexPath.row],
                   delegate: self)
    return cell
  }
  
  //MARK: MAGProjectFileAddTableViewCellDelegate
  
  func showGoogleDrive(cellObject: MAGProjectFileAddTableViewCellObject)
  {
    let storyboard = UIStoryboard(name: "Main",
                                  bundle: nil)
    let googleDriceVC = storyboard.instantiateViewController(withIdentifier: "MAGGoogleTableViewController") as! MAGGoogleTableViewController
    googleDriceVC.completion = {
      obj in
      cellObject.filePath = obj
      self.tableView.reloadData()
      /*
       Сохранить файл в документах
       */
    }
    self.present(googleDriceVC,
                 animated: true,
                 completion: nil)
  }
  
}
