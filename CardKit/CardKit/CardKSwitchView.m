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

      
    _toggle = [[UISwitch alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    [_toggle setOn:YES];
    [_toggle addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];

    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTextColor: _theme.colorPlaceholder];
  
    [self addSubview:_titleLabel];
    [self addSubview:_toggle];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  
  return self;
}

- (void) switchIsChanged:(UISwitch *)paramSender{
}

- (void)setTitle:(NSString *)title {
  _titleLabel.text = title;
  _title = title;
}

- (NSString *)title {
  return _title;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  _toggle.frame = CGRectMake(5, 6, 50, 44);
  _titleLabel.frame = CGRectMake(60, 0, 1000, 44);
}

@end
