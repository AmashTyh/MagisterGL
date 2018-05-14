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
                           MAGChooseMaterialViewControllerDelegate

{
  
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
    else if segue.destination.isKind(of: MAGSectionViewController.self)
    {
      let vc = segue.destination as! MAGSectionViewController
      vc.model = self.customGeometryView.model
    }
    else if segue.destination.isKind(of: MAGChooseMaterialViewController.self)
    {
      let vc = segue.destination as! MAGChooseMaterialViewController
      vc.delegate = self
      vc.materials = self.customGeometryView.model.materials
      vc.selectedMaterials = self.customGeometryView.model.selectedMaterials
      vc.popoverPresentationController?.delegate = self
    }
  }
  
  //MARK: SCNSceneRendererDelegate
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
  {
  }
  
  func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval)
  {
    
  }
  
  //MARK: MAGChooseSectionViewControllerDelegate
  func drawSection(sectionType: PlaneType,
                   sectionValue: Float)
  {
    self.customGeometryView.model.sectionType = sectionType
    self.customGeometryView.model.sectionValue = sectionValue
    self.customGeometryView.model.isDrawingSectionEnabled = true
    self.customGeometryView.model.createElementsArray()
    self.customGeometryView.setupScene()
  }
  
  func deleteSection()
  {
    self.customGeometryView.model.isDrawingSectionEnabled = false
    self.customGeometryView.model.createElementsArray()
    self.customGeometryView.setupScene()
  }
  
  // MARK: MAGChooseMaterialViewControllerDelegate
  
  func selectedMaterials(selectedMaterials: [MAGMaterial])
  {
    self.customGeometryView.model.selectedMaterials = selectedMaterials
    self.customGeometryView.model.createElementsArray()
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
