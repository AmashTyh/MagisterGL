//
//  MAGLocalViewController.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGLocalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let cellReuseIdentifier = "kLocalReuseCellID"
  private var filesCount: Int = 0
  private var localFileManager: MAGLocalFileManager = MAGLocalFileManager()
  
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    filesCount = Int(localFileManager.findFilesInLocalDirectory())
    
    self.tableView.allowsMultipleSelectionDuringEditing = false
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  // MARK: TableView
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return filesCount
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    // create a new cell if needed or reuse an old one
    let cell : UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    
    cell.textLabel?.text = localFileManager.filesnameArray[indexPath.row].components(separatedBy: "/").last;
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    
  }
  
  func tableView(_ tableView: UITableView,
                 canEditRowAt indexPath: IndexPath) -> Bool
  {
    return true
  }
  
  func tableView(_ tableView: UITableView,
                 commit editingStyle: UITableViewCellEditingStyle,
                 forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete
    {
      localFileManager.removeFile(with: UInt(indexPath.row))
      filesCount = Int(localFileManager.findFilesInLocalDirectory())
      tableView.reloadData()
    }
  }

}
