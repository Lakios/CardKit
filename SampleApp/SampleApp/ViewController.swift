//
//  ViewController.swift
//  SampleApp
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

import UIKit
import CardKit

let publicKey = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiDgvGLU1dFQ0tA0Epbpj
1gbbAz9/lvZdTyspHCPQ4zTYki1xER8Dy99jzxj83VIiamnwkHUsmcg5mxXfRI/Y
7mDq9LT1mmoM5RytpfuuFELWrBE59jZzc4FgwcVdvR8oV4ol7RDPDHpSxl9ihC1h
2KZ/GoKi9G6TULRzD+hLeo9vIpC0vIIGUyxDWtOWi0yDf4MYisUKmgbYya+Z5oOD
ANHUCiJuMMuuH7ot6hJPxZ61LE0FQP6pxo+r1cezGekwlc8NrKq3XeeNgu4kWFXN
TBSwAcNAizIvEY4wrqc4ARR3nTlwAxkye9bTNVNROMMiMtu1ERGyRFjI7wnSmRnN
EwIDAQAB
-----END PUBLIC KEY-----
"""

class ViewController: UIViewController {
//  var navigationController: UINavigationController?
  
  @IBAction @objc func _openController() {
    CardKTheme.setTheme(CardKTheme.light());

    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = true;
    controller.purchaseButtonTitle = "Custom purchase button";
    present(controller, animated: true)
  }

  @IBAction func _openDark(_ sender: Any) {
    CardKTheme.setTheme(CardKTheme.dark());
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.allowedCardScaner = true;
    controller.cKitDelegate = self
    present(controller, animated: true)
  }
  
  @IBAction func _openSystemTheme(_ sender: Any) {
    if #available(iOS 13.0, *) {
      CardKTheme.setTheme(CardKTheme.system())
    } else {
      CardKTheme.setTheme(CardKTheme.default())
    };
    
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = true
    
    present(controller, animated: true)
  }
  
  @IBAction func _openLightUINavigation(_ sender: Any) {
    CardKTheme.setTheme(CardKTheme.light());

    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = false;
    controller.purchaseButtonTitle = "Custom purchase button";
    
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @IBAction func _openDarkUINavigation(_ sender: Any) {
    CardKTheme.setTheme(CardKTheme.dark());
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.allowedCardScaner = false;
    controller.cKitDelegate = self

    self.navigationController?.pushViewController(controller, animated: true)
  }

  @IBAction func _openSystemUINavigation(_ sender: Any) {
    if #available(iOS 13.0, *) {
      CardKTheme.setTheme(CardKTheme.system())
    } else {
      CardKTheme.setTheme(CardKTheme.default())
    };
    
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = true
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

extension ViewController: CardKViewControllerDelegate {
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String) {
    debugPrint(seToken)

    let alert = UIAlertController(title: "SeToken", message: seToken, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    controller.present(alert, animated: true)
  }
}

