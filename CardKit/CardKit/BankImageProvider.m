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
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _queue = dispatch_queue_create("bank.image.provider.queue", DISPATCH_QUEUE_SERIAL);
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
  
}


@end
