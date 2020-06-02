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
  PKPaymentButton *_applePayButton;
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  NSArray *_sections;
  id<CardKViewControllerDelegate> _cKitDelegate;
  PKPaymentAuthorizationViewController *_viewController;
}

- (instancetype)initWithDelegate:(id<CardKViewControllerDelegate>)cKitDelegate {
  self = [super init];
  if (self) {
    _paymentRequest = [[PKPaymentRequest alloc] init];

    _cardPaybutton =  [UIButton buttonWithType:UIButtonTypeSystem];
    
    [cKitDelegate willShowPaymentView:self];
    
    _bundle = [NSBundle bundleForClass:[CardKPaymentView class]];
     
     NSString *language = CardKConfig.shared.language;
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    _applePayButton = [[PKPaymentButton alloc] initWithPaymentButtonType: _paymentButtonType paymentButtonStyle: _paymentButtonStyle];
    
    [_applePayButton addTarget:self action:@selector(onApplePayButtonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _applePayButton];
    
    _cardPaybutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cardPaybutton.layer.cornerRadius = 4;
    [_cardPaybutton setBackgroundColor: CardKConfig.shared.theme.colorCellBackground];
    [_cardPaybutton setTitleColor: CardKConfig.shared.theme.colorLabel forState:UIControlStateNormal];
    [_cardPaybutton
      setTitle: NSLocalizedStringFromTableInBundle(@"payByCard", nil, _languageBundle,  @"Pay by card")
      forState: UIControlStateNormal];
    [_cardPaybutton addTarget:self action:@selector(_cardPaybuttonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_cardPaybutton];

    _cKitDelegate = cKitDelegate;
  }
  return self;
}

- (void)layoutSubviews {
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
    _cardPaybutton.frame = CGRectMake(0, CGRectGetMaxY(_applePayButton.frame) + 8, buttonWidth, buttonHeight);
    return;
  }

  if (height >= 100) {
    _cardPaybutton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    _applePayButton.frame = CGRectMake(CGRectGetMaxX(_cardPaybutton.frame) + 8, 0, buttonWidth, buttonHeight);
  }
}

-(IBAction)onApplePayButtonPressed:(id)sender
{
    _viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: _paymentRequest];
    _viewController.delegate = self;
    [_controller presentViewController:_viewController animated:YES completion:nil];
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [_controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
  NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:payment.token.paymentData options:kNilOptions error:nil];
  
  if (dict == nil) {
    completion(PKPaymentAuthorizationStatusFailure);
    
    [_cKitDelegate cardKPaymentView:self didCreateToken:dict];
    return;
  }
  
  completion(PKPaymentAuthorizationStatusSuccess);
}

- (void)_cardPaybuttonPressed:(UIButton *)button {
  CardKViewController *controller = [[CardKViewController alloc] init];
  controller.cKitDelegate = _cKitDelegate;
  [_controller.navigationController pushViewController:controller animated:YES];
}
@end
