//
//  MAGChooseFileViewController.swift
//  MagisterGL
//
//  Created by Admin on 06.11.2017.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit


class MAGChooseFileViewController: UIViewController, UIPopoverPresentationControllerDelegate
{
  @IBAction func test1Tapped(_ sender: UIButton)
  {
    MAGFileManager.sharedInstance.testType = 0
    self.dismissVC()
  }
  
  @IBAction func test2Tapped(_ sender: UIButton)
  {
    MAGFileManager.sharedInstance.testType = 1
    self.dismissVC()
  }
  
  @IBAction func test3Tapped(_ sender: UIButton)
  {
    MAGFileManager.sharedInstance.testType = 2
    self.dismissVC()
  }
  
  @IBAction func test4Tapped(_ sender: UIButton)
  {
    MAGFileManager.sharedInstance.testType = 3
    self.dismissVC()
  }
  
  @IBAction func test5Tapped(_ sender: UIButton)
  {
    MAGFileManager.sharedInstance.testType = 4
    self.dismissVC()
  }
  private func dismissVC()
    {
        if let pvc = self.presentingViewController
        {
            var didDismiss : ((UIPopoverPresentationController) -> Void)? = nil
            if let delegate = popoverPresentationController?.delegate
            {
                // check it is okay to dismiss the popover
                let okayToDismiss = delegate.popoverPresentationControllerShouldDismissPopover?(popoverPresentationController!) ?? true
                if okayToDismiss
                {
                    // create completion closure
                    didDismiss = delegate.popoverPresentationControllerDidDismissPopover
                }
            }
            // use local var to avoid memory leaks
            let ppc = popoverPresentationController
            // dismiss popover with completion closure
            pvc.dismiss(animated: true)
            {
                didDismiss?(ppc!)
            }
        }
    }
}
