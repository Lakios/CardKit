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

+(UIImage *)imageByCardNumber:(nullable NSString *)cardNumber compatibleWithTraitCollection:(nullable UITraitCollection *) traitCollection;

+(UIImage *)getCVCImageWithTraitCollection:(nullable UITraitCollection *) traitCollection;
@end

NS_ASSUME_NONNULL_END
