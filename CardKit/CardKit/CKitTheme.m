//
//  CKitTheme.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CKitTheme.h"
#import <UIKit/UIKit.h>
@implementation CKitTheme

+ (CKitTheme *)defaultTheme {
  CKitTheme *theme = [[CKitTheme alloc] init];

  theme.colorHeader = UIColor.grayColor;
  theme.colorLabel = UIColor.blackColor;
  theme.colorPlaceholder = UIColor.grayColor;
  theme.colorErrorLabel = UIColor.redColor;
  theme.colorTableBackground = UIColor.groupTableViewBackgroundColor;
  theme.colorCellBackground = UIColor.whiteColor;
  
  return theme;
}

+ (CKitTheme *)darkTheme {
  return [CKitTheme defaultTheme];
}

+ (CKitTheme *)lightTheme {
  return [CKitTheme defaultTheme];
}

@end
