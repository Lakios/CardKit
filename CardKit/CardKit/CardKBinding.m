//
//  UIViewController+CardKBankItem.m
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKBinding.h"
#import "PaymentSystemProvider.h"



@implementation CardKBinding {
  UIImageView * _paymentSystemImageView;
  NSBundle *_bundle;
  UILabel *_label;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKBinding class]];
    
    _paymentSystemImageView = [[UIImageView alloc] init];
    _paymentSystemImageView.contentMode = UIViewContentModeCenter;
    _label = [[UILabel alloc] init];
    
    [self addSubview:_label];
    [self addSubview:_paymentSystemImageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  NSString *imageName = [PaymentSystemProvider imageNameByPaymentSystem: _paymentSystem compatibleWithTraitCollection: self.traitCollection];
  _paymentSystemImageView.image = [PaymentSystemProvider namedImage:imageName inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];
  
  _label.text = _cardNumber;
  CGRect bounds = self.superview.bounds;
  
  if (@available(iOS 11.0, *)) {
    _paymentSystemImageView.frame = CGRectMake(self.safeAreaInsets.left, 0, 50, bounds.size.height);
    _label.frame = CGRectMake(CGRectGetMaxX(_paymentSystemImageView.frame), 0, _label.intrinsicContentSize.width, bounds.size.height);
  } else {
    _label.frame = CGRectMake(60, 0, bounds.size.width, bounds.size.height);
    _paymentSystemImageView.frame = CGRectMake(0, 0, 50, bounds.size.height);
  }
}

@end
