//
//  CardKCardCell.m
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKCardView.h"
#import "CardKTextField.h"
#import "PaymentSystemProvider.h"
#import "Luhn.h"

@implementation CardKCardView {
  UIImageView *_paymentSystemImageView;
  CardKTextField *_numberTextField;
  CardKTextField *_expireDateTextField;
  CardKTextField *_secureCodeTextField;
  CardKTextField *_focusedField;
  NSMutableArray *_errorMessagesArray;
  NSBundle *_bundle;
  BOOL _allowedCardScaner;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    CardKTheme *theme = [CardKTheme shared];

    _bundle = [NSBundle bundleForClass:[CardKCardView class]];

    _errorMessagesArray = [[NSMutableArray alloc] init];
    
    _paymentSystemImageView = [[UIImageView alloc] init];
    _paymentSystemImageView.contentMode = UIViewContentModeCenter;
    UIImage *img = [PaymentSystemProvider
                    imageByCardNumber:_allowedCardScaner ? nil : @""
                    compatibleWithTraitCollection: self.traitCollection];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callScanCard:)];

    [_paymentSystemImageView addGestureRecognizer:tapGestureRecognizer];
    _paymentSystemImageView.userInteractionEnabled = YES;
    _paymentSystemImageView.image = img;
    [_paymentSystemImageView setTintColor: theme.colorLabel];
    

    [self addSubview:_paymentSystemImageView];

    _numberTextField = [[CardKTextField alloc] init];
    _numberTextField.pattern = CardKTextFieldPatternCardNumber;
    _numberTextField.placeholder = NSLocalizedStringFromTableInBundle(@"Card Number", nil, _bundle, @"Card number placeholder");
    _numberTextField.accessibilityLabel = nil;
    [_numberTextField showCoverView];
    
    _expireDateTextField = [[CardKTextField alloc] init];
    _expireDateTextField.pattern = CardKTextFieldPatternExpirationDate;
    _expireDateTextField.placeholder = NSLocalizedStringFromTableInBundle(@"MM/YY", nil, _bundle, @"Expiration date placeholder");
    _expireDateTextField.format = @"  /  ";
    _expireDateTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"expiry", nil, _bundle, @"Expiration date accessiblity label");
    
    _secureCodeTextField = [[CardKTextField alloc] init];
    _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
    _secureCodeTextField.placeholder = NSLocalizedStringFromTableInBundle(@"CVC", nil, _bundle, @"CVC placeholder");
    _secureCodeTextField.secureTextEntry = YES;
    _secureCodeTextField.accessibilityLabel = NSLocalizedStringFromTableInBundle(@"cvc", nil, _bundle, @"CVC accessibility");
  
    for (CardKTextField *v in @[_numberTextField, _expireDateTextField, _secureCodeTextField]) {
      [self addSubview:v];
      v.keyboardType = UIKeyboardTypeNumberPad;
      [v addTarget:self action:@selector(_switchToNext:) forControlEvents:UIControlEventEditingDidEnd];
      [v addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    _numberTextField.textContentType = UITextContentTypeCreditCardNumber;
    
    [_numberTextField addTarget:self action:@selector(_numberChanged) forControlEvents:UIControlEventValueChanged];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  
  return self;
}

- (void)callScanCard:(UITapGestureRecognizer *)gestureRecognizer{
  if (_allowedCardScaner && [_numberTextField.text length] == 0) {
    NSLog(@"You can call it");
    return;
  }

  NSLog(@"You can't call it");
}

- (nullable NSString *)getFullYearFromExpirationDate {
  NSString *text = _expireDateTextField.text;
  if (text.length < 4) {
    return nil;
  }
  NSString *year = [text substringFromIndex:2];
  return [NSString stringWithFormat:@"20%@", year];
}

- (nullable NSString *)getMonthFromExpirationDate {
  NSString *text = _expireDateTextField.text;
  if (text.length < 4) {
    return nil;
  }
  return [text substringToIndex:2];
}


- (NSArray *)errorMessages {
  return [_errorMessagesArray copy];
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  _errorMessagesArray = [errorMessages mutableCopy];
}

- (void)setAllowedCardScaner:(BOOL)allowedCardScaner {
  _allowedCardScaner = allowedCardScaner;
}

- (BOOL)allowedCardScaner {
  return _allowedCardScaner;
}
- (NSString *)number {
  return _numberTextField.text;
}

- (NSString *)expirationDate {
  return _expireDateTextField.text;
}

- (NSString *)secureCode {
  return _secureCodeTextField.text;
}

- (void)cleanErrors {
  [_errorMessagesArray removeAllObjects];
}

- (BOOL)_validateCardNumber:(NSString *)cardNumber {
  BOOL result = YES;
  NSString *incorrectLength = NSLocalizedStringFromTableInBundle(@"incorrectLength", nil, _bundle, @"Incorrect card length");
  NSString *incorrectCardNumber = NSLocalizedStringFromTableInBundle(@"incorrectCardNumber", nil, _bundle, @"Incorrect card number");
  
  [_errorMessagesArray removeObject:incorrectLength];
  [_errorMessagesArray removeObject:incorrectCardNumber];
  
  NSInteger len = [cardNumber length];
  if (len < 16 || len > 19) {
    [_errorMessagesArray addObject:incorrectLength];
    result = NO;
  } else if (![cardNumber isValidCreditCardNumber]) {
    [_errorMessagesArray addObject:incorrectCardNumber];
    result = NO;
  }
  
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  return result;
}

- (BOOL)_validateExpireDate:(NSString *)expireDate {
  BOOL result = YES;
  NSString *incorrectExpiry = NSLocalizedStringFromTableInBundle(@"incorrectExpiry", nil, _bundle, @"incorrectExpiry");
  [_errorMessagesArray removeObject:incorrectExpiry];

  if ([expireDate length] < 4) {
    [_errorMessagesArray addObject:incorrectExpiry];
    result = NO;
  }
  
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  return result;
}

- (BOOL)_validateSecureCode:(NSString *)secureCode {
  BOOL result = YES;
  NSString *incorrectCvc = NSLocalizedStringFromTableInBundle(@"incorrectCvc", nil, _bundle, @"incorrectCvc");
  
  [_errorMessagesArray removeObject:incorrectCvc];
  if ([secureCode length] < 3) {
    [_errorMessagesArray addObject:incorrectCvc];
    result = NO;
  }
  
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  return result;
}

- (void)_validateField:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  
  if (field == _numberTextField) {
    _numberTextField.showError = ![self _validateCardNumber:field.text];
    return;
  }
  
  if (field == _expireDateTextField) {
    _expireDateTextField.showError = ![self _validateExpireDate:field.text];
    return;
  }
  
  if (field == _secureCodeTextField) {
    _secureCodeTextField.showError =! [self _validateSecureCode:field.text];
    return;
  }
  
   field.showError = NO;
}

