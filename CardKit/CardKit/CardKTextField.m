//
//  CardKTextField.m
//  CardKit
//
//  Created by Yury Korolev on 9/4/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKTextField.h"

NSString *CardKTextFieldPatternCardNumber = @"XXXXXXXXXXXXXXXX";
NSString *CardKTextFieldPatternExpirationDate = @"MMYY";
NSString *CardKTextFieldPatternSecureCode = @"XXX";

@interface CardKTextField () <UITextFieldDelegate>

@end

@implementation CardKTextField {
  UILabel *_patternLabel;
  UILabel *_formatLabel;
  UITextField *_textField;
  
  NSString *_pattern;
  CGSize _intrinsicContentSize;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    UIViewAutoresizing mask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.autoresizingMask = mask;
    
    _patternLabel = [[UILabel alloc] init];
    _formatLabel = [[UILabel alloc] init];
    _textField = [[UITextField alloc] init];
    [_textField addTarget:self action:@selector(_editingChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIFont *font = [UIFont fontWithName:@"Menlo" size:_patternLabel.font.pointSize];
    
    _patternLabel.font = font;
    _textField.font = font;
    _formatLabel.font = font;
    _patternLabel.textColor = [UIColor placeholderTextColor];
    _formatLabel.textColor = _textField.textColor;
    
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
//    _textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    for (UIView *v in @[_patternLabel, _textField, _formatLabel]) {
      [self addSubview:v];
    }
    
    _textField.delegate = self;
    
    self.clipsToBounds = true;
  }
  
  return self;
}

- (NSString *)pattern {
  return _pattern;
}

- (void)setPattern:(NSString *)pattern {
  _pattern = pattern;
  UILabel *label = [[UILabel alloc] init];
  label.font = _textField.font;
  label.text = _pattern;
  label.attributedText = [self _formatValue:label.attributedText];
  CGSize size = label.intrinsicContentSize;
  size.width += _textField.leftView.frame.size.width + _textField.rightView.frame.size.width + 8;
  _intrinsicContentSize = size;
}

- (NSString *)placeholder {
  return _textField.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
  _textField.placeholder = placeholder;
}

- (void)setFormat:(NSString *)format {
  _formatLabel.text = format;
}

- (NSString *)format {
  return _formatLabel.text;
}

- (UITextContentType)textContentType {
  return _textField.textContentType;
}

- (void)setTextContentType:(UITextContentType)textContentType {
  _textField.textContentType = textContentType;
}

- (UIKeyboardType)keyboardType {
  return _textField.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
  _textField.keyboardType = keyboardType;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if (!_pattern) {
    return YES;
  }
  
  NSUInteger currentLength = [textField.text length];
  NSUInteger replacementLength = [string length];
  NSUInteger rangeLength = range.length;
  NSUInteger newLength = currentLength - rangeLength + replacementLength;
  
  return _pattern.length >= newLength;
}

- (CGSize)intrinsicContentSize {
  return _intrinsicContentSize;
}


- (void)_editingChange:(UITextField *)textField
{
  NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
  
  textField.attributedText = [self _formatValue:textField.attributedText];
  
  UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:targetCursorPosition];
     [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
  
  NSInteger len = textField.text.length;
  [_patternLabel setHidden: len == 0];
  
  NSMutableString *pattern = [_pattern mutableCopy];
  [pattern replaceOccurrencesOfString:@"X" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, MIN(len, pattern.length))];
  [pattern replaceOccurrencesOfString:@"M" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, MIN(len, pattern.length))];
  [pattern replaceOccurrencesOfString:@"Y" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, MIN(len, pattern.length))];
  _patternLabel.text = pattern;
  _patternLabel.attributedText = [self _formatValue:_patternLabel.attributedText];
  
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
  // TODO: check valid value
  if (len == _pattern.length) {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }
}

- (BOOL)becomeFirstResponder {
  return [_textField becomeFirstResponder];
}

- (NSAttributedString *)_formatValue: (NSAttributedString *)str {
  if ([_pattern isEqualToString:CardKTextFieldPatternCardNumber]) {
    return [self _formatCard: str];
  }
  
  if ([_pattern isEqualToString:CardKTextFieldPatternExpirationDate]) {
    return [self _formatExpireDate: str];
  }
  
  return str;
}

- (NSAttributedString *)_formatByPattern:(NSAttributedString *)strValue pattern:(NSArray<NSNumber *> *)segments {
  if (!strValue) {
    return strValue;
  }
  NSMutableAttributedString * str = [strValue mutableCopy];
  
  NSUInteger index = 0;
  for (NSNumber *segmentLength in segments) {
      NSUInteger segmentIndex = 0;
      for (; index < str.length && segmentIndex < [segmentLength unsignedIntegerValue]; index++, segmentIndex++) {
          if (index + 1 != str.length && segmentIndex + 1 == [segmentLength unsignedIntegerValue]) {
              [str addAttribute:NSKernAttributeName value:@(9)
                                       range:NSMakeRange(index, 1)];
          } else {
              [str addAttribute:NSKernAttributeName value:@(0)
                                       range:NSMakeRange(index, 1)];
          }
      }
  }
  
  return str;
}

- (NSAttributedString *)_formatCard:(NSAttributedString *)strValue {
  return [self _formatByPattern:strValue pattern:@[@(4),@(4),@(4),@(4),@(3)]];
}

- (NSAttributedString *)_formatExpireDate:(NSAttributedString *)strValue {
  return [self _formatByPattern:strValue pattern:@[@(2),@(2)]];
}

- (NSString *)text {
  return _textField.text;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize boundsSize = self.bounds.size;
  
  _textField.frame = CGRectMake(0, 0, MAX(_intrinsicContentSize.width, boundsSize.width), boundsSize.height);
  for (UIView *v in @[_formatLabel, _patternLabel]) {
    v.frame = CGRectMake(_textField.leftView.bounds.size.width, 0, MAX(_intrinsicContentSize.width, boundsSize.width), boundsSize.height);
  }

  if (_textField.text.length == 0) {
    return;
  }
  
  CGFloat delta = boundsSize.width - _intrinsicContentSize.width;
  
  if (delta < -6) {
//    for (UIView *v in self.subviews) {
//      v.frame = CGRectMake(delta, 0, _intrinsicContentSize.width, boundsSize.height);
//    }
    _textField.frame = CGRectMake(delta, 0, _intrinsicContentSize.width, boundsSize.height);
    for (UIView *v in @[_formatLabel, _patternLabel]) {
      v.frame = CGRectMake(_textField.leftView.bounds.size.width + delta, 0, _intrinsicContentSize.width, boundsSize.height);
    }
  }
}

@end
