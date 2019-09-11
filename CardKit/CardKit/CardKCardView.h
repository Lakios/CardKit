//
//  CardKCardCell.h
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKCardView : UIControl

@property (readonly) NSString *number;
@property (readonly) NSString *expirationDate;
@property (readonly) NSString *secureCode;
-(NSString *)getMonthFromExpirationDate;
-(NSString *)getFullYearFromExpirationDate;

@end

NS_ASSUME_NONNULL_END
