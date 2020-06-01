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
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  
  NSInteger screenWidth = screenRect.size.width;
  NSInteger height = bounds.size.height;
  NSInteger width = bounds.size.width;
  NSInteger maxButtonWidth = screenWidth / 3;
  NSInteger maxButtonHeight = 44;
  NSInteger minButtonHeight = 30;
  NSInteger minButtonWidth = 100;
  
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    maxButtonWidth = screenWidth / 4;
    maxButtonHeight = 60;
    minButtonHeight = 44;
  }

  NSInteger buttonHeight = height;
  
  if (height > maxButtonHeight) {
    buttonHeight = maxButtonHeight;
  } else if (height < minButtonHeight) {
    buttonHeight = minButtonHeight;
  }
  
  NSInteger buttonWidth = width / 2;
  
  if (width / 2 >= maxButtonWidth) {
    buttonWidth = maxButtonWidth;
  } else if (width / 2 < minButtonWidth) {
    buttonWidth = minButtonWidth;
  }
  
  if (width < 100) {
    _applePayButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    _button.frame = CGRectMake(0, CGRectGetMaxY(_applePayButton.frame), buttonWidth, buttonHeight);
    return;
  }

  if (height >= 100) {
    _button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    _applePayButton.frame = CGRectMake(CGRectGetMaxX(_button.frame), 0, buttonWidth, buttonHeight);
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
