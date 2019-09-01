//
//  CKitTheme.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKitTheme : NSObject

@property (strong, nonatomic) UIColor *colorHeader;
@property (strong, nonatomic) UIColor *colorLabel;
@property (strong, nonatomic) UIColor *colorPlaceholder;
@property (strong, nonatomic) UIColor *colorErrorLabel;
@property (strong, nonatomic) UIColor *colorTableBackground;
@property (strong, nonatomic) UIColor *colorCellBackground;


+ (CKitTheme *)defaultTheme;
+ (CKitTheme *)darkTheme;
+ (CKitTheme *)lightTheme;

@end

NS_ASSUME_NONNULL_END
