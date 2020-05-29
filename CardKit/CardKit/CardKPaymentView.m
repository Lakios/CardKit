//
//  UIView+CardKPaymentView.m
//  CardKit
//
//  Created by Alex Korotkov on 5/28/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//
#import <PassKit/PassKit.h>
#import "CardKPaymentView.h"
#import "CardKConfig.h"
#import "CardKViewController.h"

@implementation CardKPaymentView {
  UIButton *_button;
  PKPaymentButton *_applePayButton;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  PKPaymentRequest *_paymentRequest;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _button =  [UIButton buttonWithType:UIButtonTypeSystem];
    
    _bundle = [NSBundle bundleForClass:[CardKPaymentView class]];
     
     NSString *language = CardKConfig.shared.language;
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    _applePayButton = [[PKPaymentButton alloc] initWithPaymentButtonType: CardKConfig.shared.paymentButtonType paymentButtonStyle: CardKConfig.shared.paymentButtonStyle];
    [_applePayButton addTarget:self action:@selector(onApplePayButtonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _applePayButton];
    
    
    [_button
      setTitle: NSLocalizedStringFromTableInBundle(@"payByCard", nil, _languageBundle,  @"Pay by card")
      forState: UIControlStateNormal];
    [_button addTarget:self action:@selector(_buttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    
    
    _paymentRequest = [[PKPaymentRequest alloc] init];
    
  }
  return self;
}

- (void)layoutSubviews {
  [_cKitDelegate willShowPaymentView:self paymentRequest: _paymentRequest];
  
  CGRect bounds = self.bounds;
  if (self.bounds.size.width < 100) {
    _button.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    _applePayButton.frame = CGRectMake(0, CGRectGetMaxY(_button.frame), bounds.size.width, 30);
  }

  if (self.bounds.size.width >= 100) {
    _button.frame = CGRectMake(0, 0, bounds.size.width / 2, bounds.size.height);
    _applePayButton.frame = CGRectMake(CGRectGetMaxX(_button.frame), 0, bounds.size.width / 2, 30);
  }
}

-(IBAction)onApplePayButtonPressed:(id)sender
{
    PKPaymentAuthorizationViewController *payment = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: _paymentRequest];

    [_controller presentViewController:payment animated:YES completion:nil];
 }

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [_controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
}

- (void)_buttonPressed:(UIButton *)button {
  CardKViewController *controller = [[CardKViewController alloc] init];
  controller.cKitDelegate = _cKitDelegate;
  [_controller.navigationController pushViewController:controller animated:YES];
}
@end
