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
  let language: String
  
  enum Kind {
    case lightTheme
    case darkTheme
    case systemTheme
    case customTheme
    case navLightTheme
    case navDarkTheme
    case navSystemTheme
    case language
  }
}

class SampleAppCardIO: NSObject, CardIOViewDelegate {
  weak var cardKController: CardKViewController? = nil
  
  func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
    if let info = cardInfo {
      cardKController?.setCardNumber(info.cardNumber, holderName: info.cardholderName, expirationDate: nil, cvc: nil, bindingId: nil)
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
    CardKConfig.shared.language = "";
    CardKConfig.shared.theme = CardKTheme.light()
    CardKConfig.shared.allowSaveBindings = false;
    CardKConfig.shared.allowApplePay = false;

    let controller = CardKViewController();
    controller.cKitDelegate = self;

    let createdNavController = CardKViewController.create(self, navigationController: self.navigationController, controller: controller);

    self.present(createdNavController, animated: true, completion: nil);
  }

  func _openDark() {
    CardKConfig.shared.theme = CardKTheme.dark();
    CardKConfig.shared.language = "";

    let controller = CardKViewController();
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
    CardKConfig.shared.language = "";
    if #available(iOS 13.0, *) {
      CardKConfig.shared.theme = CardKTheme.system();
    } else {
      CardKConfig.shared.theme = CardKTheme.default();
    };

    let controller = CardKViewController();
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
    
    CardKConfig.shared.theme = theme;
    CardKConfig.shared.language = "";

    let controller = CardKViewController();
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
    CardKConfig.shared.theme = CardKTheme.light();
    CardKConfig.shared.language = "";
    CardKConfig.shared.allowSaveBindings = false;
    CardKConfig.shared.allowApplePay = true;
    CardKConfig.shared.bindingCVCRequired = true;

    let controller = CardKViewController();
    controller.cKitDelegate = self

    let createdNavController = CardKViewController.create(self, navigationController: self.navigationController, controller: controller);
    
    self.navigationController?.pushViewController(createdNavController, animated: true);
  }

  func _openDarkUINavigation() {
    CardKConfig.shared.theme = CardKTheme.dark();
    CardKConfig.shared.language = "";
    
    let controller = CardKViewController();
    controller.allowedCardScaner = false;
    controller.cKitDelegate = self

    self.navigationController?.pushViewController(controller, animated: true)
  }

  func _openSystemUINavigation() {
    
    if #available(iOS 13.0, *) {
      CardKConfig.shared.theme = CardKTheme.system();
    } else {
      CardKConfig.shared.theme = CardKTheme.default();
    };

    let controller = CardKViewController();
    controller.cKitDelegate = self
    controller.allowedCardScaner = false
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  func _openWitchChooseLanguage(language: String) {
      CardKConfig.shared.language = language;
      CardKConfig.shared.theme = CardKTheme.light()
      
      let controller = CardKViewController();
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
  func _callFunctionByKindOfButton(kind: SectionItem.Kind, language: String) {
    switch kind {
    case .lightTheme: _openController()
    case .darkTheme: _openDark()
    case .systemTheme: _openSystemTheme()
    case .customTheme: _openCustomTheme()
    case .navLightTheme: _openLightUINavigation()
    case .navDarkTheme: _openDarkUINavigation()
    case .navSystemTheme: _openSystemUINavigation()
    case .language: _openWitchChooseLanguage(language: language)
    }
  }
  
  var sections: [Section] = [
    Section(title: "Modal", items: [
      SectionItem(title: "Open Light", kind: .lightTheme, isShowChevron: false, language: ""),
      SectionItem(title: "Dark Light", kind: .darkTheme, isShowChevron: false, language: ""),
      SectionItem(title: "System theme", kind: .systemTheme, isShowChevron: false, language: ""),
      SectionItem(title: "Custom theme", kind: .customTheme, isShowChevron: false, language: "")
    ]),
    
    Section(title: "Navigation", items: [
      SectionItem(title: "Open Light", kind: .navLightTheme, isShowChevron: true, language: ""),
      SectionItem(title: "Dark Light", kind: .navDarkTheme, isShowChevron: true, language: ""),
      SectionItem(title: "System theme", kind: .navSystemTheme, isShowChevron: true, language: "")
    ]),
    
    Section(title: "Localization", items: [
      SectionItem(title: "English - en", kind: .language, isShowChevron: false, language: "en"),
      SectionItem(title: "Russian - ru", kind: .language, isShowChevron: false, language: "ru"),
      SectionItem(title: "German - de", kind: .language, isShowChevron: false, language: "de"),
      SectionItem(title: "French - fr", kind: .language, isShowChevron: false, language: "fr"),
      SectionItem(title: "Spanish - es", kind: .language, isShowChevron: false, language: "es"),
      SectionItem(title: "Ukrainian - uk", kind: .language, isShowChevron: false, language: "uk"),
    ]),
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
    
    _callFunctionByKindOfButton(kind: item.kind, language: item.language);
    if !item.isShowChevron {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    return true
  }
}

extension ViewController: CardKViewControllerDelegate {
  func willShow(_ controller: CardKViewController) {
    controller.allowedCardScaner = CardIOUtilities.canReadCardWithCamera();
    controller.purchaseButtonTitle = "Custom purchase button";
    controller.isTestMod = true;
    controller.allowSaveBindings = true;
    controller.mdOrder = "mdOrder";
  }
  
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

