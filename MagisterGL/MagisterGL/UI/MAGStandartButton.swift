//
//  MAGStandartButton.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 01.06.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGStandartButton: UIButton
{

  override func awakeFromNib()
  {
    super.awakeFromNib()
    
    self.backgroundColor = UIColor(red: 107.0 / 255.0,
                                   green: 71.0 / 255.0,
                                   blue: 219.0 / 255.0,
                                   alpha: 1.0)
    self.setTitleColor(UIColor.white,
                       for: .normal)
    self.layer.cornerRadius = 9.0
  }
  
}
