//
//  UIViewController+CardKBankItem.h
//  CardKit
//
//  Created by Alex Korotkov on 5/20/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
  NSString *bindingId;
  NSString *systemProvider;
  NSString *cardNumber;
} SavedCard;

@interface SavedCardItem: UIView

@property SavedCard savedCard;

@end

NS_ASSUME_NONNULL_END
