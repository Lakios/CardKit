//
//  BankImageProvider.m
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import "BankImageProvider.h"

@implementation BankImageProvider {
  dispatch_queue_t _queue;
  NSDictionary *_banksJSON;
  NSString *_lastPrefix;
  SVGKImage *_lastImage;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _queue = dispatch_queue_create(
      "bank.image.provider.queue",
      DISPATCH_QUEUE_SERIAL
    );
  }
  return self;
}

- (void)preloadData {
  __weak typeof(self) weakSelf = self;
  
  dispatch_async(_queue, ^{
    [weakSelf _loadJson];
  });
}

- (void)_loadJson {
  NSBundle *bundle = [NSBundle bundleForClass:[BankImageProvider class]];
  
//  NSJSONSerialization 
}

- (NSString *)_prefixFromCardNumber:(NSString *)cardNumber {
  return @"";
}

- (SVGKImage *)svgImageForNumber:(NSString *)number {
  
  NSString *prefix = [self _prefixFromCardNumber:number];
  // catching
  if ([prefix isEqual:_lastPrefix] && _lastImage) {
    return _lastImage;
  }
  
  __block SVGKImage *result = nil;
  
  dispatch_sync(_queue, ^{
    result = nil;
  });
  
  _lastPrefix = prefix;
  _lastImage = result;
  
  return result;
}


@end
