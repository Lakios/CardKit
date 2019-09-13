//
//  CardKTextField.h
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *CardKTextFieldPatternCardNumber;
extern NSString *CardKTextFieldPatternExpirationDate;
extern NSString *CardKTextFieldPatternSecureCode;

@interface CardKTextField : UIControl

@property (readonly) NSString *text;
@property (strong) NSString * pattern;
@property (strong) NSString * placeholder;
@property (strong) NSString * format;
@property BOOL secureTextEntry;
@property UIKeyboardType keyboardType;
@property(null_unspecified,nonatomic,copy) UITextContentType textContentType;
@property (strong) CardKTheme *theme;
@property BOOL showError;

@end

NS_ASSUME_NONNULL_END
