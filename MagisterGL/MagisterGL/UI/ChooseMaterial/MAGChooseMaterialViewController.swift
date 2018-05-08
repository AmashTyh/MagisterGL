//
//  MAGChooseMaterialViewController.swift
//  MagisterGL
//
//  Created by Admin on 08.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit

protocol MAGChooseMaterialViewControllerDelegate
{
  func selectedMaterils(selectedMaterials: [Int])
}


class MAGChooseMaterialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  let cellReuseIdentifier = "kMaterialReuseCellID"
  var delegate: MAGChooseMaterialViewControllerDelegate?
  var materials: [Int]?
  var selectedMaterials: [Int]?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  @IBAction func saveMaterialButtonTapped()
  {
    self.delegate?.selectedMaterils(selectedMaterials: self.selectedMaterials!)
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int
  {
    return (self.materials?.count)!
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell : UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    let material = self.materials![indexPath.row]
    cell.textLabel?.text = String(material)
    let isSelected = (self.selectedMaterials?.contains(material))!
    cell.isSelected = isSelected
    cell.accessoryType = isSelected ? .checkmark : .none
    return cell
  }
  
  // MARL: UITableViewDelegate
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark
    let material = ((cell?.textLabel?.text! as! NSString).integerValue)
    self.selectedMaterials?.append(material)
  }
  
  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath)
  {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark
    let material = ((cell?.textLabel?.text! as! NSString).integerValue)
    let index = self.selectedMaterials?.index(of: material)
    self.selectedMaterials?.remove(at: index!)
  }
}
