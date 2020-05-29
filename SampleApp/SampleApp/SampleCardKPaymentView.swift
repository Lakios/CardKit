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
  
  override func viewDidLoad() {
    self.view.backgroundColor = CardKTheme.light().colorTableBackground;
    let cardKPaymentView = CardKPaymentView();
    cardKPaymentView.controller = self;
    cardKPaymentView.cKitDelegate = self;
    self.view.addSubview(cardKPaymentView);
    cardKPaymentView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100);
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
