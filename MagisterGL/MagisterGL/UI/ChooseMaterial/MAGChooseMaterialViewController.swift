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
  let cellReuseIdentifier = "MAGChooseMaterialTableViewCell"
  weak var delegate: MAGChooseMaterialViewControllerDelegate?
  var materials: [MAGMaterial]?
  var selectedMaterials: [MAGMaterial]?
  
  @IBOutlet weak var tableView: UITableView!

  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UINib.init(nibName: cellReuseIdentifier,
                                       bundle: nil),
                            forCellReuseIdentifier: cellReuseIdentifier)
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
    let cell : MAGChooseMaterialTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MAGChooseMaterialTableViewCell?)!
    let material = self.materials![indexPath.row]
    cell.titleLabel?.text = String(material.numberOfMaterial)
    let isSelected = (self.selectedMaterials?.contains(material))!
    cell.isSelected = isSelected
    if isSelected
    {
      tableView.selectRow(at: indexPath,
                          animated: false,
                          scrollPosition: .none)
    }
    let color = UIColor(red: CGFloat(material.color.x),
                        green: CGFloat(material.color.y),
                        blue: CGFloat(material.color.z),
                        alpha: 1.0)
    cell.colorView.backgroundColor = color
    return cell
  }
  
  // MARL: UITableViewDelegate
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    let cell: MAGChooseMaterialTableViewCell = tableView.cellForRow(at: indexPath) as! MAGChooseMaterialTableViewCell
    cell.accessoryType = .checkmark
    let material = self.materials![indexPath.row]
    self.selectedMaterials?.append(material)
    let color = UIColor(red: CGFloat(material.color.x),
                        green: CGFloat(material.color.y),
                        blue: CGFloat(material.color.z),
                        alpha: 1.0)
    cell.colorView.backgroundColor = color
  }
  
  func tableView(_ tableView: UITableView,
                 didDeselectRowAt indexPath: IndexPath)
  {
    let cell: MAGChooseMaterialTableViewCell = tableView.cellForRow(at: indexPath) as! MAGChooseMaterialTableViewCell
    cell.accessoryType = .none
    let material = self.materials![indexPath.row]
    let index = self.selectedMaterials?.index(of: material)
    self.selectedMaterials?.remove(at: index!)
    let color = UIColor(red: CGFloat(material.color.x),
                        green: CGFloat(material.color.y),
                        blue: CGFloat(material.color.z),
                        alpha: 1.0)
    cell.colorView.backgroundColor = color
  }
}
