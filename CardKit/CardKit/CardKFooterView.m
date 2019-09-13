//
//  CardKFooterView.m
//  CardKit
//
//  Created by Alex Korotkov on 9/13/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKFooterView.h"

@interface CardKFooterView ()

@end

@implementation CardKFooterView {
  NSArray *_errorMessages;
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_label];
  }
  return self;
}

- (NSArray *)errorMessages {
  return _errorMessages;
}

- (void)setErrorMessages:(NSArray *)errorMessages{
  if ([errorMessages count] > 0) {
    _label.frame = CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
    [_label setText:errorMessages[0]];
  } else {
    [_label setText:@""];
  }
  _errorMessages = errorMessages;
}


@end
