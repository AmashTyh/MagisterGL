//
//  MAGSectionViewController.swift
//  MagisterGL
//
//  Created by Admin on 27.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGSectionViewController: UIViewController {

  @IBOutlet weak var customGeometryView: MAGSectionView!
  
  var sectionType: PlaneType = .X
  var sectionValue: Float = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      self.customGeometryView.model.sectionValue = sectionValue
      self.customGeometryView.model.sectionType = sectionType
      self.customGeometryView.redraw()
    }
}
