//
//  MAGCreateProjectViewController.swift
//  MagisterGL
//
//  Created by Admin on 16.04.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

class MAGCreateProjectViewController: UIViewController
{
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
  }
  
  override func performSegue(withIdentifier identifier: String,
                             sender: Any?)
  {
    if identifier.elementsEqual("showGoogleDrive")
    {
      
    }
  }
  
  @IBAction func addNVERTapped()
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: nil)
  }
  
  @IBAction func addXYZTapped()
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: self)
  }
  
  @IBAction func addNVKATTapped(_ sender: Any)
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: self)
  }
  
  @IBAction func addElemNeibTapped()
  {
    self.performSegue(withIdentifier: "showGoogleDrive",
                      sender: self)
  }
  
}
