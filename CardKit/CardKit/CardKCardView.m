//
//  CardKCardCell.m
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKCardView.h"
#import "CardKTextField.h"


@implementation CardKCardView {
  UIImageView *_paymentSystemImageView;
  CardKTextField *_numberTextField;
  CardKTextField *_expireDateTextField;
  CardKTextField *_secureCodeTextField;
  
  CardKTextField *_focusedField;
}

- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    _paymentSystemImageView = [[UIImageView alloc] init];
    _paymentSystemImageView.backgroundColor = UIColor.orangeColor;
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
    
    for (CardKTextField *v in @[_numberTextField, _expireDateTextField, _secureCodeTextField]) {
      [self addSubview:v];
      v.keyboardType = UIKeyboardTypeNumberPad;
      [v addTarget:self action:@selector(_switchToNext:) forControlEvents:UIControlEventEditingDidEnd];
      [v addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
    _numberTextField.textContentType = UITextContentTypeCreditCardNumber;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  
  return self;
}

- (void)_switchToNext:(UIView *)sender {
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

- (void)_editingDidBegin:(UIView *)sender {
  CardKTextField * field = (CardKTextField *)sender;
  
  if (field == _focusedField) {
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
  
  CGFloat width = bounds.size.width;
  
  if (_focusedField == _numberTextField) {
    _numberTextField.frame = CGRectMake(50, 0, _numberTextField.intrinsicContentSize.width, bounds.size.height);
    _expireDateTextField.frame = CGRectMake( CGRectGetMaxX( _numberTextField.frame), 0, _expireDateTextField.intrinsicContentSize.width, bounds.size.height);
    _secureCodeTextField.frame = CGRectMake(CGRectGetMaxX( _expireDateTextField.frame), 0, _secureCodeTextField.intrinsicContentSize.width, bounds.size.height);
  } else {
    _numberTextField.frame = CGRectMake(50, 0, 100, bounds.size.height);
    _expireDateTextField.frame = CGRectMake(200, 0, 60, bounds.size.height);
    _secureCodeTextField.frame = CGRectMake(260, 0, 50, bounds.size.height);
  }
  
  _paymentSystemImageView.frame = CGRectMake(0, 0, 50, bounds.size.height);
  
  [super layoutSubviews];
  
  NSLog(@"done");
  
}

@end
