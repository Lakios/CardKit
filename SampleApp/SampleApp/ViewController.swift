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

struct Section {
  let title: String?
  let items: [SectionItem]
}

struct SectionItem {
  let title: String
  let kind: Kind
  let isShowChevron: Bool
  
  enum Kind {
    case lightTheme
    case darkTheme
    case systemTheme
    case customTheme
    case navLightTheme
    case navDarkTheme
    case navSystemTheme
  }
}

class SampleAppCardIO: NSObject, CardIOViewDelegate {
  weak var cardKController: CardKViewController? = nil
  
  func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
    if let info = cardInfo {
      cardKController?.setCardNumber(info.cardNumber, holderName: info.cardholderName, expirationDate: nil, cvc: nil)
    }
    cardIOView?.removeFromSuperview()
  }
}


class ViewController: UITableViewController {
  var sampleAppCardIO: SampleAppCardIO? = nil
  
  @objc func _close(sender:UIButton){
    self.navigationController?.dismiss(animated: true, completion: nil)
  }

  func _openController() {
  
    CardKConfig.shared.language = "ru";
    CardKConfig.shared.theme = CardKTheme.light()
    
    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
    controller.purchaseButtonTitle = "Custom purchase button";

    if #available(iOS 13.0, *) {
      self.present(controller, animated: true)
      return;
    }

    let navController = UINavigationController(rootViewController: controller)
    navController.modalPresentationStyle = .formSheet

    let closeBarButtonItem = UIBarButtonItem(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(_close(sender:))
    )
    controller.navigationItem.leftBarButtonItem = closeBarButtonItem
    self.present(navController, animated: true)
    CardIOUtilities.preloadCardIO()
  }

  func _openDark() {
    CardKConfig.shared.language = "fr";
    CardKConfig.shared.theme = CardKTheme.dark();

    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.allowedCardScaner = false;
    controller.cKitDelegate = self

    if #available(iOS 13.0, *) {
      self.present(controller, animated: true)
      return;
    }

    let navController = UINavigationController(rootViewController: controller)
    navController.modalPresentationStyle = .formSheet

    let closeBarButtonItem = UIBarButtonItem(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(_close(sender:))
    )
    controller.navigationItem.leftBarButtonItem = closeBarButtonItem
    self.present(navController, animated: true)
  }

  func _openSystemTheme() {
    CardKConfig.shared.language = "fr";
    if #available(iOS 13.0, *) {
      CardKConfig.shared.theme = CardKTheme.system();
    } else {
      CardKConfig.shared.theme = CardKTheme.default();
    };

    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = true

    if #available(iOS 13.0, *) {
      self.present(controller, animated: true)
      return;
    }

    let navController = UINavigationController(rootViewController: controller)
    navController.modalPresentationStyle = .formSheet

    let closeBarButtonItem = UIBarButtonItem(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(_close(sender:))
    )
    controller.navigationItem.leftBarButtonItem = closeBarButtonItem
    self.present(navController, animated: true)
  }
  
  func _openCustomTheme() {
    let theme = CardKTheme();
  
    theme.colorLabel = UIColor.black;
    theme.colorPlaceholder = UIColor.gray;
    theme.colorErrorLabel = UIColor.red;
    theme.colorTableBackground = UIColor.lightGray;
    theme.colorCellBackground = UIColor.white;
    theme.colorSeparatar = UIColor.darkGray;
    theme.colorButtonText = UIColor.orange;
    
    CardKConfig.shared.language = "fr";
    CardKConfig.shared.theme = theme;


    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
    controller.purchaseButtonTitle = "Custom purchase button";

    if #available(iOS 13.0, *) {
      self.present(controller, animated: true)
      return;
    }

    let navController = UINavigationController(rootViewController: controller)
    navController.modalPresentationStyle = .formSheet

    let closeBarButtonItem = UIBarButtonItem(
      title: "Close",
      style: .done,
      target: self,
      action: #selector(_close(sender:))
    )
    controller.navigationItem.leftBarButtonItem = closeBarButtonItem
    self.present(navController, animated: true)
    CardIOUtilities.preloadCardIO()
  }

  func _openLightUINavigation() {
    CardKConfig.shared.language = "es";
    CardKConfig.shared.theme = CardKTheme.light();


    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = false;
    controller.purchaseButtonTitle = "Custom purchase button";

    self.navigationController?.pushViewController(controller, animated: true)
  }

  func _openDarkUINavigation() {
    CardKConfig.shared.language = "es";
    CardKConfig.shared.theme = CardKTheme.dark();

    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.allowedCardScaner = false;
    controller.cKitDelegate = self

    self.navigationController?.pushViewController(controller, animated: true)
  }

  func _openSystemUINavigation() {
    CardKConfig.shared.language = "fr";

    if #available(iOS 13.0, *) {
      CardKConfig.shared.theme = CardKTheme.system();
    } else {
      CardKConfig.shared.theme = CardKTheme.default();
    };


    let controller = CardKViewController(publicKey: publicKey, mdOrder:"mdOrder");
    controller.cKitDelegate = self
    controller.allowedCardScaner = true
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func _callFunctionByKindOfButton(kind: SectionItem.Kind) {
    switch kind {
    case .lightTheme: _openController()
    case .darkTheme: _openDark()
    case .systemTheme: _openSystemTheme()
    case .customTheme: _openCustomTheme()
    case .navLightTheme: _openLightUINavigation()
    case .navDarkTheme: _openDarkUINavigation()
    case .navSystemTheme: _openSystemUINavigation()
    }
  }
  
  var sections: [Section] = [
    Section(title: "Modal", items: [
      SectionItem(title: "Open Light", kind: .lightTheme, isShowChevron: false),
      SectionItem(title: "Dark Light", kind: .darkTheme, isShowChevron: false),
      SectionItem(title: "System theme", kind: .systemTheme, isShowChevron: false),
      SectionItem(title: "Custom theme", kind: .customTheme, isShowChevron: false)
    ]),
    
    Section(title: "Navigation", items: [
      SectionItem(title: "Open Light", kind: .navLightTheme, isShowChevron: true),
      SectionItem(title: "Dark Light", kind: .navDarkTheme, isShowChevron: true),
      SectionItem(title: "System theme", kind: .navSystemTheme, isShowChevron: true)
    ])
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Examples"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].items.count;
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
    let item = sections[indexPath.section].items[indexPath.item];
    cell.textLabel?.text = item.title
    cell.accessoryType = item.isShowChevron ? .disclosureIndicator : .none

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = self.sections[indexPath.section].items[indexPath.item];
    
    _callFunctionByKindOfButton(kind: item.kind);
    if indexPath.section == 0 {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return true
  }
}

extension ViewController: CardKViewControllerDelegate {
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String) {
    debugPrint(seToken)

    let alert = UIAlertController(title: "SeToken", message: seToken, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    controller.present(alert, animated: true)
    
  }
  
  func cardKitViewControllerScanCardRequest(_ controller: CardKViewController) {
    let cardIO = CardIOView(frame: controller.view.bounds)
    cardIO.hideCardIOLogo = true
    cardIO.scanExpiry = false
    cardIO.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    sampleAppCardIO = SampleAppCardIO()
    sampleAppCardIO?.cardKController = controller
    cardIO.delegate = sampleAppCardIO
    
    controller.showScanCardView(cardIO, animated: true)
  }
}

