//
//  CardKViewController.h
//  CardKit
//
//  Created by Yury Korolev on 01.09.2019.
//  Copyright © 2019 AnjLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardKTheme.h"

NS_ASSUME_NONNULL_BEGIN

@class CardKViewController;

@protocol CardKViewControllerDelegate <NSObject>

- (void)cardKitViewController:(CardKViewController *)controller didCreateSeToken:(NSString *)seToken;
@optional - (void)cardKitViewControllerScanCardRequest:(CardKViewController *)controller;

@end


@interface CardKViewController : UITableViewController

@property (weak, nonatomic) id<CardKViewControllerDelegate> cKitDelegate;
@property (strong) NSString * purchaseButtonTitle;
@property BOOL allowedCardScaner;

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder;
- (void)setCardNumber:(nullable NSString *)number holderName:(nullable NSString *)holderName expirationDate:(nullable NSString *)date cvc:(nullable NSString *)cvc;

- (void)showScanCardView:(UIView *)view animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
