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
    NSString *imageName = [PaymentSystemProvider imageNameByCardNumber: @"" compatibleWithTraitCollection: self.traitCollection];
    _paymentSystemImageView.image = [PaymentSystemProvider namedImage:imageName inBundle:_bundle compatibleWithTraitCollection:self.traitCollection];

    _label = [[UILabel alloc] init];
    
    [self addSubview:_label];
    [self addSubview:_paymentSystemImageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _label.text = _cardNumber;
  _label.frame = CGRectMake(60, 0, 100, 44);
  _paymentSystemImageView.frame = CGRectMake(0, 0, 50, 44);
}

@end
