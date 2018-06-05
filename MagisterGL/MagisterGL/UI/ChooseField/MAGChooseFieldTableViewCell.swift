//
//  MAGChooseFieldTableViewCell.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 01.06.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

/**
 Ячейка с материалом
 */
class MAGChooseFieldTableViewCell: UITableViewCell
{
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    let selectedBackgroundView = UIView()
    selectedBackgroundView.backgroundColor = UIColor(white: 240.0 / 255.0,
                                                     alpha: 1.0)
    self.selectedBackgroundView = selectedBackgroundView
  }

  override func setSelected(_ selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
