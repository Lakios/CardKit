//
//  BankLogoView.m
//  CardKit
//
//  Created by Yury Korolev on 9/5/19.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "CardKBankLogoView.h"
#import <WebKit/WebKit.h>

@interface CardKWebView: WKWebView {
}
@end

@implementation CardKWebView {
}
- (BOOL)canResignFirstResponder
{
  return NO;
}

- (BOOL)becomeFirstResponder
{
  return NO;
}

- (void)_keyboardDidChangeFrame:(id)sender
{
  
}

- (void)_keyboardWillChangeFrame:(id)sender
{
  
}

- (void)_keyboardWillShow:(id)sender
{
  
}

- (void)_keyboardWillHide:(id)sender
{
  
}

@end

@interface CardKBankLogoView () <WKScriptMessageHandler>
@end


@implementation CardKBankLogoView {
  CardKWebView *_webView;
  UIView *_coverView;
  CardKTheme *_theme;
}

- (instancetype)init {
  
  if (self = [super init]) {
     _theme = [CardKTheme shared];
    _coverView = [[UIView alloc] init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"interOp"];
    _webView = [[CardKWebView alloc] initWithFrame:CGRectZero configuration: configuration];
    [self addSubview:_webView];
    _coverView.backgroundColor = _theme.colorTableBackground;
    _webView.backgroundColor = _theme.colorTableBackground;
    [self addSubview:_coverView];
    
    NSBundle *bundle = [NSBundle bundleForClass:[CardKBankLogoView class]];
    NSString *path = [bundle pathForResource:@"index" ofType:@"html" inDirectory:@"banks-info"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [_webView loadFileURL:url allowingReadAccessToURL:url];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _webView.frame = CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20);
  _coverView.frame = self.bounds;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
  [_webView setOpaque:NO];
  _webView.backgroundColor = UIColor.clearColor;
}

- (void)showNumber:(NSString *)number {
  if (number.length < 6) {
    [_coverView setHidden:NO];
    return;
  }
  NSString *imageAppearance = _theme.imageAppearance;

  if (imageAppearance == nil) {
    if (@available(iOS 12.0, *)) {
      if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        imageAppearance = @"dark";
      } else {
        imageAppearance = @"light";
      }
    } else {
      imageAppearance = @"light";
    }
  }
  
  NSString *script = [NSString stringWithFormat:@"__showBank(\"%@\", %d);", number, [imageAppearance isEqualToString:@"dark"]];
  
  UIView *coverView = _coverView;
  
  [_webView evaluateJavaScript:script completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
    [coverView setHidden:YES];
  }];
}

@end

