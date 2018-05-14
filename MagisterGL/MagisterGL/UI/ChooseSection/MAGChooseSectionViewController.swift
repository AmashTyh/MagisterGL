//
//  MAGChooseSectionViewController.swift
//  MagisterGL
//
//  Created by Admin on 03.05.2018.
//  Copyright © 2018 Хохлова Татьяна. All rights reserved.
//

import UIKit

protocol MAGChooseSectionViewControllerDelegate : class
{
  func drawSection(sectionType: PlaneType,
                   sectionValue: Float)
  func deleteSection()
}

class MAGChooseSectionViewController: UIViewController,
                                      UIPopoverPresentationControllerDelegate,
                                      UIPickerViewDelegate,
                                      UIPickerViewDataSource
{
  
  weak var delegate: MAGChooseSectionViewControllerDelegate?
  
  @IBOutlet weak var sectionXTextField: UITextField!
  @IBOutlet weak var sectionTypePicker: UIPickerView!
  
  let pickerData = ["X", "Y", "Z"]
  
  
  @IBAction func drawSectionButtonTapped()
  {
    delegate?.drawSection(sectionType: PlaneType(rawValue: self.sectionTypePicker.selectedRow(inComponent: 0))!,
                          sectionValue: (self.sectionXTextField.text! as NSString).floatValue)
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
