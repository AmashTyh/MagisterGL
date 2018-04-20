//
//  MAGProjectTableViewCell.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGProjectTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  
  func configure(cellObject: MAGProjectCellObject)
  {
    self.nameLabel.text = cellObject.name
  }
  
  override func awakeFromNib()
  {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
