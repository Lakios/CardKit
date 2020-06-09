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


@implementation CardKBinding {
  UIImageView * _paymentSystemImageView;
  NSBundle *_bundle;
  UILabel *_cardNumberLabel;
  UILabel *_expireDateLabel;
  UIImage *_image;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _bundle = [NSBundle bundleForClass:[CardKBinding class]];
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
    leftExpireDate = bounds.size.width - _expireDateLabel.intrinsicContentSize.width * 2;
  }
  
  if (@available(iOS 11.0, *)) {
    _paymentSystemImageView.frame = CGRectMake(self.safeAreaInsets.left + 10, 0, 50, bounds.size.height);
  } else {
    _paymentSystemImageView.frame = CGRectMake(0, 0, 50, bounds.size.height);
  }
  
  _cardNumberLabel.frame = CGRectMake(CGRectGetMaxX(_paymentSystemImageView.frame) + 10, 0, _cardNumberLabel.intrinsicContentSize.width, bounds.size.height);
  _expireDateLabel.frame = CGRectMake(leftExpireDate, 0, _expireDateLabel.intrinsicContentSize.width, bounds.size.height);
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
@end
