//
//  PaymentSystemProvider.h
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentSystemProvider : UIView
  + (UIImage *)getPaymentSystemImageByCardNumber:(NSString *)cardNumber traitCollectionStyle:(nullable UIUserInterfaceStyle *) traitCollectionStyle;

  @property (strong) CardKTheme *theme;
@end

NS_ASSUME_NONNULL_END
