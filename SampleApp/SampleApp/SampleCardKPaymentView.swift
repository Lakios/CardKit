//
//  SampleCardKPaymentView.swift
//  SampleApp
//
//  Created by Alex Korotkov on 5/28/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

import UIKit
import CardKit

class SampleCardKPaymentView: UIViewController {
  var buttons: [CardKPaymentView] = [];
  
  override func viewDidLoad() {
    self.view.backgroundColor = CardKTheme.light().colorTableBackground;
    CardKConfig.shared.paymentButtonStyle = .white;
    CardKConfig.shared.paymentButtonType = .buy;
    let buttonsCGRect = _getButtons();

    for buttonCGRect in buttonsCGRect {
      let cardKPaymentView = CardKPaymentView();
      cardKPaymentView.controller = self;
      cardKPaymentView.cKitDelegate = self;
      self.view.addSubview(cardKPaymentView);
      cardKPaymentView.frame = buttonCGRect;
      buttons.append(cardKPaymentView);
    }
  }
  
  
  override func viewDidLayoutSubviews() {
    let buttonsCGRect = _getButtons();

    for (index, button) in buttons.enumerated() {
     button.frame = buttonsCGRect[index];
     self.view.addSubview(button);
    }
  }
  
  func _getButtons() -> [CGRect] {
    let height = self.view.bounds.height;
    let width = self.view.bounds.width;
    
    let buttonsCGRect = [
     CGRect(x: 0, y: 0, width: 100, height: 100),
     CGRect(x: width - 100, y: 0, width: 60, height: 60),
     CGRect(x: width * 0.5 - 50 , y: height * 0.5 - 100, width: 30, height: 30),
     CGRect(x: 0, y: height * 0.5, width: width, height: 100),
     CGRect(x: width - 100, y: height - 100, width: 50, height: 35),
     CGRect(x: 0, y: height - 100, width: 100, height: 100),
    ];
    
    return buttonsCGRect;
  }
}

extension SampleCardKPaymentView: CardKViewControllerDelegate {
  func willShowPaymentView(_ controller: UIView, paymentRequest: PKPaymentRequest) {
    let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
    let paymentItem = PKPaymentSummaryItem.init(label: "Test", amount: NSDecimalNumber(value: 10))
    
    paymentRequest.currencyCode = "USD"
    paymentRequest.countryCode = "US"
    paymentRequest.merchantIdentifier = "merchant.test"
    paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
    paymentRequest.supportedNetworks = paymentNetworks
    paymentRequest.paymentSummaryItems = [paymentItem]
  }
  
  func willShow(_ controller: CardKViewController) {
  }
  
  func cardKitViewController(_ controller: CardKViewController, didCreateSeToken seToken: String, allowSaveCard: Bool) {
  }
  
  func cardKitViewControllerScanCardRequest(_ controller: CardKViewController) {
  }
}
