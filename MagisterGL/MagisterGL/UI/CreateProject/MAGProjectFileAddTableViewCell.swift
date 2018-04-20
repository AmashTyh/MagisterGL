//
//  MAGProjectFileAddTableViewCell.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 17.04.18.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//


import UIKit

protocol MAGProjectFileAddTableViewCellDelegate
{
  func showGoogleDrive(cellObject: MAGProjectFileAddTableViewCellObject)
}

class MAGProjectFileAddTableViewCell: UITableViewCell
{

  var delegate: MAGProjectFileAddTableViewCellDelegate?
  var cellObject: MAGProjectFileAddTableViewCellObject?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var filePathLabel: UILabel!
  
  override func awakeFromNib()
  {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configure(cellObject: MAGProjectFileAddTableViewCellObject,
                 delegate: MAGProjectFileAddTableViewCellDelegate)
  {
    self.cellObject = cellObject;
    self.titleLabel.text = cellObject.name
    self.filePathLabel.text = cellObject.filePath
    self.delegate = delegate
  }

  @IBAction func addFile(_ sender: Any)
  {
    self.delegate?.showGoogleDrive(cellObject: self.cellObject!)
  }
  
}
