//
//  PaymentSystemProvider.m
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "PaymentSystemProvider.h"

@implementation PaymentSystemProvider {
  CardKTheme *_theme;
}

+ (BOOL) checkCurdNumber:(NSString*)regEx cardNumber:(NSString*)cardNumber {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regEx options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger matches = [regex numberOfMatchesInString:cardNumber options:regex range:NSMakeRange(0, [cardNumber length])];
    
    if (error) {
        return NO;
    }

    if (matches && matches > 0) {
        return YES;
    }
    
    return NO;
}

+ (BOOL) isJCB:(NSString *)cardNumber {
    if ((cardNumber && [cardNumber  isEqual: @""]) || [cardNumber length] < 4) {
        return false;
    }
    
    NSString *cardNumberPrefix = [cardNumber substringToIndex:4];
    NSInteger cardNumberInt = [cardNumberPrefix integerValue];
    
    NSInteger start[] = {3528, 3088, 3096, 3112, 3158, 3337};
    NSInteger end[] = {3589, 3094, 3102, 3120, 3159, 3349};
    
    for (NSInteger i = 0; i < (sizeof start) / (sizeof start[0]); i++) {
        if (start[i] <= cardNumberInt && cardNumberInt <= end[i]) {
            return true;
        }
    }
    
    return false;
}

+ (NSString *)getPaymentSystemNameByCardNumber:(NSString *)number {
    if ([number hasPrefix: @"4"]) {
        return @"visa";
    } else if ([number hasPrefix: @"220"]) {
        return @"mir";
    } else if ([self checkCurdNumber: @"^(5[1-5]|2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7([01][0-9]|20)))" cardNumber:number]) {
        return @"mastercard";
    } else if ([self checkCurdNumber: @"^(50|5[6-8]|6)" cardNumber:number]) {
        return @"maestro";
    } else if ([self checkCurdNumber: @"^(34|37)" cardNumber:number]) {
        return @"amex";
    } else if ([self isJCB:number]) {
        return @"jsb";
    }
    
    return @"unknown";
}

+ (UIImage *)getPaymentSystemImageByCardNumber:(NSString *)number traitCollectionStyle:(UIUserInterfaceStyle *) traitCollectionStyle {
  NSString *systemName = [self getPaymentSystemNameByCardNumber:number];
  CardKTheme *theme = [CardKTheme shared];

  NSString *imageAppearance = theme.imageAppearance;
  if (imageAppearance == nil && traitCollectionStyle == UIUserInterfaceStyleDark) {
    imageAppearance = @"dark";
  } else if (imageAppearance == nil && traitCollectionStyle == UIUserInterfaceStyleLight) {
    imageAppearance = @"light";
  }

  NSString *imageName = [NSString stringWithFormat:@"%@-%@", systemName, imageAppearance];
  
  return [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[PaymentSystemProvider self]] compatibleWithTraitCollection:nil];
}

@end

