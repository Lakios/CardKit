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

- (void) cardKitViewController:(CardKViewController *)controller didCreateSeToken:(NSString *) seToken;

@end


@interface CardKViewController : UITableViewController

@property (weak, nonatomic) id<CardKViewControllerDelegate> cKitDelegate;
@property (strong) NSString * purchaseButtonTitle;

- (instancetype)initWithPublicKey:(NSString *)pubKey mdOrder:(NSString *)mdOrder;

@end

NS_ASSUME_NONNULL_END
