//
//  CardKTheme.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardKTheme : NSObject

@property (strong, nonatomic) UIColor *colorHeader;
@property (strong, nonatomic) UIColor *colorLabel;
@property (strong, nonatomic) UIColor *colorPlaceholder;
@property (strong, nonatomic) UIColor *colorErrorLabel;
@property (strong, nonatomic) UIColor *colorTableBackground;
@property (strong, nonatomic, nullable) UIColor *colorCellBackground;
@property (strong, nonatomic) UIColor *separatarColor;
@property (strong, nonatomic, nullable) NSString *imageAppearance;
@property (strong, nonatomic) UIColor *collorButtonText;

+ (CardKTheme *)defaultTheme;
+ (CardKTheme *)darkTheme;
+ (CardKTheme *)lightTheme;
+ (CardKTheme *)systemTheme API_AVAILABLE(ios(13.0));
+ (CardKTheme *)shared;
+ (void)setTheme:(CardKTheme *)theme;
@end

NS_ASSUME_NONNULL_END
