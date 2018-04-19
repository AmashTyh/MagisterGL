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


class MAG3DViewController: UIViewController, UIPopoverPresentationControllerDelegate, SCNSceneRendererDelegate

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
     self.customGeometryView.configure(project: self.project)
  }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?)
    {
        super.prepare(for: segue,
                      sender: sender)
        if segue.destination.isKind(of: MAGChooseFileViewController.self)
        {
            segue.destination.popoverPresentationController?.delegate = self;
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
    {
        self.customGeometryView.redraw()
    }
  
  //MARK: SCNSceneRendererDelegate
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
  {
  }
  
  func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval)
  {      }
  
}
