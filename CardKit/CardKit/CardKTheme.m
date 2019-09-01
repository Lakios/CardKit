//
//  CardKTheme.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKTheme.h"
#import <UIKit/UIKit.h>

@implementation CardKTheme

+ (CardKTheme *)defaultTheme {
  CardKTheme *theme = [[CardKTheme alloc] init];

  theme.colorHeader = UIColor.grayColor;
  theme.colorLabel = UIColor.blackColor;
  theme.colorPlaceholder = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = UIColor.groupTableViewBackgroundColor;
  theme.colorCellBackground = UIColor.whiteColor;
  
  return theme;
}

+ (CardKTheme *)darkTheme {
  return [CardKTheme defaultTheme];
}

+ (CardKTheme *)lightTheme {
  return [CardKTheme defaultTheme];
}

@end
