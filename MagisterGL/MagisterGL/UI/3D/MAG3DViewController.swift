//
//  MAG3DViewController.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 26.09.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit
import OpenGLES


class MAG3DViewController: UIViewController,
                           UIPopoverPresentationControllerDelegate,
                           SCNSceneRendererDelegate,
                           MAGChooseSectionViewControllerDelegate,
                           MAGChooseMaterialViewControllerDelegate,
                           MAGChooseFieldViewControllerDelegate,
                           MAGTimeChartsViewControllerDelegate,
                           SettingsViewControllerDelegate

{
  
  @IBOutlet weak var chartsTimeSliceButton: UIBarButtonItem!
  @IBOutlet weak var receiversTimeSliceButton: UIBarButtonItem!
  @IBOutlet weak var customGeometryView: MAGCustomGeometryView!
  
  var project: MAGProject!
  
  func configure(project: MAGProject)
  {
    self.project = project
  }
    
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.customGeometryView.delegate = self
    if self.project != nil
    {
      self.customGeometryView.configure(project: self.project)
    }
  }
    
  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?)
  {
    super.prepare(for: segue,
                  sender: sender)
    
    if segue.destination.isKind(of: MAGChooseSectionViewController.self)
    {
      let vc = segue.destination as! MAGChooseSectionViewController
      vc.delegate = self
      vc.popoverPresentationController?.delegate = self
    }
    else if segue.destination.isKind(of: MAGChooseMaterialViewController.self)
    {
      let vc = segue.destination as! MAGChooseMaterialViewController
      vc.delegate = self
      vc.materials = self.customGeometryView.model.materials
      vc.selectedMaterials = self.customGeometryView.model.selectedMaterials
      vc.popoverPresentationController?.delegate = self
    }
    else if segue.destination.isKind(of: MAGChooseFieldViewController.self)
    {
      let vc = segue.destination as! MAGChooseFieldViewController
      vc.delegate = self
      vc.showFieldNumber = self.customGeometryView.model.showTimeSlicesNumber
      vc.timeSlices = self.customGeometryView.model.timeSlices
      vc.popoverPresentationController?.delegate = self
    }
    else if segue.destination.isKind(of: MAGTimeChartsViewController.self)
    {
      let vc = segue.destination as! MAGTimeChartsViewController
      vc.delegate = self
      vc.showFieldNumber = self.customGeometryView.model.showTimeSliceForCharts
      vc.timeSlices = self.customGeometryView.model.timeSlicesForCharts
      vc.popoverPresentationController?.delegate = self
    }
    else if segue.destination.isKind(of: SettingsViewController.self)
    {
      let vc = segue.destination as! SettingsViewController
      vc.delegate = self
      vc.isSurfaceEnabled = self.customGeometryView.model.isShowReceiversSurface
      vc.isChartsEnabled = self.customGeometryView.model.isShowCharts
      vc.popoverPresentationController?.delegate = self
    }
  }
  
  //MARK: SCNSceneRendererDelegate
  
  func renderer(_ renderer: SCNSceneRenderer,
                updateAtTime time: TimeInterval)
  {
    
  }
  
  func renderer(_ renderer: SCNSceneRenderer,
                willRenderScene scene: SCNScene,
                atTime time: TimeInterval)
  {
    
  }
  
  func renderer(_ renderer: SCNSceneRenderer,
                didRenderScene scene: SCNScene,
                atTime time: TimeInterval)
  {
    
  }
  
  //MARK: MAGChooseSectionViewControllerDelegate
  
  func drawSection(sectionType: PlaneType,
                   sectionValue: Float,
                   greater: Bool)
  {
    self.customGeometryView.model.sectionType = sectionType
    self.customGeometryView.model.sectionValue = sectionValue
    self.customGeometryView.model.isDrawingSectionEnabled = true
    self.customGeometryView.model.greater = greater
    self.customGeometryView.model.createElementsArray()
    self.customGeometryView.setupScene()
  }
  
  func deleteSection()
  {
    self.customGeometryView.model.isDrawingSectionEnabled = false
    self.customGeometryView.model.createElementsArray()
    self.customGeometryView.setupScene()
  }
  
  func minVector() -> SCNVector3
  {
    return self.customGeometryView.model.minVector
  }
  
  func maxVector() -> SCNVector3
  {
    return self.customGeometryView.model.maxVector
  }
  
  // MARK: MAGChooseMaterialViewControllerDelegate
  
  func selectedMaterials(selectedMaterials: [MAGMaterial])
  {
    self.customGeometryView.model.selectedMaterials = selectedMaterials
    self.customGeometryView.model.createElementsArray()
    self.customGeometryView.setupScene()
  }
  
  //MARK: MAGChooseFieldViewControllerDelegate
  
  func chooseFieldNumber(fieldNumber: Int)
  {
    self.customGeometryView.model.showTimeSlicesNumber = fieldNumber
    self.customGeometryView.model.createReceiverSurface()
    self.customGeometryView.setupScene()
  }
  
  //MARK: MAGTimeChartsViewControllerDelegate
  func chooseTimeFieldNumber(fieldNumber: Int)
  {
    self.customGeometryView.model.showTimeSliceForCharts = fieldNumber
    self.customGeometryView.model.createReceiverSurface()
    self.customGeometryView.setupScene()
  }
  
  //MARK: UISettingsViewControllerDelegate
  func updateSettings(isSurfaceEnabled: Bool,
                      isChartsEnabled: Bool)
  {
    self.customGeometryView.model.isShowReceiversSurface = isSurfaceEnabled
    self.customGeometryView.model.isShowCharts = isChartsEnabled
    self.receiversTimeSliceButton.isEnabled = isSurfaceEnabled
    self.chartsTimeSliceButton.isEnabled = isChartsEnabled
    self.customGeometryView.setupScene()
  }
  
  
  //MARK: UIPopoverPresentationControllerDelegate
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
  {
    return .none
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController,
                                 traitCollection: UITraitCollection) -> UIModalPresentationStyle
  {
    return .none
  }
  
  
}