- (void)_numberChanged {
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
  NSString *number = self.number ?: @"";
  if (_allowedCardScaner && number.length == 0) {
    number = nil;
  }
  UIImage *image = [PaymentSystemProvider imageByCardNumber:number compatibleWithTraitCollection: self.traitCollection];
  [_paymentSystemImageView setImage:image];
}

- (void)_switchToNext:(UIView *)sender {
  [self _validateField:sender];
  
  NSArray *fields = @[_numberTextField, _expireDateTextField, _secureCodeTextField];
  NSInteger index = [fields indexOfObject:sender];
  if (index == NSNotFound) {
    return;
  }
  
  index += 1;
  if (index < fields.count) {
    [fields[index] becomeFirstResponder];
  }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
  [super traitCollectionDidChange:previousTraitCollection];
  [self _numberChanged];
}

- (void)_editingDidBegin:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;

  if (field.showError) {
    field.showError = false;
    [self cleanErrors];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }

  if (field == _focusedField) {
    
    return;
  }
  
  if (_focusedField != _numberTextField && field != _numberTextField) {
    _focusedField = field;
    return;
  }
  _focusedField = field;
  [UIView animateWithDuration:0.3 animations:^{
    [self setNeedsLayout];
    [self layoutIfNeeded];
  }];
}

- (void)layoutSubviews {
  CGRect bounds = self.bounds;
  CGFloat height = bounds.size.height;
  
  CGFloat width = bounds.size.width - 10;
  CGFloat imageWidth = 50;
  
  if (_focusedField == _numberTextField) {
    _numberTextField.frame = CGRectMake(imageWidth, 0, _numberTextField.intrinsicContentSize.width, height);
    _expireDateTextField.frame = CGRectMake(CGRectGetMaxX( _numberTextField.frame), 0, _expireDateTextField.intrinsicContentSize.width, bounds.size.height);
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX( _expireDateTextField.frame), 0, _secureCodeTextField.intrinsicContentSize.width, height);
  } else {
    CGFloat numberWidth = _numberTextField.intrinsicContentSize.width;
    CGFloat secCodeWidth = _secureCodeTextField.intrinsicContentSize.width;
    CGFloat expireDateWidth = _expireDateTextField.intrinsicContentSize.width;
    
    CGFloat leftSpace = width - imageWidth - secCodeWidth - expireDateWidth;
    if (leftSpace < numberWidth) {
      numberWidth = leftSpace;
    }
    
    _numberTextField.frame = CGRectMake(imageWidth, 0, numberWidth, height);
    _expireDateTextField.frame = CGRectMake(CGRectGetMaxX(_numberTextField.frame), 0, expireDateWidth, height);
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX(_expireDateTextField.frame), 0, secCodeWidth, height);
  }
  
  _paymentSystemImageView.frame = CGRectMake(0, 0, imageWidth, bounds.size.height);
  
  [super layoutSubviews];
}

@end
