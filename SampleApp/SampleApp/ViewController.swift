//
//  ViewController.swift
//  SampleApp
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

import UIKit
import CardKit

class ViewController: UIViewController {
  
  @IBAction @objc func _openController() {
    let controller = CKitViewController(publicKey: "key", mdOrder:"mdOrder")
    present(controller, animated: true)
  }

}

extension ViewController: CKitViewControllerDelegate {
  func cardKitViewController(_ controller: CKitViewController, didCreateSeToken seToken: String) {
    debugPrint(seToken)
    controller.dismiss(animated: true, completion: nil)
  }
}

