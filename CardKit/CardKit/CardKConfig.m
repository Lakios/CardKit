//
//  CardKConfig.m
//  CardKit
//
//  Created by Alex Korotkov on 10/1/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKConfig.h"

static CardKConfig *__instance = nil;

@implementation CardKConfig

+ (CardKConfig *)defaultConfig {

  CardKConfig *config = [[CardKConfig alloc] init];

  config.theme = CardKTheme.defaultTheme;
  config.language = nil;
  
  return config;
}

+ (CardKConfig *)shared {
  if (__instance == nil) {
    __instance = [CardKConfig defaultConfig];
  }

  return __instance;
}

@end
