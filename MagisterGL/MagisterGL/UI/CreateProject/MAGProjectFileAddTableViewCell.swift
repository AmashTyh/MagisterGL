//
//  MAGProjectFileAddTableViewCell.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 17.04.18.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGProjectFileAddTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var filePathLabel: UILabel!
  
  
  
  override func awakeFromNib()
  {
        super.awakeFromNib()
        // Initialization code
    }
  
  func configure(cellObject: MAGProjectFileAddTableViewCellObject)
  {
    self.titleLabel.text = cellObject.name
  }

  @IBAction func addFile(_ sender: Any)
  {
  }
  
}
