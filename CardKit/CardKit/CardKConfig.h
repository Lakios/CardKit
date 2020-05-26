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
#import "CardKBinding.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKConfig : NSObject

@property (strong, nonatomic) CardKTheme *theme;
@property (nullable, strong, nonatomic) NSString *language;

@property (class, readonly, strong, nonatomic) CardKConfig *shared;

/*! Разрешить сохранение карты*/
@property BOOL allowSaveBindings;

/*! Разрешить использование apple pay*/
@property BOOL allowApplePay;

/*! Обязательный ввод CVC*/
@property BOOL bindingCVCRequired;

/*! Массив связок*/
@property NSArray<CardKBinding *> *bindings;

@end

NS_ASSUME_NONNULL_END
