//
//  MAGChooseMaterialViewController.swift
//  MagisterGL
//
//  Created by Admin on 08.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit

protocol MAGChooseMaterialViewControllerDelegate : class
{
  func selectedMaterials(selectedMaterials: [MAGMaterial])
}


class MAGChooseMaterialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate
{
  let cellReuseIdentifier = "kMaterialReuseCellID"
  weak var delegate: MAGChooseMaterialViewControllerDelegate?
  var materials: [MAGMaterial]?
  var selectedMaterials: [MAGMaterial]?
  
  @IBOutlet weak var tableView: UITableView!

  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  @IBAction func saveMaterialButtonTapped()
  {
    self.delegate?.selectedMaterials(selectedMaterials: self.selectedMaterials!)
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
    let cell : UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    let material = self.materials![indexPath.row]
    cell.textLabel?.text = String(material.numberOfMaterial)
    let isSelected = (self.selectedMaterials?.contains(material))!
    cell.isSelected = isSelected
    if isSelected
    {
      // работает, не трогай
      tableView.selectRow(at: indexPath,
                          animated: false,
                          scrollPosition: UITableViewScrollPosition.none)
    }
    cell.accessoryType = isSelected ? .checkmark : .none
    cell.backgroundColor = material.color
    let view = UIView()
    view.backgroundColor = UIColor.clear
    cell.selectedBackgroundView = view
    return cell
  }
  
  // MARL: UITableViewDelegate
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .checkmark
    let material = self.materials![indexPath.row]
    self.selectedMaterials?.append(material)
  }
  
  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath)
  {
    let cell = tableView.cellForRow(at: indexPath)
    cell?.accessoryType = .none
    let material = self.materials![indexPath.row]
    let index = self.selectedMaterials?.index(of: material)
    self.selectedMaterials?.remove(at: index!)
  }
}
