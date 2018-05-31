//
//  MAGTimeChartsViewController.swift
//  MagisterGL
//
//  Created by Admin on 01.06.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

protocol MAGTimeChartsViewControllerDelegate: class
{
  func chooseTimeFieldNumber(fieldNumber: Int)
}

class MAGTimeChartsViewController: UIViewController,
                                   UITableViewDelegate,
                                   UITableViewDataSource,
                                   UIPopoverPresentationControllerDelegate
{

  weak var delegate: MAGTimeChartsViewControllerDelegate?
  var showFieldNumber = -1
  var timeSlices: [Int] = []
  let cellReuseIdentifier = "kTimeChartsFieldReuseCellID"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UITableViewCell.self,
                            forCellReuseIdentifier: cellReuseIdentifier)
  }
  
  //MARK: Actions
  
  @IBAction func defaultField()
  {
    self.delegate?.chooseTimeFieldNumber(fieldNumber: 0)
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  // MARK: UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.timeSlices.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell : UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    cell.textLabel?.text = String(self.timeSlices[indexPath.row])
    if (self.showFieldNumber == indexPath.row)
    {
      tableView.selectRow(at: indexPath,
                          animated: false,
                          scrollPosition: .none)
    }
    return cell
  }
  
  //MARK: UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    self.delegate?.chooseTimeFieldNumber(fieldNumber: indexPath.row)
    self.dismiss(animated: true,
                 completion: nil)
  }

}
