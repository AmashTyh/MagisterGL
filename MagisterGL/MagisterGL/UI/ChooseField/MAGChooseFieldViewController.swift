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
  let cellReuseIdentifier = "MAGChooseFieldTableViewCell"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UINib.init(nibName: cellReuseIdentifier,
                                       bundle: nil),
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
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int
  {
    return self.availableFields.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell : MAGChooseFieldTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MAGChooseFieldTableViewCell?)!
    let field = self.availableFields[indexPath.row]
    cell.titleLabel?.text = field
    if (self.showFieldNumber == indexPath.row)
    {
      tableView.selectRow(at: indexPath,
                          animated: false,
                          scrollPosition: .none)
    }
    return cell
  }
  
  //MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    self.delegate?.chooseFieldNumber(fieldNumber: indexPath.row)
    self.dismiss(animated: true,
                 completion: nil)
  }

}
