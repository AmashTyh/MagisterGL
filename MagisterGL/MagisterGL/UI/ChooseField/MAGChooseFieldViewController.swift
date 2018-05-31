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

class MAGChooseFieldViewController: UIViewController,
                                    UITableViewDelegate,
                                    UITableViewDataSource,
                                    UIPopoverPresentationControllerDelegate
{
  
  weak var delegate: MAGChooseFieldViewControllerDelegate?
  var showFieldNumber = -1
  var timeSlices: [Float] = []
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
    self.delegate?.chooseFieldNumber(fieldNumber: 0)
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
    self.delegate?.chooseFieldNumber(fieldNumber: indexPath.row)
    self.dismiss(animated: true,
                 completion: nil)
  }

}
