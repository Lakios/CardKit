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
  
  @IBAction @objc func _openController() {
    CardKTheme.setTheme(CardKTheme.light());
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    present(controller, animated: true)
  }
  
  @IBAction func _openDark(_ sender: Any) {
    CardKTheme.setTheme(CardKTheme.dark());
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
      present(controller, animated: true)
  }
}

extension ViewController: CardKViewControllerDelegate {
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String) {
    debugPrint(seToken)
    controller.dismiss(animated: true, completion: nil)
  }
}

