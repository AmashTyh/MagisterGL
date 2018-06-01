//
//  MAGChooseSectionViewController.swift
//  MagisterGL
//
//  Created by Admin on 03.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit
import SceneKit

protocol MAGChooseSectionViewControllerDelegate : class
{
  func drawSection(sectionType: PlaneType,
                   sectionValue: Float,
                   greater: Bool)
  func deleteSection()
  
  func minVector() -> SCNVector3
  func maxVector() -> SCNVector3
}

class MAGChooseSectionViewController: UIViewController,
                                      UIPopoverPresentationControllerDelegate,
                                      UIPickerViewDelegate,
                                      UIPickerViewDataSource
{
  
  weak var delegate: MAGChooseSectionViewControllerDelegate?
  
  @IBOutlet weak var sectionXTextField: UITextField!
  @IBOutlet weak var sectionTypePicker: UIPickerView!
  @IBOutlet weak var sectionGreater: UISwitch!
  @IBOutlet weak var minVectorLabel: UILabel!
  @IBOutlet weak var maxVectorLabel: UILabel!
  
  let pickerData = ["X", "Y", "Z"]
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let minVector = delegate?.minVector()
    if minVector != nil
    {
      minVectorLabel.text = String(format: "min: %.2f %.2f %.2f", (minVector?.x)!, (minVector?.y)!, (minVector?.z)!)
    }
    
    let maxVector = delegate?.maxVector()
    if maxVector != nil
    {
      maxVectorLabel.text = String(format: "max: %.2f %.2f %.2f", (maxVector?.x)!, (maxVector?.y)!, (maxVector?.z)!)
    }
  }
  
  
  @IBAction func drawSectionButtonTapped()
  {
    delegate?.drawSection(sectionType: PlaneType(rawValue: self.sectionTypePicker.selectedRow(inComponent: 0))!,
                          sectionValue: (self.sectionXTextField.text! as NSString).floatValue,
                          greater: self.sectionGreater.isOn)
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  @IBAction func deleteSection()
  {
    delegate?.deleteSection()
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  // MARK: UIPickerViewDataSource
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int
  {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int
  {
    return pickerData.count
  }
  
  // MARK: UIPickerViewDelegate
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String?
  {
    return pickerData[row]
  }
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int)
  {
    
  }
}
