//
//  NSObject+CardKSwitchView.m
//  CardKit
//
//  Created by Alex Korotkov on 5/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import "CardKSwitchView.h"
#import "CardKTheme.h"
#import "CardKConfig.h"

@interface CardKSwitchView ()

@end

@implementation CardKSwitchView {
  NSBundle *_bundle;
  NSBundle *_languageBundle;
  UISwitch *_toggle;
  UILabel *_titleLabel;
  NSString *_title;
  CardKTheme *_theme;
}


- (instancetype)init {
  
  self = [super init];
  
  if (self) {
    _theme = CardKConfig.shared.theme;

    _bundle = [NSBundle bundleForClass:[CardKSwitchView class]];

    NSString *language = CardKConfig.shared.language;
    if (language != nil) {
      _languageBundle = [NSBundle bundleWithPath:[_bundle pathForResource:language ofType:@"lproj"]];
    } else {
      _languageBundle = _bundle;
    }
      
      
    _toggle = [[UISwitch alloc] init];
    [_toggle setOn:YES];
    [_toggle addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];

    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTextColor: _theme.colorPlaceholder];
    _titleLabel.text = NSLocalizedStringFromTableInBundle(@"switchViewTitle", nil, _languageBundle, @"Save card's data");
    [self addSubview:_titleLabel];
    [self addSubview:_toggle];
  }
  
  return self;
}

- (void) switchIsChanged:(UISwitch *)paramSender{
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize boundsSize = self.bounds.size;

  if (@available(iOS 11.0, *)) {
    _toggle.frame = CGRectMake(self.safeAreaInsets.left + 5, 6, 50, 44);
    _titleLabel.frame = CGRectMake(self.safeAreaInsets.left + 60, 0, boundsSize.width - 50, 44);
  }
}

@end
