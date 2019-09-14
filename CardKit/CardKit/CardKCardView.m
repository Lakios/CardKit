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

@implementation CardKCardView {
  UIImageView *_paymentSystemImageView;
  CardKTextField *_numberTextField;
  CardKTextField *_expireDateTextField;
  CardKTextField *_secureCodeTextField;
  CardKTextField *_focusedField;
  NSMutableArray *_errorMessagesArray;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {

    _errorMessagesArray = [[NSMutableArray alloc] init];
    
    _paymentSystemImageView = [[UIImageView alloc] init];
    _paymentSystemImageView.contentMode = UIViewContentModeCenter;
    _paymentSystemImageView.image = [PaymentSystemProvider imageByCardNumber:@"" compatibleWithTraitCollection: self.traitCollection];
    [self addSubview:_paymentSystemImageView];
    
    _numberTextField = [[CardKTextField alloc] init];
    _numberTextField.pattern = CardKTextFieldPatternCardNumber;
    _numberTextField.placeholder = @"Number";

    _expireDateTextField = [[CardKTextField alloc] init];
    _expireDateTextField.pattern = CardKTextFieldPatternExpirationDate;
    _expireDateTextField.placeholder = @"MM/YY";
    _expireDateTextField.format = @"  /  ";
    
    _secureCodeTextField = [[CardKTextField alloc] init];
    _secureCodeTextField.pattern = CardKTextFieldPatternSecureCode;
    _secureCodeTextField.placeholder = @"CVC";
    _secureCodeTextField.secureTextEntry = YES;
  
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

-(NSString *)getFullYearFromExpirationDate {
  NSString *expireDateTextField = _expireDateTextField.text;
  NSString *year = [expireDateTextField substringFromIndex:2];
  NSString *fullYear = [NSString stringWithFormat:@"20%@", year];
  
  return fullYear;
}

- (NSString *)getMonthFromExpirationDate {
  NSString *expireDateTextField = _expireDateTextField.text;
  NSString *month = [expireDateTextField substringToIndex:2];
  
  return month;
}


- (NSArray *)errorMessages {
  return [_errorMessagesArray copy];
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  _errorMessagesArray = [errorMessages mutableCopy];
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
  [_errorMessagesArray removeObject:@"Номер карты"];
  if ([cardNumber length] < 16) {
    [_errorMessagesArray addObject:@"Номер карты"];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

    return YES;
  }
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  return NO;
}

- (BOOL)_validateExpireDate:(NSString *)expireDate {
  [_errorMessagesArray removeObject:@"Дата"];

  if ([expireDate length] < 4) {
    [_errorMessagesArray addObject:@"Дата"];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    return YES;
  }
  
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  return NO;
}

- (BOOL)_validateSecureCode:(NSString *)secureCode {
  [_errorMessagesArray removeObject:@"CVC"];
  if ([secureCode length] < 3) {
    [_errorMessagesArray addObject:@"CVC"];
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    
    return YES;
  }
  
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];

  return NO;
}

- (void)_validateField:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  
  if (field == _numberTextField) {
    _numberTextField.showError = [self _validateCardNumber:field.text];
    return;
  }
  
  if (field == _expireDateTextField) {
    _expireDateTextField.showError = [self _validateExpireDate:field.text];
    return;
  }
  
  if (field == _secureCodeTextField) {
    _secureCodeTextField.showError = [self _validateSecureCode:field.text];
    return;
  }
  
   field.showError = NO;
}

- (void)_numberChanged {
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
  UIImage *image = [PaymentSystemProvider imageByCardNumber:self.number compatibleWithTraitCollection: self.traitCollection];
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
  CGFloat height = self.bounds.size.height;
  
  CGFloat width = bounds.size.width - 10;
  
  if (_focusedField == _numberTextField) {
    _numberTextField.frame = CGRectMake(50, 0, _numberTextField.intrinsicContentSize.width, height);
    _expireDateTextField.frame = CGRectMake( CGRectGetMaxX( _numberTextField.frame), 0, _expireDateTextField.intrinsicContentSize.width, bounds.size.height);
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX( _expireDateTextField.frame), 0, _secureCodeTextField.intrinsicContentSize.width, height);
  } else {
    CGFloat numberWidth = _numberTextField.intrinsicContentSize.width;
    CGFloat secCodeWidth = _secureCodeTextField.intrinsicContentSize.width;
    CGFloat expireDateWidth = _expireDateTextField.intrinsicContentSize.width;
    
    CGFloat leftSpace = width - 50 - secCodeWidth - expireDateWidth;
    if (leftSpace < numberWidth) {
      numberWidth = leftSpace;
    }
    
    _numberTextField.frame = CGRectMake(50, 0, numberWidth, height);
    _expireDateTextField.frame = CGRectMake(CGRectGetMaxX(_numberTextField.frame), 0, expireDateWidth, height);
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX(_expireDateTextField.frame), 0, secCodeWidth, height);
  }
  
  _paymentSystemImageView.frame = CGRectMake(0, 0, 50, bounds.size.height);
  
  [super layoutSubviews];
  
  NSLog(@"done");
  
}

@end
