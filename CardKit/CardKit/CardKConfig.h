//
//  CardKConfig.h
//  CardKit
//
//  Created by Alex Korotkov on 10/1/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKConfig : NSObject

@property (strong, nonatomic) CardKTheme *theme;
@property (strong, nonatomic) NSString *language;

@property (class, strong, nonatomic) CardKConfig *shared;
@end

NS_ASSUME_NONNULL_END
