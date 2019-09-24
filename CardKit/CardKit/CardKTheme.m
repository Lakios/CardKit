//
//  CardKTheme.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKTheme.h"
#import <UIKit/UIKit.h>

static CardKTheme *__instance = nil;

@implementation CardKTheme
+ (CardKTheme *)defaultTheme {
  
  CardKTheme *theme = [[CardKTheme alloc] init];

  theme.colorLabel = UIColor.blackColor;
  theme.colorPlaceholder = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = UIColor.groupTableViewBackgroundColor;
  theme.colorCellBackground = UIColor.whiteColor;
  theme.imageAppearance = @"dark";
  theme.collorButtonText = UIColor.systemBlueColor;

  return theme;
}

+ (CardKTheme *)shared {
  if (__instance == nil) {
    if (@available(iOS 13.0, *)) {
      __instance = [CardKTheme systemTheme];
    } else {
      __instance = [CardKTheme defaultTheme];
    }
  }

  return __instance;
}

+ (void)setTheme:(CardKTheme *)theme {
  __instance = theme;
}

+ (CardKTheme *)darkTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];

  theme.colorHeader = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorPlaceholder = [UIColor colorWithRed:0.39f green:0.39f blue:0.40f alpha:1.0f];
  theme.colorTableBackground = [UIColor colorWithRed:0.10f green:0.10f blue:0.11f alpha:1.0f];
  theme.colorCellBackground = [UIColor colorWithRed:0.17f green:0.17f blue:0.18f alpha:1.0f];
  theme.separatarColor = [UIColor colorWithRed:0.10f green:0.10f blue:0.11f alpha:1.0f];
  theme.imageAppearance = @"dark";
  theme.collorButtonText = UIColor.systemBlueColor;
  
  return theme;
}

+ (CardKTheme *)lightTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];
    
  theme.colorLabel = UIColor.blackColor;
  theme.colorPlaceholder = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = [UIColor colorWithRed:0.95f green:0.95f blue:0.97f alpha:1.0f];
  theme.colorCellBackground = UIColor.whiteColor;
  theme.separatarColor = [UIColor colorWithRed:0.24f green:0.24f blue:0.26f alpha:0.29f];
  theme.imageAppearance = @"light";
  theme.collorButtonText = UIColor.systemBlueColor;
  
  return theme;
}

+ (CardKTheme *)systemTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];
  theme.colorLabel = UIColor.labelColor;
  theme.colorPlaceholder = UIColor.placeholderTextColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = UIColor.groupTableViewBackgroundColor;
  theme.colorCellBackground = nil;
  theme.separatarColor = UIColor.separatorColor;
  theme.imageAppearance = nil;
  theme.collorButtonText = UIColor.systemBlueColor;

  return theme;
}


@end
