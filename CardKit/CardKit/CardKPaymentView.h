//
//  UIView+CardKPaymentView.h
//  CardKit
//
//  Created by Alex Korotkov on 5/28/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>
#import "CardKViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardKPaymentView: UIView

@property UIViewController *controller;
@property (weak, nonatomic) id<CardKViewControllerDelegate> cKitDelegate;
@property NSString *merchantId;
@property PKPaymentRequest *paymentRequest;

@end

NS_ASSUME_NONNULL_END
