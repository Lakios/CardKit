//
//  UIViewController+CardKBankItem.m
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKBinding.h"
#import "PaymentSystemProvider.h"
#import "CardKConfig.h"

#import "CardKTextField.h"
#import "CardKFooterView.h"
#import "CardKValidation.h"
#import "CardKBankLogoView.h"
#import "RSA.h"

@implementation CardKBinding {
  UIImageView * _paymentSystemImageView;
  NSBundle *_bundle;
  UILabel *_cardNumberLabel;
  UILabel *_expireDateLabel;
  UIImage *_image;
  CardKFooterView *_secureCodeFooterView;
  CardKTextField *_secureCodeTextField;
  NSMutableArray *_secureCodeErrors;
  NSString *_lastAnouncment;
  NSBundle *_languageBundle;
  BOOL _showCVCField;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKBinding class]];
     
     NSString *language = CardKConfig.shared.language;

     _secureCodeErrors = [[NSMutableArray alloc] init];
    
     if (language != nil) {
       _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
     } else {
       _languageBundle = _bundle;
     }
    
    _secureCodeTextField = [[CardKTextField alloc] init];
    _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
    _secureCodeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CVC", nil, _languageBundle, @"CVC placeholder");
    _secureCodeTextField.secureTextEntry = YES;
    _secureCodeTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"cvc", nil, _languageBundle, @"CVC accessibility");
    _secureCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_secureCodeTextField addTarget:self action:@selector(_clearSecureCodeErrors) forControlEvents:UIControlEventEditingDidBegin];
    [_secureCodeTextField addTarget:self action:@selector(_clearSecureCodeErrors) forControlEvents:UIControlEventValueChanged];
    
    _expireDateLabel = [[UILabel alloc] init];
    _paymentSystemImageView = [[UIImageView alloc] init];
    _paymentSystemImageView.contentMode = UIViewContentModeCenter;
    
    UIFont *font = [self _font];
    _cardNumberLabel = [[UILabel alloc] init];
    _cardNumberLabel.font = font;
    
    [self addSubview:_cardNumberLabel];
    [self addSubview:_paymentSystemImageView];
    [self addSubview:_expireDateLabel];

    CardKTheme *theme = CardKConfig.shared.theme;
    [_cardNumberLabel setTextColor: theme.colorLabel];
    [_expireDateLabel setTextColor: theme.colorLabel];
  }
  return self;
}

- (void)setShowCVCField:(BOOL)showCVCField {
  _showCVCField = showCVCField;
  if (CardKConfig.shared.bindingCVCRequired && showCVCField) {
   [self addSubview:_secureCodeTextField];
  }
}

- (BOOL)showCVCField {
  return _showCVCField;
}

- (void)focusSecureCode {
  if (CardKConfig.shared.bindingCVCRequired) {
    [_secureCodeTextField becomeFirstResponder];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _expireDateLabel.text = _expireDate;

  NSString *imageName = [PaymentSystemProvider imageNameByPaymentSystem: _paymentSystem compatibleWithTraitCollection: self.traitCollection];
  _image = [PaymentSystemProvider namedImage:imageName inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
  _paymentSystemImageView.image = _image;
  
  [self replaceTextWithCircleBullet];
  
  CGRect bounds = self.superview.bounds;
  NSInteger leftExpireDate = bounds.size.width - _expireDateLabel.intrinsicContentSize.width - 10;
  if (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    bounds = self.bounds;
    leftExpireDate = bounds.size.width - _expireDateLabel.intrinsicContentSize.width - 20;
  }
  
  if (CardKConfig.shared.bindingCVCRequired &&  _showCVCField) {
    leftExpireDate = leftExpireDate - _secureCodeTextField.intrinsicContentSize.width;
  }
  
  if (@available(iOS 11.0, *)) {
    _paymentSystemImageView.frame = CGRectMake(self.safeAreaInsets.left + 10, 0, 50, bounds.size.height);
  } else {
    _paymentSystemImageView.frame = CGRectMake(0, 0, 50, bounds.size.height);
  }
  
  _cardNumberLabel.frame = CGRectMake(CGRectGetMaxX(_paymentSystemImageView.frame) + 10, 0, _cardNumberLabel.intrinsicContentSize.width, bounds.size.height);
  _expireDateLabel.frame = CGRectMake(leftExpireDate, 0, _expireDateLabel.intrinsicContentSize.width, bounds.size.height);
  _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX(_expireDateLabel.frame), 0, _secureCodeTextField.intrinsicContentSize.width, bounds.size.height);
}

- (void) replaceTextWithCircleBullet {
  NSString *bullet = @"\u2022";
  NSString *displayText = [_cardNumber stringByReplacingOccurrencesOfString:@"X" withString:bullet];
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayText];

  NSRange firstBullet = [displayText rangeOfString:bullet];
  NSRange lastBullet = [displayText rangeOfString:bullet options:NSBackwardsSearch];
  NSRange bulletsRange = NSMakeRange(firstBullet.location,  lastBullet.location - firstBullet.location + 1);
  
  [attributedString addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Menlo-bold" size:22.0]} range:bulletsRange];
  [attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:bulletsRange];
  
  [_cardNumberLabel setTextAlignment:NSTextAlignmentCenter];
  _cardNumberLabel.attributedText = attributedString ;
  _cardNumberLabel.adjustsFontSizeToFitWidth = YES;
  [_cardNumberLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
  
}

- (UIFont *)_font {
  return [UIFont fontWithName:@"Menlo" size: 17];
}


- (void)_refreshErrors {
  _secureCodeFooterView.errorMessages = _secureCodeErrors;
  [self _announceError];
}
- (void)_announceError {
  NSString *errorMessage = [_secureCodeErrors firstObject];
  if (errorMessage.length > 0 && ![_lastAnouncment isEqualToString:errorMessage]) {
    _lastAnouncment = errorMessage;
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _lastAnouncment);
  }
}

- (void)_clearSecureCodeErrors {
  [_secureCodeErrors removeAllObjects];
  _secureCodeTextField.showError = NO;
  [self _refreshErrors];
}

- (void)_validateSecureCode {
  BOOL isValid = YES;
  NSString *secureCode = _secureCodeTextField.text;
  NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _languageBundle, @"incorrectCvc");
  [self _clearSecureCodeErrors];
  
  if (![CardKValidation isValidSecureCode:secureCode]) {
    [_secureCodeErrors addObject:incorrectCvc];
    isValid = NO;
  }
  
  _secureCodeTextField.showError = !isValid;
}

- (void)validate {
  [self _validateSecureCode];
}

- (NSArray *)errorMessages {
  return [_secureCodeErrors copy];
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  _secureCodeErrors = [errorMessages mutableCopy];
}

@end
