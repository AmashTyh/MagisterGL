//
//  MAGChooseMaterialTableViewCell.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 01.06.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

class MAGChooseMaterialTableViewCell: UITableViewCell
{
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var colorView: UIView!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    
    colorView.layer.cornerRadius = 9.0
    let view = UIView()
    view.backgroundColor = UIColor.clear
    self.selectedBackgroundView = view
  }

  override func setSelected(_ selected: Bool,
                            animated: Bool)
  {
    super.setSelected(selected,
                      animated: animated)
    
    self.accessoryType = selected ? .checkmark : .none
  }
    
}
