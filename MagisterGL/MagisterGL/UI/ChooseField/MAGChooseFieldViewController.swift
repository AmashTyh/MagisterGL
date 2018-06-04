//
//  MAGChooseFieldViewController.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 16.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit

protocol MAGChooseFieldViewControllerDelegate: class
{
  func chooseFieldNumber(fieldNumber: Int)
}

/**
 Модуль экрана выбора поля
 */
class MAGChooseFieldViewController: UIViewController,
                                    UITableViewDelegate,
                                    UITableViewDataSource,
                                    UIPopoverPresentationControllerDelegate
{
  
  weak var delegate: MAGChooseFieldViewControllerDelegate?
  var showFieldNumber = -1
  var availableFields: [String] = []
  let cellReuseIdentifier = "kChooseFieldReuseCellID"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self,
                            forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  //MARK: Actions
  
  @IBAction func notShowField()
  {
    self.delegate?.chooseFieldNumber(fieldNumber: -1)
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.availableFields.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell : UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    cell.textLabel?.text = self.availableFields[indexPath.row]
    let selectedBackgroundView = UIView()
    selectedBackgroundView.backgroundColor = UIColor(white: 240.0 / 255.0,
                                                     alpha: 1.0)
    cell.selectedBackgroundView = selectedBackgroundView
    if (self.showFieldNumber == indexPath.row)
    {
      tableView.selectRow(at: indexPath,
                          animated: false,
                          scrollPosition: .top)
    }
    return cell
  }
  
  //MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    self.delegate?.chooseFieldNumber(fieldNumber: indexPath.row)
    self.dismiss(animated: true,
                 completion: nil)
  }

}
